/**
 * DOC-001: FitKarma Documentation Link Checker
 * Validates existence of required documentation and verifies that internal
 * links in markdown files resolve to existing files on disk.
 */

const fs = require('fs');
const path = require('path');

const ROOT_DIR = path.resolve(__dirname, '..');

const REQUIRED_FILES = [
  '.agent/skills/SKILL.md',
  'FitKarma_Master_Documentation_v1.md',
  'Todo.md',
  'Brain/master_rules.md',
  'Brain/pdr.md',
  'Brain/trd.md',
  'Brain/architecture.md',
  'Brain/data_model.md',
  'Brain/api_contract.md',
  'Brain/data_sources.md',
  'Brain/ui_spec.md',
  'Brain/security.md',
  'Brain/error_handling.md',
  'Brain/testing.md',
  'Brain/production_checklist.md',
  'Brain/github_actions.md',
  'Brain/admob_spec.md',
  'Brain/scrapping_spec.md',
  'Brain/decisions.md',
  'Brain/changelog.md',
  'Brain/microtasks.md',
  'Brain/implementation_audit.md',
];

let totalErrors = 0;

console.log('=== Checking Required Documentation Files ===');
for (const relPath of REQUIRED_FILES) {
  const fullPath = path.join(ROOT_DIR, relPath);
  if (!fs.existsSync(fullPath)) {
    console.error(`[MISSING FILE] Required documentation file missing: ${relPath}`);
    totalErrors++;
  } else {
    console.log(`  [OK] ${relPath}`);
  }
}

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

console.log('\n=== Checking Markdown Internal Links ===');
const mdFiles = findMarkdownFiles(ROOT_DIR);
const linkRegex = /\[([^\]]+)\]\(([^)]+)\)/g;

let linksChecked = 0;

for (const filePath of mdFiles) {
  const relFilePath = path.relative(ROOT_DIR, filePath);
  const content = fs.readFileSync(filePath, 'utf8');
  let match;

  while ((match = linkRegex.exec(content)) !== null) {
    const [, text, target] = match;
    const cleanTarget = target.trim();

    // Skip web links, mailto, scheme links, anchors, or markdown reference variables
    if (
      cleanTarget.startsWith('http://') ||
      cleanTarget.startsWith('https://') ||
      cleanTarget.startsWith('mailto:') ||
      cleanTarget.startsWith('file://') ||
      cleanTarget.startsWith('#') ||
      cleanTarget.startsWith('conversation://') ||
      cleanTarget.includes('<') ||
      cleanTarget.includes('>')
    ) {
      continue;
    }

    linksChecked++;
    // Remove anchor fragment
    const targetWithoutAnchor = cleanTarget.split('#')[0].trim();
    if (!targetWithoutAnchor) continue;

    // Resolve target path
    let resolvedTarget;
    if (targetWithoutAnchor.startsWith('/Brain/')) {
      resolvedTarget = path.join(ROOT_DIR, targetWithoutAnchor.slice(1));
    } else if (targetWithoutAnchor.startsWith('/')) {
      resolvedTarget = path.join(ROOT_DIR, targetWithoutAnchor.slice(1));
    } else {
      resolvedTarget = path.resolve(path.dirname(filePath), targetWithoutAnchor);
    }

    if (!fs.existsSync(resolvedTarget)) {
      console.error(`[BROKEN LINK] in ${relFilePath}: target "${cleanTarget}" does not exist (resolved to: ${path.relative(ROOT_DIR, resolvedTarget)})`);
      totalErrors++;
    }
  }
}

console.log(`\nChecked ${linksChecked} internal links across ${mdFiles.length} markdown files.`);

if (totalErrors > 0) {
  console.error(`\nFAILED: Found ${totalErrors} documentation error(s).`);
  process.exit(1);
} else {
  console.log('\nSUCCESS: All required documentation files and links resolved cleanly.');
  process.exit(0);
}

