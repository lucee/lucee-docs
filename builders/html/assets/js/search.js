( function( $ ){

	var $searchBox = $( "#lucee-docs-search-input" )
	  , $searchLink = $( ".search-link" )
	  , $searchContainer = $( ".search-container" )
	  , setupTypeahead, setupBloodhound, renderSuggestion, itemSelectedHandler, tokenizer;

	setupTypeahead = function(){
		setupBloodhound( function( bloodhound ){
			var typeAheadSettings = {
					  hint      : true
					, highlight : true
					, minLength : 1
				}
			  , datasetSettings = {
			  		  source     : bloodhound
			  		, displayKey : 'text'
			  		, templates  : { suggestion : renderSuggestion }
			    }

			$searchBox.typeahead( typeAheadSettings, datasetSettings );
			$searchBox.on( "typeahead:selected", function( e, result ){ itemSelectedHandler( result ); } );
		} );
	};

	setupBloodhound = function( callback ){
		var engine = new Bloodhound( {
			  local          : []
			, prefetch       : "/assets/js/searchIndex.json"
			, remote         : null
			, datumTokenizer : function(d) { return tokenizer( d.text ); }
		 	, queryTokenizer : tokenizer
		 	, limit          : 1000
		 	, dupDetector    : function( remote, local ){ return remote.value == local.value }
		} );

		( engine.initialize() ).done( function(){
			callback( engine.ttAdapter() );
		} );
	};

	renderSuggestion = function( item ) {
		return Mustache.render( '<div><i class="fa fa-fw fa-{{icon}}"></i> {{text}}</div>', item );
	};

	itemSelectedHandler = function( item ) {
		window.location = item.value;
	};

	tokenizer = function( input ) {
		var strippedInput = input.replace( /\W/g, "" );
		return Bloodhound.tokenizers.whitespace( strippedInput );
	}

	setupTypeahead();
	$searchLink.click( function( e ){
		e.preventDefault();
		$searchContainer.fadeIn( 400 );
		$searchBox.focus();

	} );

} )( jQuery );