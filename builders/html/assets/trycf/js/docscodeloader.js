( function(){
	var inIframe = window.self !== window.top
	  , codeContainer, editor, code, getParameterByName;

	if ( inIframe ) {
		getParameterByName = function(name) {
		    name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
		    var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
		        results = regex.exec(location.search);
		    return results === null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
		}

		codeContainer = parent.document.getElementById( window.name );
		editor        = document.getElementById( "editor" );
		scriptBased   = getParameterByName( "script" );
		code          = codeContainer.innerHTML;

		if ( scriptBased == "true" ) {
			code = "<cfscript>\n" + code + "\n</cfscript>";
		}
		editor.setAttribute( "code", code );
	}

} )();