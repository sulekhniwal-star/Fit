const fs = require('fs');
const path = require('path');

const scanFiles = JSON.parse(fs.readFileSync('f:/Fit/.ua/tmp/ua-scan-files.json', 'utf8'));
const importMapOutput = JSON.parse(fs.readFileSync('f:/Fit/.ua/tmp/ua-import-map-output.json', 'utf8'));

const languages = Object.keys(scanFiles.stats.byLanguage).sort();
const frameworks = ['Flutter', 'Riverpod', 'Drift', 'Supabase'];

const description = "FitKarma — India's Intelligent Health Operating System built with Flutter, Riverpod, Drift, and Supabase. Note: this project has over 100 source files; consider scoping analysis to a subdirectory for faster results.";

const finalScanResult = {
  name: 'fitkarma',
  description: description,
  languages: languages,
  frameworks: frameworks,
  files: scanFiles.files,
  totalFiles: scanFiles.totalFiles,
  filteredByIgnore: scanFiles.filteredByIgnore,
  estimatedComplexity: scanFiles.estimatedComplexity,
  importMap: importMapOutput.importMap
};

fs.writeFileSync('f:/Fit/.ua/intermediate/scan-result.json', JSON.stringify(finalScanResult, null, 2));
console.log('Successfully wrote scan-result.json. Files:', finalScanResult.totalFiles);
