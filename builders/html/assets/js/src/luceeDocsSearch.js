/**
 * Lucee Docs Search
 * Modern search implementation using Algolia autocomplete.js
 */
(function() {
	'use strict';

	var searchIndex = null;
	var duckduckgoUrl = 'https://duckduckgo.com/?q=site:docs.lucee.org ';
	var lastQuery = '';

	/**
	 * Generate regex for matching - tries substring first, then word boundary, then fuzzy
	 */
	function generateRegexForInput(input) {
		var escapedInput = input.replace(/[-\/\\^$*+?.()|[\]{}]/g, '\\$&');

		return {
			// Try substring match first (highest priority)
			substring: new RegExp('(' + escapedInput + ')', 'i'),
			// Word boundary match (medium priority)
			wordBoundary: new RegExp('\\b(' + escapedInput + ')', 'i'),
			// Fuzzy match with max 2 chars between (lowest priority)
			fuzzy: new RegExp('(' + input.replace(/[\W]+/g, '').split('').join(')(.{0,2})(') + ')', 'i'),
			replace: '<strong>$1</strong>'
		};
	}

	/**
	 * Search the index with substring, word boundary, and fuzzy matching
	 */
	function searchDocs(query) {
		if (!searchIndex || !query) {
			return [];
		}

		query = query.trim();
		lastQuery = query;

		// Save to localStorage
		if (localStorage) {
			localStorage.setItem('lastSearch', query);
		}

		var reg = generateRegexForInput(query);
		var matches = [];

		// Search through index
		searchIndex.forEach(function(item) {
			var text = item.display || item.text; // Use display (unencoded) for searching and highlighting
			var match = null;
			var matchType = '';
			var highlighted = text;

			// For tags, also try matching with "cf" prefix (e.g., "query" should match "cfquery")
			if (item.type === 'tag' && !query.toLowerCase().startsWith('cf')) {
				var cfQuery = 'cf' + query;
				var cfReg = {
					substring: new RegExp('(' + cfQuery.replace(/[-\/\\^$*+?.()|[\]{}]/g, '\\$&') + ')', 'i'),
					wordBoundary: new RegExp('\\b(' + cfQuery.replace(/[-\/\\^$*+?.()|[\]{}]/g, '\\$&') + ')', 'i'),
					replace: '<strong>$1</strong>'
				};
				if (cfReg.substring.test(text)) {
					match = text.match(cfReg.substring);
					matchType = 'substring';
					highlighted = text.replace(cfReg.substring, cfReg.replace);
				} else if (cfReg.wordBoundary.test(text)) {
					match = text.match(cfReg.wordBoundary);
					matchType = 'word';
					highlighted = text.replace(cfReg.wordBoundary, cfReg.replace);
				}
			}

			// If not matched yet, try substring match
			if (!match && reg.substring.test(text)) {
				match = text.match(reg.substring);
				matchType = 'substring';
				highlighted = text.replace(reg.substring, reg.replace);
			}
			// Try word boundary match
			else if (!match && reg.wordBoundary.test(text)) {
				match = text.match(reg.wordBoundary);
				matchType = 'word';
				highlighted = text.replace(reg.wordBoundary, reg.replace);
			}
			// Try fuzzy match (weakest match)
			else if (!match && query.length >= 3 && reg.fuzzy.test(text)) {
				match = text.match(reg.fuzzy);
				matchType = 'fuzzy';
				// For fuzzy matches, don't highlight to avoid nested tag issues
				highlighted = text;
			}

			if (match) {
				// Score: substring=0, word=100, fuzzy=1000, then by length
				var score = 0;
				if (matchType === 'word') score = 100;
				else if (matchType === 'fuzzy') score = 1000;
				score += text.length;

				matches.push({
					value: item.value,
					text: text,
					highlight: highlighted,
					score: score,
					icon: item.icon || 'description',
					type: item.type || '',
					raw: item
				});
			}
		});

		// Sort by score (lower is better)
		matches.sort(function(a, b) {
			return a.score - b.score;
		});

		// Add DuckDuckGo fallback as first item
		var ddgItem = {
			value: duckduckgoUrl + encodeURIComponent(query),
			text: 'Search all docs for "' + query + '"',
			highlight: '<em>Search all docs for <strong>"' + query + '"</strong></em>',
			score: -1000000,
			icon: 'search',
			type: 'external',
			isDDG: true
		};

		matches.unshift(ddgItem);

		return matches;
	}

	/**
	 * Load search index
	 */
	function loadSearchIndex(callback) {
		fetch('/assets/js/searchIndex.json')
			.then(function(response) {
				return response.json();
			})
			.then(function(data) {
				searchIndex = data;
				callback();
			})
			.catch(function(error) {
				console.error('Failed to load search index:', error);
			});
	}

	/**
	 * Initialize autocomplete on an input element
	 */
	function initAutocomplete(containerElement) {
		var lib = window['@algolia/autocomplete-js'];
		if (!lib || !lib.autocomplete) {
			console.error('Algolia autocomplete.js not loaded');
			return;
		}

		var clickOutsideHandler = null;

		var autocompleteInstance = lib.autocomplete({
			container: containerElement,
			placeholder: 'Search docs...',
			openOnFocus: false,
			detachedMediaQuery: 'none', // Disable detached mode completely
			onStateChange: function(params) {
				// Add/remove click-outside handler based on open state
				if (params.state.isOpen && !clickOutsideHandler) {
					clickOutsideHandler = function(e) {
						if (!containerElement.contains(e.target)) {
							autocompleteInstance.setIsOpen(false);
						}
					};
					setTimeout(function() {
						document.addEventListener('click', clickOutsideHandler);
					}, 0);
				} else if (!params.state.isOpen && clickOutsideHandler) {
					document.removeEventListener('click', clickOutsideHandler);
					clickOutsideHandler = null;
				}
			},
			getSources: function() {
				return [{
					sourceId: 'lucee-docs',
					getItems: function(params) {
						return searchDocs(params.query);
					},
					templates: {
						item: function(params) {
							// Only show type for tag, function, method, object
							var showTypes = ['tag', 'function', '_method', '_object'];
							var type = params.item.type || '';
							var displayType = '';

							if (showTypes.indexOf(type) !== -1) {
								// Remove underscore prefix from method and object
								displayType = type.replace(/^_/, '');
							}

							// Use createElement helper from params
							return params.createElement('div', {
								className: 'aa-ItemWrapper',
								dangerouslySetInnerHTML: {
									__html: '<div class="aa-ItemContent">' +
										'<div class="aa-ItemIcon">' +
											'<span class="material-symbols-outlined">' + (params.item.icon || 'description') + '</span>' +
										'</div>' +
										'<div class="aa-ItemContentBody">' +
											'<span class="aa-ItemContentTitle">' + (params.item.highlight || params.item.text || 'No title') + '</span>' +
											(displayType ? '<span class="aa-ItemContentDescription">' + displayType + '</span>' : '') +
										'</div>' +
									'</div>'
								}
							});
						}
					},
					onSelect: function(params) {
						handleItemSelected(params.item);
					}
				}];
			}
		});

		// Add Escape key handler and mark as ready after initialization
		setTimeout(function() {
			var input = containerElement.querySelector('.aa-Input');
			if (input) {
				input.addEventListener('keydown', function(e) {
					if (e.key === 'Escape' || e.keyCode === 27) {
						e.preventDefault();
						e.stopPropagation();
						autocompleteInstance.setIsOpen(false);
						input.blur();
					}
				});
			}

			// Mark autocomplete as ready to fade in
			var autocompleteRoot = containerElement.querySelector('.aa-Autocomplete');
			if (autocompleteRoot) {
				autocompleteRoot.classList.add('aa-ready');
			}
		}, 100);

		return autocompleteInstance;
	}

	/**
	 * Handle item selection
	 */
	function handleItemSelected(item) {
		addSearchResultHistory(function() {
			if (window.location.pathname.indexOf('/static/') === 0) {
				window.location = '/static' + item.value;
			} else {
				window.location = item.value;
			}
		});
	}

	/**
	 * Add search to browser history and analytics
	 */
	function addSearchResultHistory(callback) {
		var searchUrl = '/search.html?q=';
		var bookmark = false;

		if (document.location.pathname.indexOf('/search.html') === 0) {
			bookmark = true;
		} else if (document.location.pathname.indexOf('/static/search.html') === 0) {
			searchUrl = '/static/search.html?q=';
			bookmark = true;
		}

		searchUrl += encodeURIComponent(lastQuery);

		if (bookmark && window.history.pushState) {
			window.history.pushState({q: lastQuery}, 'Search: ' + lastQuery, searchUrl);
		}

		try {
			gtag('config', window._gaTrackingID, {'page_path': searchUrl});
		} catch (e) {
			// Ignore analytics errors
		}

		setTimeout(callback, 100); // Give analytics time to complete
	}

	/**
	 * Render 404 page suggestions
	 */
	function renderFileNotFoundSuggestions() {
		var container = document.querySelector('.file-not-found-suggestions');
		if (!container || !searchIndex) {
			return;
		}

		var pathParts = document.location.pathname.split('.')[0].split('/');
		var query = pathParts[pathParts.length - 1].split('-').join(' ');
		var suggestions = searchDocs(query);

		if (suggestions.length > 1) {
			var p = document.createElement('p');
			p.textContent = 'Perhaps one of these pages is what you\'re looking for?';
			container.appendChild(p);
		}

		suggestions.forEach(function(item) {
			var href = item.value;
			if (href.indexOf('http') === -1) {
				href = item.value.substr(1);
			}
			var link = document.createElement('a');
			link.textContent = item.text;
			link.href = href;
			var div = document.createElement('div');
			div.appendChild(link);
			container.appendChild(div);
		});
	}

	/**
	 * Initialize full-page search mode
	 */
	function triggerSearchPage() {
		var fullPageSearch = document.querySelector('.search-fullpage');
		if (!fullPageSearch) {
			return;
		}

		// Parse query from URL
		var query = '';
		var search = document.location.search;
		var pos = search.indexOf('q=');
		if (pos !== -1) {
			query = decodeURIComponent(search.substr(pos + 2));
			pos = query.indexOf('&');
			if (pos !== -1) {
				query = query.substr(0, pos);
			}
		}

		// Initialize autocomplete in full-page mode
		var searchInput = document.createElement('input');
		searchInput.type = 'search';
		searchInput.id = 'lucee-docs-search-fullpage';
		searchInput.className = 'form-control form-control-lg';
		searchInput.placeholder = 'Search';
		searchInput.value = query;

		fullPageSearch.appendChild(searchInput);

		var panelContainer = document.createElement('div');
		panelContainer.className = 'aa-PanelLayout';
		fullPageSearch.appendChild(panelContainer);

		initAutocomplete(searchInput, panelContainer);

		// Trigger search if we have a query
		if (query) {
			searchInput.dispatchEvent(new Event('input', { bubbles: true }));
		}
	}

	/**
	 * Initialize random page button
	 */
	function initRandomPage() {
		var randomBtn = document.querySelector('.menu-random');
		if (!randomBtn || !searchIndex) {
			return;
		}

		randomBtn.addEventListener('click', function() {
			var current = document.location.pathname.toLowerCase();
			var link = current;
			var maxAttempts = 10;
			var attempts = 0;

			while (link === current && attempts < maxAttempts) {
				var randomIndex = Math.floor(Math.random() * searchIndex.length);
				link = searchIndex[randomIndex].value.toLowerCase();
				attempts++;
			}

			if (link !== current) {
				document.location = link;
			}
		});
	}

	/**
	 * Initialize search on page load
	 */
	function init() {
		loadSearchIndex(function() {
			// Initialize desktop header search
			var headerContainer = document.getElementById('header-search-container');
			if (headerContainer) {
				var headerAutocomplete = initAutocomplete(headerContainer);

				// Restore last search on focus
				setTimeout(function() {
					var input = headerContainer.querySelector('.aa-Input');
					if (input) {
						input.addEventListener('focus', function() {
							if (localStorage) {
								var lastSearch = localStorage.getItem('lastSearch');
								if (lastSearch && !input.value) {
									// Set value, trigger search, open dropdown, and select text
									headerAutocomplete.setQuery(lastSearch);
									headerAutocomplete.refresh();
									headerAutocomplete.setIsOpen(true);
									setTimeout(function() {
										input.select();
									}, 50);
								}
							}
						}, { once: true });
					}
				}, 100);
			}

			// Initialize mobile search (if exists)
			var mobileContainer = document.getElementById('mobile-search-container');
			if (mobileContainer) {
				var mobileAutocomplete = initAutocomplete(mobileContainer);

				// Add menu-search-focus class and handle last search restoration
				setTimeout(function() {
					var input = mobileContainer.querySelector('.aa-Input');
					if (input) {
						input.classList.add('menu-search-focus');

						// Restore search whenever input gets focus
						var restoreSearch = function() {
							if (localStorage) {
								var lastSearch = localStorage.getItem('lastSearch');
								if (lastSearch && !input.value) {
									// Set value and wait before refreshing
									mobileAutocomplete.setQuery(lastSearch);
									setTimeout(function() {
										// Manually trigger refresh and open
										mobileAutocomplete.refresh();
										setTimeout(function() {
											mobileAutocomplete.setIsOpen(true);
											input.select();
										}, 100);
									}, 150);
								}
							}
						};

						input.addEventListener('focus', restoreSearch);
					}
				}, 100);
			}

			// Initialize 404 suggestions
			renderFileNotFoundSuggestions();

			// Initialize full-page search
			triggerSearchPage();

			// Initialize random page
			initRandomPage();
		});
	}

	// Start when DOM is ready
	if (document.readyState === 'loading') {
		document.addEventListener('DOMContentLoaded', init);
	} else {
		init();
	}

})();
