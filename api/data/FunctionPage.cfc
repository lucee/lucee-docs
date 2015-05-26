component accessors=true extends="Page" {

	property name="name"         type="string";
	property name="description"  type="string";
	property name="returnType"   type="string";
	property name="argumentType" type="string";
	property name="arguments"    type="array";
	property name="examples"     type="string";

	public string function getUsageSignature() {
		var usage = this.getTitle() & "(";
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
}