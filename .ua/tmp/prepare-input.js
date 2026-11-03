const fs = require('fs');
const scan = JSON.parse(fs.readFileSync('f:/Fit/.ua/tmp/ua-scan-files.json', 'utf8'));
const input = {
  projectRoot: 'f:/Fit',
  files: scan.files
};
fs.writeFileSync('f:/Fit/.ua/tmp/ua-import-map-input.json', JSON.stringify(input, null, 2));
