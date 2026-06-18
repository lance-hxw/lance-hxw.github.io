```go
// CorrectDefaultWeamName 用于修正符合特定条件用户的WeAMName：
// 当用户的更新时间戳ut=0，显示名name非默认，但WeAMName仍为默认格式（如userXXX）时，
// 此函数会尝试基于用户的name生成新的WeAMName并更新。
func CorrectDefaultWeamName(ctx context.Context, mid int64, name string, currentWeamName string, updateTimestamp int64) (err error) {
	logger.WithCtx(ctx).Info("CorrectDefaultWeamName started for mid: %d, name: '%s', currentWeamName: '%s', ut: %d", mid, name, currentWeamName, updateTimestamp)

	isNameDefault := strings.HasPrefix(strings.ToLower(name), "user")
	isWeamNameDefault := strings.HasPrefix(strings.ToLower(currentWeamName), "user")

	if updateTimestamp == 0 && !isNameDefault && isWeamNameDefault {
		logger.WithCtx(ctx).Info("Mid %d meets criteria: ut=0, name non-default ('%s'), weamName default ('%s'). Attempting correction.", mid, name, currentWeamName)

		memberInfo, getMemberErr := getMember(ctx, mid, false, false) // master=false, allowNil=false
		if getMemberErr != nil {
			err = errors.Wrapf(getMemberErr, "failed to retrieve member details for mid %d", mid)
			logger.WithCtx(ctx).Error(err.Error())
			return
		}
		if memberInfo == nil {
			err = errors.Errorf("member with mid %d not found", mid)
			logger.WithCtx(ctx).Error(err.Error())
			return
		}

		amID := memberInfo.GetWeamid()
		if len(amID) == 0 {
			err = errors.Errorf("member mid %d has an empty amID; cannot reliably generate or lock a new weamName", mid)
			logger.WithCtx(ctx).Error(err.Error())
			return
		}
		logger.WithCtx(ctx).Info("Mid %d: Retrieved amID '%s'.", mid, amID)

		baseForAmName := strings.ReplaceAll(name, " ", "")
		if len(baseForAmName) == 0 {
			logger.WithCtx(ctx).Warn("Mid %d: Name '%s' becomes empty after removing spaces. Cannot generate weamName.", mid, name)
			return nil
		}

		if len(baseForAmName) > 24 {
			baseForAmName = baseForAmName[:24]
			logger.WithCtx(ctx).Info("Mid %d: Base for amName ('%s') truncated to 24 chars: '%s'.", mid, name, baseForAmName)
		}

		var newAmName string
		foundNewAmName := false
		for i := 0; i < 104; i++ { // Try base, base_, base__, base+Num[00-99], base+amID
			var candidateAmName string
			switch i {
			case 0:
				candidateAmName = baseForAmName
			case 1:
				candidateAmName = baseForAmName + "_"
			case 2:
				candidateAmName = baseForAmName + "__"
			default:
				if i >= 3 && i <= 102 { // 100 numeric suffixes (i-3 gives 0 to 99)
					numericSuffix := i - 3
					candidateAmName = fmt.Sprintf("%s%02d", baseForAmName, numericSuffix)
				} else if i == 103 { // amID suffix
					candidateAmName = fmt.Sprintf("%s%s", baseForAmName, amID)
				} else {
					logger.WithCtx(ctx).Error("Mid %d: Unexpected loop index %d in weamName generation. Skipping.", mid, i)
					continue
				}
			}

			if len(candidateAmName) == 0 {
				logger.WithCtx(ctx).Warn("Mid %d: Generated an empty candidateAmName at attempt %d (base: '%s'). Skipping.", mid, i, baseForAmName)
				continue
			}

			isValidCandidate, checkNameReason := gatewaymember.CheckName(candidateAmName, "AmName")
			if !isValidCandidate {
				logger.WithCtx(ctx).Info("Mid %d: Candidate weamName '%s' (attempt %d) is invalid: '%s'. Skipping.", mid, candidateAmName, i, checkNameReason)
				continue
			}

			if strings.EqualFold(candidateAmName, currentWeamName) {
				logger.WithCtx(ctx).Info("Mid %d: Candidate weamName '%s' (attempt %d) is same as currentWeamName. Skipping.", mid, candidateAmName, i)
				continue
			}

			lockErr := lockNewMemberAmName(ctx, candidateAmName, amID)
			if lockErr != nil {
				errMsg := lockErr.Error()
				if strings.Contains(strings.ToLower(errMsg), "already exists") || strings.Contains(strings.ToLower(errMsg), "not obtained") {
					logger.WithCtx(ctx).Info("Mid %d: Lock failed for candidate '%s' (attempt %d): '%s'. Trying next.", mid, candidateAmName, i, errMsg)
					continue
				}
				err = errors.Wrapf(lockErr, "unexpected error locking new weamName '%s' for mid %d (attempt %d)", candidateAmName, mid, i)
				logger.WithCtx(ctx).Error(err.Error())
				return
			}

			newAmName = candidateAmName
			foundNewAmName = true
			logger.WithCtx(ctx).Info("Mid %d: Successfully generated and locked new weamName '%s' (using amID '%s') on attempt %d.", mid, newAmName, amID, i)
			break
		}

		if !foundNewAmName {
			err = errors.Errorf("mid %d: failed to generate and lock a unique weamName based on name '%s' (amID '%s') after %d attempts", mid, name, amID, 104)
			logger.WithCtx(ctx).Warn(err.Error())
			return
		}

		logger.WithCtx(ctx).Info("Mid %d: Attempting to update weamName in DB from '%s' to '%s'.", mid, currentWeamName, newAmName)
		updateMsg, updateErr := updateMemberWeAMName(ctx, mid, newAmName, false)

		if updateErr != nil {
			err = errors.Wrapf(updateErr, "updateMemberWeAMName failed for mid %d with new weamName '%s'", mid, newAmName)
			logger.WithCtx(ctx).Error(err.Error())
			cleanupErr := redisModel.DelLockAmName(ctx, newAmName)
			if cleanupErr != nil {
				logger.WithCtx(ctx).Error("Mid %d: Failed to cleanup reservation for amName '%s' after DB update error: %v", mid, newAmName, cleanupErr)
			}
			return
		}
		if len(updateMsg) > 0 {
			err = errors.Errorf("mid %d: updateMemberWeAMName reported a message for new weamName '%s': '%s'", mid, newAmName, updateMsg)
			logger.WithCtx(ctx).Warn(err.Error())
			cleanupErr := redisModel.DelLockAmName(ctx, newAmName)
			if cleanupErr != nil {
				logger.WithCtx(ctx).Error("Mid %d: Failed to cleanup reservation for amName '%s' after update reported message: %v", mid, newAmName, cleanupErr)
			}
			return
		}

		logger.WithCtx(ctx).Info("Mid %d: Successfully corrected and updated weamName from '%s' to '%s'.", mid, currentWeamName, newAmName)

	} else {
		logger.WithCtx(ctx).Info("Mid %d: Conditions for weamName correction not met (ut: %d, nameIsDefault: %t, weamNameIsDefault: %t). No action taken.", mid, updateTimestamp, isNameDefault, isWeamNameDefault)
	}

	return nil
}

```