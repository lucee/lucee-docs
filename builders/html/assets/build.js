#!/usr/bin/env node

/**
 * Asset versioning script for Lucee documentation
 *
 * Copies the minified CSS/JS files to versioned filenames for cache busting.
 * The version number is read from package.json config.assetVersion
 *
 * Usage:
 *   node build.js css    - Copy CSS to versioned filename
 *   node build.js js     - Copy JS to versioned filename
 */

const fs = require( 'fs' );
const path = require( 'path' );
const packageJson = require( './package.json' );

const version = packageJson.config.assetVersion;
const type = process.argv[ 2 ];

if ( !version ) {
	console.error( 'ERROR: assetVersion not found in package.json config' );
	process.exit( 1 );
}

if ( !type || ![ 'css', 'js' ].includes( type ) ) {
	console.error( 'Usage: node build.js [css|js]' );
	process.exit( 1 );
}

try {
	if ( type === 'css' ) {
		const src = 'css/base.min.css';
		const dest = `css/base.${ version }.min.css`;

		fs.copyFileSync( src, dest );
		console.log( `✓ Copied ${ src } → ${ dest }` );

		// Copy source map if it exists
		if ( fs.existsSync( `${ src }.map` ) ) {
			fs.copyFileSync( `${ src }.map`, `${ dest }.map` );
			console.log( `✓ Copied ${ src }.map → ${ dest }.map` );
		}
	}

	if ( type === 'js' ) {
		const src = 'js/base.min.js';
		const dest = `js/dist/base.${ version }.min.js`;

		// Ensure dist directory exists
		if ( !fs.existsSync( 'js/dist' ) ) {
			fs.mkdirSync( 'js/dist', { recursive: true } );
		}

		fs.copyFileSync( src, dest );
		console.log( `✓ Copied ${ src } → ${ dest }` );

		// Copy source map if it exists
		if ( fs.existsSync( `${ src }.map` ) ) {
			fs.copyFileSync( `${ src }.map`, `${ dest }.map` );
			console.log( `✓ Copied ${ src }.map → ${ dest }.map` );
		}
	}

	console.log( `\n✓ Version ${ version } assets ready!` );
	console.log( `\nReminder: Update assetBundleVersion in Application.cfc to match version ${ version }` );

} catch ( err ) {
	console.error( `ERROR: ${ err.message }` );
	process.exit( 1 );
}
