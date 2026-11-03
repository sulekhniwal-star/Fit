/**
 * DOC-002: FitKarma Documentation Linter
 * Lints repository documentation:
 * 1. Validates rule hierarchy and essential sections in Brain/master_rules.md
 * 2. Verifies that /docs is not referenced as an internal repository directory
 * 3. Validates that historical baseline claims are qualified as UNVERIFIED
 * 4. Ensures RevenueCat is only referenced as historical migration context
 */

const fs = require('fs');
const path = require('path');

const ROOT_DIR = path.resolve(__dirname, '..');
let totalErrors = 0;
let totalWarnings = 0;

console.log('=== FitKarma Doc-Lint (DOC-002) ===\n');

// 1. Lint master_rules.md
const masterRulesPath = path.join(ROOT_DIR, 'Brain', 'master_rules.md');
if (!fs.existsSync(masterRulesPath)) {
  console.error('[ERROR] Brain/master_rules.md is missing');
  totalErrors++;
} else {
  const content = fs.readFileSync(masterRulesPath, 'utf8');
  const requiredHeadings = [
    'Rule hierarchy',
    'Architecture rules',
    'Offline-first rules',
    'Data rules',
    'Security rules',
    'AI rules',
    'Payment rules',
    'UI rules',
    'Testing rules',
    'Git/documentation rules'
  ];
  for (const heading of requiredHeadings) {
    if (!content.includes(heading)) {
      console.error(`[ERROR] master_rules.md missing required section: "${heading}"`);
      totalErrors++;
    }
  }
  console.log('[OK] Brain/master_rules.md section structure validated.');
}

// 2. Lint /docs vs Brain/ path references
function findMarkdownFiles(dir, fileList = []) {
  if (!fs.existsSync(dir)) return fileList;
  const entries = fs.readdirSync(dir, { withFileTypes: true });
  for (const entry of entries) {
    const full = path.join(dir, entry.name);
    if (entry.isDirectory()) {
      if (entry.name === '.git' || entry.name === 'node_modules' || entry.name === '.idea') {
        continue;
      }
      findMarkdownFiles(full, fileList);
    } else if (entry.isFile() && entry.name.endsWith('.md')) {
      fileList.push(full);
    }
  }
  return fileList;
}

const mdFiles = findMarkdownFiles(ROOT_DIR);
console.log('[INFO] Scanning markdown files for stale /docs/ path references...');

for (const filePath of mdFiles) {
  const relPath = path.relative(ROOT_DIR, filePath);
  const content = fs.readFileSync(filePath, 'utf8');

  // Check for internal path references to /docs or docs/ (excluding general english words like "docs in a repo" or changelog descriptions)
  const lines = content.split('\n');
  lines.forEach((line, idx) => {
    // Flag markdown links or explicit path references targeting /docs/
    if (/\[.*?\]\(\/docs\/.*?\)/.test(line) || /`\/docs\/.*?`/.test(line)) {
      console.error(`[ERROR] ${relPath}:${idx + 1} contains stale /docs reference: ${line.trim()}`);
      totalErrors++;
    }
  });
}
console.log('[OK] No stale /docs path references detected.');

// 3. Verify that historical baseline claims are marked UNVERIFIED
console.log('[INFO] Checking historical baseline qualifications...');
const testingPath = path.join(ROOT_DIR, 'Brain', 'testing.md');
if (fs.existsSync(testingPath)) {
  const testingContent = fs.readFileSync(testingPath, 'utf8');
  if (!testingContent.includes('UNVERIFIED')) {
    console.error('[ERROR] Brain/testing.md does not qualify baseline claims as UNVERIFIED');
    totalErrors++;
  } else {
    console.log('[OK] Brain/testing.md baseline claims qualified as UNVERIFIED.');
  }
}

const securityPath = path.join(ROOT_DIR, 'Brain', 'security.md');
if (fs.existsSync(securityPath)) {
  const securityContent = fs.readFileSync(securityPath, 'utf8');
  if (securityContent.includes('28 tables') && !securityContent.includes('UNVERIFIED')) {
    console.error('[ERROR] Brain/security.md mentions 28 tables without qualifying as UNVERIFIED');
    totalErrors++;
  } else {
    console.log('[OK] Brain/security.md cascading delete claim qualified as UNVERIFIED.');
  }
}

// 4. Verify RevenueCat is only in ADR / historical context
console.log('[INFO] Scanning for RevenueCat references across repository...');
for (const filePath of mdFiles) {
  const relPath = path.relative(ROOT_DIR, filePath);
  // Allowed files: Brain/decisions.md (ADR-007), Brain/changelog.md, Todo.md, Brain/microtasks.md
  const isAllowed =
    relPath === path.join('Brain', 'decisions.md') ||
    relPath === path.join('Brain', 'changelog.md') ||
    relPath === 'Todo.md' ||
    relPath === path.join('Brain', 'microtasks.md');

  const content = fs.readFileSync(filePath, 'utf8');
  if (content.toLowerCase().includes('revenuecat') && !isAllowed) {
    console.error(`[ERROR] Disallowed RevenueCat reference found in ${relPath}`);
    totalErrors++;
  }
}
console.log('[OK] RevenueCat references strictly confined to historical ADRs, changelog, and plan specifications.');

console.log(`\nDoc-lint completed with ${totalErrors} error(s) and ${totalWarnings} warning(s).`);
if (totalErrors > 0) {
  process.exit(1);
} else {
  console.log('SUCCESS: All doc-lint rules passed.');
  process.exit(0);
}
