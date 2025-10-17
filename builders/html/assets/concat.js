#!/usr/bin/env node

/**
 * Concatenate JavaScript files for the build
 * This script handles glob patterns correctly on Windows
 *
 * IMPORTANT: Files are sorted alphabetically, but content.js must come
 * before webfont.js and winresize.js because they depend on contentFixPushCal()
 */

const fs = require( 'fs' );
const path = require( 'path' );
const glob = require( 'glob' );

// Get all source files and sort them alphabetically (cross-platform consistent)
let sourceFiles = glob.sync( 'js/src/*.js' ).sort();

// Check dependencies: content.js defines contentFixPushCal, which is used by webfont.js and winresize.js
const contentIndex = sourceFiles.findIndex( f => f.includes( 'content.js' ) );
const webfontIndex = sourceFiles.findIndex( f => f.includes( 'webfont.js' ) );
const winresizeIndex = sourceFiles.findIndex( f => f.includes( 'winresize.js' ) );

// If content.js comes after files that depend on it, reorder
if ( contentIndex > webfontIndex || contentIndex > winresizeIndex ) {
	const contentFile = sourceFiles[ contentIndex ];
	sourceFiles.splice( contentIndex, 1 );
	// Insert content.js before the earliest dependent file
	const insertIndex = Math.min(
		webfontIndex !== -1 ? webfontIndex : Infinity,
		winresizeIndex !== -1 ? winresizeIndex : Infinity
	);
	sourceFiles.splice( insertIndex, 0, contentFile );
	console.log( '  ℹ Reordered content.js to satisfy dependencies' );
}

const files = [
	'js/jquery-3.7.1.js',
	...sourceFiles,
	// TryCF Editor files
	'trycf/js/angular.min.js',
	'trycf/js/split-pane.js',
	'trycf/js/docscodeloader.js',
	'trycf/js/code-editor3.js',
	'trycf/js/trycf.js'
];

const output = files.map( file => {
	console.log( `  → ${ file }` );
	return fs.readFileSync( file, 'utf8' );
} ).join( '\n\n' );

fs.writeFileSync( 'js/base.js', output );

console.log( `\n✓ Concatenated ${ files.length } files → js/base.js` );
