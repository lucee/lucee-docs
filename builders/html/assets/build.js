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

		// Read the JS file and update sourceMappingURL
		let jsContent = fs.readFileSync( src, 'utf8' );
		jsContent = jsContent.replace(
			/\/\/# sourceMappingURL=base\.min\.js\.map$/,
			`//# sourceMappingURL=base.${ version }.min.js.map`
		);
		fs.writeFileSync( dest, jsContent );
		console.log( `✓ Copied ${ src } → ${ dest }` );

		// Copy source map if it exists
		if ( fs.existsSync( `${ src }.map` ) ) {
			fs.copyFileSync( `${ src }.map`, `${ dest }.map` );
			console.log( `✓ Copied ${ src }.map → ${ dest }.map` );
		}
	}

	console.log( `\n✓ Version ${ version } assets ready!` );
	console.log( `\nReminder: Update assetBundleVersion in Application.cfc to match version ${ version }` );

	// Auto-copy to builds/html/assets if it exists
	const htmlBuildDir = path.join( __dirname, '..', '..', '..', 'builds', 'html', 'assets' );
	if ( fs.existsSync( htmlBuildDir ) ) {
		if ( type === 'css' ) {
			const cssDir = path.join( htmlBuildDir, 'css' );
			if ( !fs.existsSync( cssDir ) ) {
				fs.mkdirSync( cssDir, { recursive: true } );
			}
			const dest = path.join( cssDir, `base.${ version }.min.css` );
			fs.copyFileSync( `css/base.${ version }.min.css`, dest );
			console.log( `✓ Auto-copied to ${ dest }` );

			if ( fs.existsSync( `css/base.${ version }.min.css.map` ) ) {
				fs.copyFileSync( `css/base.${ version }.min.css.map`, `${ dest }.map` );
			}
		}

		if ( type === 'js' ) {
			const jsDistDir = path.join( htmlBuildDir, 'js', 'dist' );
			if ( !fs.existsSync( jsDistDir ) ) {
				fs.mkdirSync( jsDistDir, { recursive: true } );
			}
			const dest = path.join( jsDistDir, `base.${ version }.min.js` );
			fs.copyFileSync( `js/dist/base.${ version }.min.js`, dest );
			console.log( `✓ Auto-copied to ${ dest }` );

			if ( fs.existsSync( `js/dist/base.${ version }.min.js.map` ) ) {
				fs.copyFileSync( `js/dist/base.${ version }.min.js.map`, `${ dest }.map` );
			}
		}
	}

} catch ( err ) {
	console.error( `ERROR: ${ err.message }` );
	process.exit( 1 );
}
