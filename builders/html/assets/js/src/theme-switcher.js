/**
 * Theme Switcher
 * Simple light/dark toggle that respects system preference on first visit
 */
(function() {
	const STORAGE_KEY = 'lucee-docs-theme';
	const THEME_LIGHT = 'light';
	const THEME_DARK = 'dark';

	/**
	 * Apply theme to the document
	 * @param {string} theme - light or dark
	 */
	function applyTheme( theme ) {
		document.documentElement.setAttribute( 'data-theme', theme );

		// Toggle syntax highlight stylesheets by disabling the unused one
		var lightStylesheet = document.querySelector( '.highlight-theme-light' );
		var darkStylesheet = document.querySelector( '.highlight-theme-dark' );

		if ( lightStylesheet ) {
			lightStylesheet.disabled = ( theme === THEME_DARK );
		}
		if ( darkStylesheet ) {
			darkStylesheet.disabled = ( theme === THEME_LIGHT );
		}

		// Notify all TryCF iframes of theme change
		var iframes = document.querySelectorAll( 'iframe.trycf-iframe' );
		for ( var i = 0; i < iframes.length; i++ ) {
			try {
				iframes[i].contentWindow.postMessage( {
					type: 'theme-change',
					theme: theme
				}, '*' );
			} catch ( e ) {
				// Ignore cross-origin errors
			}
		}
	}

	/**
	 * Update toggle button UI
	 * @param {Element} toggle - The toggle button element
	 * @param {string} theme - Current theme (light/dark)
	 */
	function updateToggleUI( toggle, theme ) {
		toggle.setAttribute( 'data-theme', theme );
		toggle.setAttribute( 'aria-label', 'Toggle theme (currently ' + theme + ')' );

		// Update icon visibility - show opposite of current theme
		var lightIcon = toggle.querySelector( '.theme-icon-light' );
		var darkIcon = toggle.querySelector( '.theme-icon-dark' );

		if ( lightIcon ) {
			lightIcon.style.display = theme === THEME_DARK ? 'inline-block' : 'none';
		}
		if ( darkIcon ) {
			darkIcon.style.display = theme === THEME_LIGHT ? 'inline-block' : 'none';
		}
	}

	// On first visit, use system preference. Otherwise use saved preference.
	var savedTheme = localStorage.getItem( STORAGE_KEY );
	var currentTheme;

	if ( savedTheme ) {
		// User has previously set a preference
		currentTheme = savedTheme;
	} else {
		// First visit - use system preference but don't save it yet
		var prefersDark = window.matchMedia( '(prefers-color-scheme: dark)' ).matches;
		currentTheme = prefersDark ? THEME_DARK : THEME_LIGHT;
	}

	// Apply theme immediately to prevent FOUC
	applyTheme( currentTheme );

	// Setup toggle after DOM ready
	document.addEventListener( 'DOMContentLoaded', function() {
		var toggle = document.querySelector( '.theme-toggle' );
		if ( !toggle ) return;

		// Initialize toggle UI
		updateToggleUI( toggle, currentTheme );

		// Handle toggle click - simple toggle between light and dark
		toggle.addEventListener( 'click', function() {
			// Toggle to opposite theme
			currentTheme = currentTheme === THEME_LIGHT ? THEME_DARK : THEME_LIGHT;

			// Save the explicit user preference
			localStorage.setItem( STORAGE_KEY, currentTheme );

			// Apply and update UI
			applyTheme( currentTheme );
			updateToggleUI( toggle, currentTheme );
		});
	});
})();
