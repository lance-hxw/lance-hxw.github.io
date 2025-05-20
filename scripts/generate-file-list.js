const fs = require('fs');
const path = require('path');

const mdDir = path.join(__dirname, '..', 'md');
const outputFile = path.join(mdDir, 'file-list.json');

function buildFileList(dirPath) {
  const items = fs.readdirSync(dirPath);
  const result = {};

  items.forEach(item => {
    const itemPath = path.join(dirPath, item);
    const stat = fs.statSync(itemPath);
    const relativePath = path.relative(mdDir, itemPath);

    if (stat.isDirectory()) {
      // Ignore .github and scripts directories
      if (item === '.github' || item === 'scripts') {
        return;
      }
      result[item] = {
        type: 'folder',
        children: buildFileList(itemPath)
      };
    } else if (stat.isFile() && item.endsWith('.md')) {
      result[item] = {
        type: 'file',
        path: path.join('../md', relativePath).replace(/\\/g, '/') // Use forward slashes for URL paths
      };
    }
  });

  return result;
}

const fileList = {
  md: {
    type: 'folder',
    children: buildFileList(mdDir)
  }
};

fs.writeFileSync(outputFile, JSON.stringify(fileList, null, 2));
console.log(`Successfully generated ${outputFile}`);