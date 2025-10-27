#!/usr/bin/env node

/**
 * Build a single ACE bundle with only what we need for TryCF editor
 */

const fs = require('fs');
const path = require('path');

const aceDir = path.join(__dirname, 'trycf', 'js', 'ace');
const nodeModulesAce = path.join(__dirname, 'node_modules', 'ace-builds', 'src-min-noconflict');
const files = [
	path.join(nodeModulesAce, 'ace.js'),
	path.join(nodeModulesAce, 'ext-language_tools.js'),
	path.join(nodeModulesAce, 'mode-coldfusion.js'),
	path.join(nodeModulesAce, 'theme-monokai.js'),
	path.join(nodeModulesAce, 'snippets', 'coldfusion.js')
	// No workers - disabled in HTML via ace.config.set("useWorker", false)
];

console.log('Building ACE bundle...');

const content = files.map(file => {
	console.log(`  → ${path.basename(file)}`);
	return fs.readFileSync(file, 'utf8');
}).join('\n\n');

// Write unversioned file
const outputFile = path.join(aceDir, 'ace-bundle.js');
fs.writeFileSync(outputFile, content);

console.log(`\n✓ Created ${outputFile}`);
console.log(`  Size: ${(content.length / 1024).toFixed(0)}KB`);

// Create versioned copy
const packageJson = require('./package.json');
const version = packageJson.config.assetVersion;
const versionedFile = path.join(aceDir, `ace-bundle.${version}.js`);

fs.copyFileSync(outputFile, versionedFile);
console.log(`✓ Copied to ${versionedFile}`);

// Auto-copy to builds directory if it exists
const buildsDir = path.join(__dirname, '..', '..', '..', 'builds', 'html', 'assets', 'trycf', 'js', 'ace');
if (fs.existsSync(buildsDir)) {
	const buildsDest = path.join(buildsDir, `ace-bundle.${version}.js`);
	fs.copyFileSync(outputFile, buildsDest);
	console.log(`✓ Auto-copied to ${buildsDest}`);
}
