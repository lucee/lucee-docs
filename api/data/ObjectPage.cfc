component accessors=true extends="Page" {

	property name="name"         type="string";
	property name="description"  type="string";
	property name="returnType"   type="string";
	property name="argumentType" type="string";
	property name="arguments"    type="array";
	property name="examples"     type="string";
	property name="introduced"   type="string";
	property name="visible"      type="boolean" default="true";

	public string function getUsageSignature() {
        return "";
		var usage = this.getTitle() & "(";
		var delim = " ";
		var optionalCount = 0;
		var skip = true; // to skip first argument

		for( var argument in this.getArguments() ) {
			if ( skip ) {
				skip = false;
				continue;
			}
			if ( !argument.required ) {
				usage &= "<em title='optional'>";
				optionalCount++;
			}

			usage &= delim & argument.name;
			delim = ", ";
		}
		usage &= "</em>";
		//usage &= RepeatString( " ]", optionalCount );
		usage &= " )";

		return usage;
	}
}
