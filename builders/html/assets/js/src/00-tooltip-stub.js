/**
 * Minimal tooltip stub to replace Bootstrap tooltip
 * Used by toast.js - provides just enough to prevent errors
 */
(function( $ ) {
	'use strict';

	// Stub tooltip method
	$.fn.tooltip = function( options ) {
		// Just return this for chaining, don't actually do anything
		// Toasts will work, just without the tooltip display
		return this;
	};

})( jQuery );
