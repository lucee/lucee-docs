/**
 * Simple collapse functionality to replace Bootstrap collapse
 * Handles data-toggle="collapse" and data-toggle="tile" for A-Z index
 */
(function() {
	'use strict';

	/**
	 * Toggle collapse state
	 * @param {Element} target - The element to collapse/expand
	 * @param {Element} trigger - The button/link that triggered the collapse
	 */
	function toggleCollapse( target, trigger ) {
		if ( !target ) return;

		var isExpanded = trigger.getAttribute( 'aria-expanded' ) === 'true';
		var isCollapsed = target.classList.contains( 'collapse' ) && !target.classList.contains( 'in' );

		// Update ARIA attributes
		trigger.setAttribute( 'aria-expanded', !isExpanded );
		trigger.classList.toggle( 'collapsed' );

		// Toggle collapse classes
		target.classList.toggle( 'in' );

		// Handle collapsing animation by toggling the 'collapse' class
		if ( isCollapsed ) {
			// Expanding
			target.style.height = 'auto';
		} else {
			// Collapsing
			target.style.height = '0';
		}
	}

	/**
	 * Get target element from trigger
	 * @param {Element} trigger - The button/link element
	 * @returns {Element|null} - The target element
	 */
	function getTarget( trigger ) {
		var targetSelector = trigger.getAttribute( 'data-target' ) || trigger.getAttribute( 'href' );
		if ( !targetSelector ) return null;

		// Remove leading '#' if present
		if ( targetSelector.charAt( 0 ) === '#' ) {
			targetSelector = targetSelector.slice( 1 );
		}

		return document.getElementById( targetSelector );
	}

	// Handle clicks on collapse triggers
	document.addEventListener( 'click', function( e ) {
		var trigger = e.target.closest( '[data-toggle="collapse"]' );
		if ( !trigger ) return;

		e.preventDefault();
		var target = getTarget( trigger );
		toggleCollapse( target, trigger );
	});

	// Note: tile triggers ([data-toggle="tile"]) are handled by tile.js, not here

	// Initialize collapse elements on page load
	document.addEventListener( 'DOMContentLoaded', function() {
		var collapseTriggers = document.querySelectorAll( '[data-toggle="collapse"]' );
		for ( var i = 0; i < collapseTriggers.length; i++ ) {
			var trigger = collapseTriggers[i];
			var target = getTarget( trigger );
			if ( !target ) continue;

			// Set initial ARIA attributes
			var isExpanded = target.classList.contains( 'in' );
			trigger.setAttribute( 'aria-expanded', isExpanded );
			if ( !isExpanded ) {
				trigger.classList.add( 'collapsed' );
			}
		}
	});
})();
