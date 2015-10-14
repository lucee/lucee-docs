( function( $ ){
	$.fn.tryCfLoader = function(){
		return this.each( function(){
			var $codeBlock = $( this )
			  , $flathighlight = $codeBlock.next()
			  , blockId    = $codeBlock.attr( "id" )
			  , scriptBased = $codeBlock.data( 'script' )
			  , $iframe    = $( '<iframe seamless="seamless" frameborder="0" src="editor.html?script=' + scriptBased + '" name="' + blockId + '" class="trycf-iframe" height="600" width="100%"></iframe>' );

			$codeBlock.after( $iframe );
			$flathighlight.remove();
		} );
	};

	$( "script[data-trycf]" ).tryCfLoader();
} )( jQuery );