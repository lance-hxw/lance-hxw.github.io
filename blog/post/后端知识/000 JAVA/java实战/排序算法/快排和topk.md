# 对l-r区间进行一次分区
```java
int rev(int[] a, int l, int r){
	int mid = (l+r)/2;
	// 先放左边
	swap(a, mid, l);
	while(l<r){
		while(a[l]<a[r]){
			r--;
		}
		swap(a, l, r);
		while(a[l]<a[r]){
			l++;
		}
		swap(a, l, r);
	}
	return l;
}
int swap(int[] a, int x, int y){
	int tmp = a[x];
	a[x] = a[y];
	a[y] = tmp;
}
```
# 快排
```java
void quickSort(int[] a, int l, int r){
	int len = a.length;
	int l = 0, r = len - 1;
	int mid = quickSort(a, l, r);
	quickSort(a, l, mid-1);
	quickSort(a, mid+1, r);
}
```

# topK
```java
int findKth(int[] a, int k){
	int len = a.length;
	int l = 0, r = len-1;
	k--;
	while(true){
		int mid = rev(a, l, r);
		if(mid==k){
			return a[k];
		}else if(mid<k){
			l=mid+1;
		}else{
			r=mid-1;
		}
	}
}
```

## topk的堆排序
堆排序见