component accessors=true {

	property name="definition" type="struct";

	public any function onMissingMethod( required string methodName, required any methodArguments ) {
		if ( arguments.methodName.startsWith( "get" ) ) {
			var propertyName = ReReplaceNoCase( arguments.methodName, "^get", "" );

			return definition[ propertyName ] ?: "";
		}
	}
}