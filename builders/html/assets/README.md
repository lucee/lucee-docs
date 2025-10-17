# Lucee Docs Assets Build System

Modern build system for compiling and bundling CSS and JavaScript assets for the Lucee documentation site.

## Requirements

- Node.js (v14 or later)
- npm (comes with Node.js)

**No Ruby required!** This build system uses pure JavaScript tooling.

## Quick Start

Install dependencies:

```bash
npm install
```

Build all assets:

```bash
npm run build
```

## Available Commands

### Production Build

```bash
npm run build
```

Compiles SCSS to CSS, concatenates and minifies JavaScript, and creates versioned output files ready for deployment.

### Development Watch Mode

```bash
npm run watch
```

Watches for changes to SCSS and JS files and automatically rebuilds when files change. Great for local development.

### Individual Tasks

```bash
npm run css     # Compile and minify CSS only
npm run js      # Concatenate and minify JS only
npm run clean   # Remove intermediate build files
```

## How It Works

### CSS Pipeline

1. **Compile**: SCSS files from `sass/` compiled to `css/base.css` using Dart Sass
2. **Minify**: CSS minified to `css/base.min.css` using Lightning CSS
3. **Version**: Copied to `css/base.{version}.min.css` for cache busting

### JavaScript Pipeline

1. **Concatenate**: Combines jQuery, Hammer.js, and all files from `js/src/` into `js/base.js`
   - Files are sorted alphabetically for consistency
   - Dependencies are automatically checked: `content.js` is reordered before `webfont.js` and `winresize.js` since they depend on `contentFixPushCal()`
2. **Minify**: Compressed to `js/base.min.js` using Terser
3. **Version**: Copied to `js/dist/base.{version}.min.js` for cache busting

### Source Maps

Source maps are automatically generated for both CSS and JS, making debugging easier in browser dev tools.

## Updating Asset Version

When you make changes that need to bust the CloudFront cache:

1. **Update version in package.json:**
   ```json
   "config": {
     "assetVersion": "38"
   }
   ```

2. **Update Application.cfc files:**
   - `lucee-docs/Application.cfc` - Update `variables.assetBundleVersion`
   - `lucee-docs/server/Application.cfc` - Update `this.assetBundleVersion`

3. **Run the build:**
   ```bash
   npm run build
   ```

4. **Commit all files** including the new versioned CSS/JS files

## Project Structure

```
assets/
├── sass/              # SCSS source files
│   ├── base.scss     # Main SCSS entry point
│   ├── addon/        # Third-party styles (Font Awesome, etc)
│   ├── element/      # UI component styles
│   └── theme/        # Theme-specific styles
├── js/
│   ├── src/          # JavaScript source files
│   ├── dist/         # Minified versioned JS output
│   ├── jquery-3.3.1.js
│   └── hammer.js
├── css/              # Compiled CSS output
├── package.json      # Dependencies and build scripts
└── build.js          # Version copying script
```

## Build Tools

- **[Sass](https://sass-lang.com/)** - Dart Sass for SCSS compilation (no Ruby!)
- **[Lightning CSS](https://lightningcss.dev/)** - Ultra-fast CSS minification
- **[Terser](https://terser.org/)** - Modern JavaScript minifier
- **[concat](https://www.npmjs.com/package/concat)** - Simple file concatenation
- **[chokidar-cli](https://github.com/open-cli-tools/chokidar-cli)** - File watching for dev mode
- **[npm-run-all](https://github.com/mysticatea/npm-run-all)** - Run multiple npm scripts

## Troubleshooting

### Unicode characters corrupted in CSS

Modern Dart Sass handles Unicode correctly, so this should no longer be an issue. If you see problems with Font Awesome icons, check:

1. The `@charset "UTF-8";` declaration is at the top of `sass/base.scss`
2. Your editor is saving SCSS files as UTF-8

### Build fails with "command not found"

Make sure you've run `npm install` first. All build tools are installed as local dev dependencies.

### Old Grunt builds

The old Grunt-based build system has been removed. If you have old files:

- Delete `node_modules/` and `package-lock.json`
- Run `npm install` to get the new dependencies
- Run `npm run build`

## Migration from Grunt

This build system replaces the old Grunt-based workflow:

| Old Command | New Command |
|-------------|-------------|
| `grunt` | `npm run build` |
| `grunt watch` | `npm run watch` |
| Edit `Gruntfile.js` version | Edit `package.json` config.assetVersion |

The output files and versioning system remain the same, so existing code references don't need to change.
