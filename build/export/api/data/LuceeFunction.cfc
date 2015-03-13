component accessors=true {

	property name="definition" type="struct";

	public string function getUsageSignature() {
		var usage = this.getName() & "(";
		var delim = " ";
		var optionalCount = 0;

		for( var argument in this.getArguments() ) {
			if ( !argument.required ) {
				usage &= " [";
				optionalCount++;
			}

			usage &= delim & argument.name;
			delim = ", ";
		}

		usage &= RepeatString( " ]", optionalCount );
		usage &= " )";

		return usage;
	}

	public any function onMissingMethod( required string methodName, required any methodArguments ) {
		if ( arguments.methodName.startsWith( "get" ) ) {
			var propertyName = ReReplaceNoCase( arguments.methodName, "^get", "" );

			return definition[ propertyName ] ?: "";
		}
	}
}