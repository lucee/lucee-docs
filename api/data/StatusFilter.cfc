component accessors=true {
	public any function init () {
		return this;
	}
	public struct function getReferenceByStatus( required struct idMap, required string status) {

		var referencePageTypes = {
			"function": {},
			"tag": {}
		};

		var status = [:];
		var requestedStatus = {};
		loop list="#arguments.status#" item="local.s" {
			requestedStatus[local.s] = true;
		}

		for ( var id in arguments.idMap ) {
			//echo (arguments.idMap[ id ].getSlug() & " :: " & arguments.idMap[ id ].getStatus() & "<br>");

			if ( structKeyExists( referencePageTypes, arguments.idMap[ id ].getPageType() ) ){
				var match = false;
				if ( structKeyExists( requestedStatus, "deprecated" ) && arguments.idMap[ id ].getDeprecated() eq "true" )
					match = true;
				if ( structKeyExists( requestedStatus, arguments.idMap[ id ].getStatus() ) )
					match = true;
				if ( match ) {
					var slug = arguments.idMap[ id ].getSlug();
					status[ arguments.idMap[ id ].getPageType() ][ slug ] = arguments.idMap[ id ];
				}
			}
		}

		for ( local.pt in referencePageTypes ){
			local.keys = structKeyArray( status[ pt ] ).sort("text", "asc" );
			local.st = [:];
			for ( local.p in local.keys )
				local.st[ p ] = status[ pt ][ p ];
				status[ pt ] = st;
		}


		// dump(var=status, top=2);		abort;
		return status;
	}
}