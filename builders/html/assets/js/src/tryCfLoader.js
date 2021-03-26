( function( $ ){
	var editor, baseHref=$("base[href]").attr('href');
	if (baseHref){
			editor = baseHref + "editor.html";
	} else {
			editor = "/editor.html";
	}

	window.addEventListener("message", function(ev) {		
		if ( ev.data ){			
			var msg = ev.data;
			if ( msg.id && msg.src && msg.src == "try-cf" ){
				if (!msg.height)
					msg.height = 350;
				var $el = $("IFRAME.trycf-iframe#" + msg.id);
				if ( $el.length == 1){
					$el.height(msg.height);
					console.log("postMessage try-cf resize success", msg);
					return;
				}
				console.log("Element IFRAME.trycf-iframe#" + msg.id + " not found");
			}		
		}
		console.log("postMessage ignored", ev);

	}, false);

	$.fn.tryCfLoader = function(){

		return this.each( function(){
			var $codeBlock = $( this )
			  , $flathighlight = $codeBlock.next()
			  , blockId    = $codeBlock.attr( "id" )
			  , scriptBased = $codeBlock.data( 'script' )
			  , editorUrl = editor  + '?script=' + scriptBased + '&id=' + $codeBlock.attr( "id" ) // for postMessage()
			  , $iframe    = $( '<iframe seamless="seamless" frameborder="0" src="' 
			  	+ editorUrl + '" name="' + blockId + '"' + '" id="' + blockId + '"'
				+ ' class="trycf-iframe" height="350" width="100%"></iframe>' );

			$codeBlock.after( $iframe );
			$flathighlight.remove();
		} );
	};

	$( "script[data-trycf]" ).tryCfLoader();
} )( jQuery );