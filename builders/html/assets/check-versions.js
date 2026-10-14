#!/usr/bin/env node

/**
 * Verify that asset version numbers are synchronized across all config files
 * Prevents deploying with mismatched versions that would break cache busting
 */

const fs = require('fs');
const path = require('path');

console.log('Checking asset version synchronization...\n');

// Read package.json version
const packageJson = require('./package.json');
const packageVersion = packageJson.config.assetVersion;
console.log(`✓ package.json: ${packageVersion}`);

// Read Application.cfc (main)
const appCfcPath = path.join(__dirname, '..', '..', '..', 'Application.cfc');
let appCfcVersion = null;
if (fs.existsSync(appCfcPath)) {
	const appCfcContent = fs.readFileSync(appCfcPath, 'utf8');
	const match = appCfcContent.match(/variables\.assetBundleVersion\s*=\s*(\d+)/);
	if (match) {
		appCfcVersion = match[1];
		console.log(`✓ Application.cfc: ${appCfcVersion}`);
	} else {
		console.error('✗ Could not find assetBundleVersion in Application.cfc');
		process.exit(1);
	}
} else {
	console.warn('⚠ Application.cfc not found (may be OK for local builds)');
}

// Read server/Application.cfc
const serverAppCfcPath = path.join(__dirname, '..', '..', '..', 'server', 'Application.cfc');
let serverAppCfcVersion = null;
if (fs.existsSync(serverAppCfcPath)) {
	const serverAppCfcContent = fs.readFileSync(serverAppCfcPath, 'utf8');
	const match = serverAppCfcContent.match(/this\.assetBundleVersion\s*=\s*(\d+)/);
	if (match) {
		serverAppCfcVersion = match[1];
		console.log(`✓ server/Application.cfc: ${serverAppCfcVersion}`);
	} else {
		console.error('✗ Could not find assetBundleVersion in server/Application.cfc');
		process.exit(1);
	}
} else {
	console.warn('⚠ server/Application.cfc not found (may be OK for local builds)');
}

// Compare versions
const versions = [packageVersion, appCfcVersion, serverAppCfcVersion].filter(v => v !== null);
const allMatch = versions.every(v => v === packageVersion);

console.log('');
if (allMatch) {
	console.log(`✓ All versions match: ${packageVersion}\n`);
	process.exit(0);
} else {
	console.error('✗ VERSION MISMATCH DETECTED!\n');
	console.error('Asset versions must be synchronized across all files:');
	console.error(`  package.json:              ${packageVersion}`);
	if (appCfcVersion) console.error(`  Application.cfc:           ${appCfcVersion}`);
	if (serverAppCfcVersion) console.error(`  server/Application.cfc:    ${serverAppCfcVersion}`);
	console.error('\nPlease update all files to use the same version number.');
	console.error('See builders/html/assets/README.md for instructions.\n');
	process.exit(1);
}
