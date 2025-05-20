const fs = require('fs');
const path = require('path');

const postDir = path.join(__dirname, '..', 'blog', 'post');
const outputFile = path.join(postDir, 'file-list.json');

function buildFileList(dirPath) {
  const items = fs.readdirSync(dirPath);
  const result = {};

  const folders = [];
  const files = [];

  items.forEach(item => {
    const itemPath = path.join(dirPath, item);
    const stat = fs.statSync(itemPath);

    if (stat.isDirectory()) {
      // Ignore .github and scripts directories
      if (item === '.github' || item === 'scripts') {
        return;
      }
      folders.push(item);
    } else if (stat.isFile() && item.endsWith('.md')) {
      files.push(item);
    }
  });

  // Process folders first
  folders.forEach(item => {
    const itemPath = path.join(dirPath, item);
    result[item] = {
      type: 'folder',
      children: buildFileList(itemPath)
    };
  });

  // Then process files
  files.forEach(item => {
    const itemPath = path.join(dirPath, item);
    const relativePath = path.relative(postDir, itemPath);
    result[item] = {
      type: 'file',
      path: relativePath.replace(/\\/g, '/') // Use path relative to blog/post
    };
  });

  return result;
}

const fileList = {
  _post: {
    type: 'folder',
    children: buildFileList(postDir)
  }
};

fs.writeFileSync(outputFile, JSON.stringify(fileList, null, 2));
console.log(`Successfully generated ${outputFile}`);