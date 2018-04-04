( function( $ ){
	var editor, baseHref=$("base[href]").attr('href');
	if (baseHref){
			editor = baseHref + "editor.html";
	} else {
			editor = "/editor.html";
	}
		
	$.fn.tryCfLoader = function(){

		return this.each( function(){
			var $codeBlock = $( this )
			  , $flathighlight = $codeBlock.next()
			  , blockId    = $codeBlock.attr( "id" )
			  , scriptBased = $codeBlock.data( 'script' )
			  , $iframe    = $( '<iframe seamless="seamless" frameborder="0" src="' + editor + '?script=' + scriptBased + '" name="' + blockId + '" class="trycf-iframe" height="600" width="100%"></iframe>' );

			$codeBlock.after( $iframe );
			$flathighlight.remove();
		} );
	};

	$( "script[data-trycf]" ).tryCfLoader();
} )( jQuery );