( function( $ ){

	var $searchBox = $( "#lucee-docs-search-input" )
	  , setupTypeahead, setupBloodhound, renderSuggestion, itemSelectedHandler;

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
			, datumTokenizer : function(d) { return Bloodhound.tokenizers.whitespace( d.text ); }
		 	, queryTokenizer : Bloodhound.tokenizers.whitespace
		 	, limit          : 1000
		 	, dupDetector    : function( remote, local ){ return remote.value == local.value }
		} );

		( engine.initialize() ).done( function(){
			callback( engine.ttAdapter() );
		} );
	};

	renderSuggestion = function( item ) {
		var icon = "page";
		switch( item.type ) {
			case "function": case "tag": icon="code"; break;
		}
		return '<i class="fa fa-fw fa-' + icon + '"></i> ' + item.text;
	};

	itemSelectedHandler = function( item ) {
		window.location = item.value;
	};

	if ( $searchBox.length ) {
		setupTypeahead();
	}

} )( jQuery );