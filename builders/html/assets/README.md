# Lucee Docs Assets Build System

Modern build system for compiling and bundling CSS and JavaScript assets for the Lucee documentation site.

## Requirements

- Node.js (v14 or later)
- npm (comes with Node.js)

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
npm run css             # Compile and minify CSS only
npm run js              # Concatenate and minify JS only
npm run ace             # Build ACE editor bundle for TryCF
npm run check-versions  # Verify version sync across all config files
npm run clean           # Remove intermediate build files
```

**Note**: `npm run build` automatically runs `check-versions` first to ensure all asset version numbers are synchronized before building.

## How It Works

### CSS Pipeline

1. **Compile**: SCSS files from `sass/` compiled to `css/base.css` using Dart Sass
2. **Minify**: CSS minified to `css/base.min.css` using Lightning CSS
3. **Version**: Copied to `css/base.{version}.min.css` for cache busting

### JavaScript Pipeline

1. **Concatenate**: Combines jQuery 3.7.1, Algolia autocomplete.js, all files from `js/src/`, and TryCF editor files into `js/base.js`
   - Files are sorted alphabetically for consistency
   - Dependencies are automatically checked: `content.js` is reordered before `webfont.js` and `winresize.js` since they depend on `contentFixPushCal()`
2. **Minify**: Compressed to `js/base.min.js` using Terser
3. **Version**: Copied to `js/dist/base.{version}.min.js` for cache busting

### ACE Editor Pipeline

The TryCF live editor uses ACE Editor with a custom bundle:

1. **Bundle**: Combines ACE core, language tools, ColdFusion mode, Monokai theme, and snippets into `trycf/js/ace/ace-bundle.js`
2. **Version**: Copied to `ace-bundle.{version}.js` for cache busting
3. **Auto-deploy**: Automatically copied to `builds/html/assets/trycf/js/ace/` if it exists

This approach eliminates the need for ACE to lazy-load modules at runtime.

### Source Maps

Source maps are automatically generated for both CSS and JS, making debugging easier in browser dev tools.

## Updating Asset Version

When you make changes that need to bust the CloudFront cache:

1. **Update version in package.json:**

```json
"config": {
   "assetVersion": "45"
}
```

2. **Update Application.cfc files:**

- `lucee-docs/Application.cfc` - Update `variables.assetBundleVersion`
- `lucee-docs/server/Application.cfc` - Update `this.assetBundleVersion`

3. **Run the full build** (not just css or js individually):

```bash
npm run build
```

This runs all pipelines (CSS, JS, ACE, highlight) and creates versioned files:

- `css/base.{version}.min.css`
- `js/dist/base.{version}.min.js`
- `trycf/js/ace/ace-bundle.{version}.js`

The build script automatically copies these to `builds/html/assets/` for deployment.

4. **Commit all files** including the new versioned CSS/JS/ACE files

## Project Structure

```
assets/
├── sass/              # SCSS source files
│   ├── base.scss     # Main SCSS entry point
│   ├── _css-variables.scss  # CSS custom properties for theming
│   ├── addon/        # Third-party styles
│   ├── element/      # UI component styles (includes _autocomplete.scss)
│   └── theme/        # Theme-specific styles
├── js/
│   ├── src/          # JavaScript source files
│   │   ├── luceeDocsSearch.js  # Algolia autocomplete search
│   │   ├── theme-switcher.js   # Light/dark/auto theme toggle
│   │   ├── collapse.js         # Collapse/expand functionality
│   │   └── ...       # Other component scripts
│   ├── dist/         # Minified versioned JS output
│   └── jquery-3.7.1.js
├── css/              # Compiled CSS output
│   ├── highlight.css      # Code syntax highlighting (light mode)
│   └── highlight-dark.css # Code syntax highlighting (dark mode)
├── trycf/            # TryCF live code editor assets
├── node_modules/     # Dependencies (includes @algolia/autocomplete-js)
├── package.json      # Dependencies and build scripts
├── concat.js         # JS concatenation with dependency ordering
└── build.js          # Version copying and auto-deployment script
```

## Build Tools

- **[Sass](https://sass-lang.com/)** - Dart Sass for SCSS compilation (no Ruby!)
- **[Lightning CSS](https://lightningcss.dev/)** - Ultra-fast CSS minification
- **[Terser](https://terser.org/)** - Modern JavaScript minifier
- **[Algolia Autocomplete](https://www.algolia.com/doc/ui-libraries/autocomplete/introduction/what-is-autocomplete/)** - Search autocomplete library
- **[chokidar-cli](https://github.com/open-cli-tools/chokidar-cli)** - File watching for dev mode
- **[npm-run-all](https://github.com/mysticatea/npm-run-all)** - Run multiple npm scripts

## Key Features

### Dark Mode Support

The site now includes a comprehensive dark mode with light/dark/auto theme switching:

- CSS custom properties (`--text-color`, `--bg-color`, etc.) for all colors
- Auto mode respects system preferences via `prefers-color-scheme`
- Theme preference stored in localStorage
- Separate syntax highlighting for light and dark modes
- Smooth transitions between themes

### Modern Search

Search powered by Algolia Autocomplete.js:

- Fast fuzzy matching with prioritized scoring (substring > word boundary > fuzzy)
- CFML-aware: "query" matches "cfquery" for tags
- Search persistence and auto-restore
- DuckDuckGo fallback for full-text search
- Mobile-optimized with touch-friendly UI
- Progressive enhancement with noscript fallback

### Icon System

Uses **Material Symbols** icon font for modern, crisp icons that adapt to theme colors.

## Troubleshooting

### Unicode characters corrupted in CSS

Modern Dart Sass handles Unicode correctly, so this should no longer be an issue. If you see problems with Material Symbols icons, check:

1. The `@charset "UTF-8";` declaration is at the top of `sass/base.scss`
2. Your editor is saving SCSS files as UTF-8
3. The Material Symbols font is loading correctly (check Network tab)

### Build fails with "command not found"

Make sure you've run `npm install` first. All build tools are installed as local dev dependencies.

### Version mismatch error

If you see "VERSION MISMATCH DETECTED!" when running `npm run build`, the asset version numbers are out of sync:

```
✗ VERSION MISMATCH DETECTED!

Asset versions must be synchronized across all files:
  package.json:              38
  Application.cfc:           38
  server/Application.cfc:    37
```

Fix by updating all three files to use the same version number:

- `package.json` → `config.assetVersion`
- `Application.cfc` → `variables.assetBundleVersion`
- `server/Application.cfc` → `this.assetBundleVersion`

You can run `npm run check-versions` to verify they're synchronized.

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
