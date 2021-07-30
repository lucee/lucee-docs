( function( $ ){

	var $searchBox       = $( "#lucee-docs-search-input" )
	  , $searchLink      = $( ".search-link" )
		, $searchContainer = $( ".search-container" )
	  , duckduckgoUrl    = "https://duckduckgo.com/?q=site:docs.lucee.org "
	  , setupTypeahead, setupBloodhound, renderSuggestion
	  , itemSelectedHandler, tokenizer, generateRegexForInput, search, searchIndex;

	setupTypeahead = function(){
		setupSearchEngine( function( bloodhound ){
			var typeAheadSettings = {
					  hint      : true
					, highlight : false
					, minLength : 1
				}
			  , datasetSettings = {
					  source     : bloodhound
					, displayKey : 'display'
					, limit      : 100
					, templates  : { suggestion : renderSuggestion }
				};

			$searchBox.typeahead( typeAheadSettings, datasetSettings );
			$searchBox.on( "typeahead:selected", function( e, result ){ itemSelectedHandler( result ); } );

			var $fileNotFound = $(".file-not-found-suggestions");
			if ($fileNotFound.length)
				renderFileNotFoundSuggestions($fileNotFound);

			triggerSearchPage();
		} );

	};

	setupSearchEngine = function( callback ){
		var dataReceived = function( data ){
			searchIndex = data;

			callback( function( query, syncCallback ) {
				syncCallback( search( query ) );
			} );
		};

		$.ajax( "/assets/js/searchIndex.json", {
			  method : "GET"
			, success : dataReceived
		} );
	};
	var q = "";
	search = function( input ){
		if (localStorage)
			localStorage.setItem('lastSearch', input);

		q = input;

		var reg     = generateRegexForInput( input )
		  , fulltextitem, matches;
		
		matches = searchIndex.filter( function( item ) {
			var srcText = item.desc ? item.desc : item.text; // cdn caching sigh
			var titleLen = item.text.length
			  , match, nextMatch, highlighted;

			for( var i=0; i < titleLen; i++ ){
				nextMatch = srcText.substr(i).match( reg.expr );

				if ( !nextMatch ) {
					break;
				} else if ( !match || nextMatch[0].length < match[0].length ) {
					match = nextMatch;
					highlighted = item.text.substr(0,i) + item.text.substr(i).replace( reg.expr, reg.replace );
				}
			}

			if ( match ) {
				item.score = match[0].length - input.length;
				item.highlight = highlighted;

				return true;
			}
		} );

		matches = matches.sort( function( a, b ){
			return ( a.score - b.score ) || a.text.length - b.text.length;
		} );

		fulltextitem = {
			  value     : duckduckgoUrl + encodeURIComponent( input )
			, text      : 'Search all docs for "' + input + '"'
			, highlight : '<em>Search all docs for <strong>"' + input + '</strong>"</em>'
			, score     : 1000000
			, icon      : "search"
			, type      : ""
		};
		fulltextitem.display = fulltextitem.text;
		matches.unshift( fulltextitem );

		return matches;
	};

	generateRegexForInput = function( input ){
		var inputLetters = input.replace(/[\W]+/g, '').split('')
		  , reg = {}, i;

		reg.expr = new RegExp('(' + inputLetters.join( ')(.*?)(' ) + ')', 'i');
		reg.replace = "";

		for( i=0; i < inputLetters.length; i++ ) {
			reg.replace += ( '<b>$' + (i*2+1) + '</b>' );
			if ( i + 1 < inputLetters.length ) {
				reg.replace += '$' + (i*2+2);
			}
		}
		if ( input.charAt(input.length-1) == " ")
			reg += " ";
		return reg;
	};

	var renderSuggestion = function( item ) {
		return Mustache.render( '<div><i class="fa fa-fw fa-{{icon}}"></i> {{{highlight}}}</div>', item );
	};

	itemSelectedHandler = function( item ) {
		addSearchResultHistory(function cb(){
			if (window.location.pathname.indexOf("/static/") === 0)
				window.location = "/static" + item.value; // handle local /static/ mode
			else
				window.location = item.value;
		});
	};

	tokenizer = function( input ) {
		var strippedInput = input.replace( /[^\w\s]/g, "" );
		return Bloodhound.tokenizers.whitespace( strippedInput );
	};

	setupTypeahead();

	var addSearchResultHistory = function (cb){
		var searchUrl = '/search.html?q=';
		var bookmark = false;

		if (document.location.pathname.indexOf("/search.html") === 0){
			bookmark = true;
		} else if (document.location.pathname.indexOf("/static/search.html") === 0){
			searchUrl = '/static/search.html?q=';
			bookmark = true;
		}
		searchUrl += encodeURIComponent(q);

		if (bookmark && window.history.pushState)
				window.history.pushState({q: q}, 'Search: ' + q , searchUrl);
		try {
			gtag('config', window._gaTrackingID, {'page_path': searchUrl});
		} catch (e){
			// ignore
		}
		setTimeout(cb, 100); // give analytics a chance to complete
	}

	// on the 404 page, try and make some suggestions based on filename
	var renderFileNotFoundSuggestions = function($fileNotFound){
		var q = document.location.pathname.split(".")[0].split("/");
		var suggestions = 	search(q[q.length-1].split("-").join(" "));
		if (suggestions.length > 1)
			$fileNotFound.append($("<p/>").text("Perhaps one of these pages is what your looking for?"));
		for (var s = 0; s < suggestions.length; s++){
			var item = suggestions[s];
			var href = item.value;
			if (href.indexOf("http") == -1 )
				href = item.value.substr(1);
			var link = $("<a/>").text(item.display).attr("href", href);
			$fileNotFound.append($("<div/>").append(link));
		}
	};

	// we have a search.html page for tracking searches
	var triggerSearchPage = function(){
		var fullPageSearch = $(".search-fullpage");
		if (fullPageSearch.length === 1){
			var str =  document.location.search;
			var pos = str.indexOf("q=");
			if ( pos !== -1 ){
				// we have a searcj query string!
				str = decodeURIComponent(str.substr(pos+2));
				pos = str.indexOf("&");
				if ( pos !== -1 ){
					// with trailing url params, ignore them
					str = str.substr(0, pos-1);
				}
			}
			// reposition search as a full page search
			var searchMenu = $("#search").find(".menu-content-inner").detach();
			var searchInput = searchMenu.find(".menu-search-focus");
			var ttMenu = searchMenu.find(".tt-menu");
			ttMenu.attr("style",""); // remove all the positioning for the side menu

			if (str.length > 0)
				searchInput.val(str);

			fullPageSearch.append(searchMenu);

			searchInput.trigger("input");
			$(".menu-toggle").hide(); // hide the toolbar search menu
		}
	};
	// auto select exact match on enter LD-68
	$(".menu-search-focus").on("keyup", function(e){
		if (e.which === 13 || e.which === 10){
			var matches = $(".tt-dataset .tt-suggestion");
			if (matches.length === 2) // exact match
				$(matches[1]).click();
		}
	});

	$(".menu-random").on("click", function(e){
		function getRandomInt(min, max) {
			return Math.floor(Math.random() * (max - min + 1)) + min;
		}
		var current = document.location.pathname.toLowerCase();
		var i, link = current;
		while ( link == current ){
			i = getRandomInt(1, searchIndex.length);
			link = searchIndex[i-1].value.toLowerCase();
		}
		document.location = link;
	});

} )( jQuery );
