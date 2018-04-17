component accessors=true extends="Page" {

	property name="name"         type="string";
	property name="description"  type="string";
	property name="returnType"   type="string";
	property name="argumentType" type="string";
	property name="arguments"    type="array";
	property name="examples"     type="string";
	property name="introduced"   type="string";
	property name="alias"        type="string";

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

	public boolean function argumentsHaveDefaultValues() {
 		for( var arg in getArguments() ) {
 			if ( !IsNull( arg.default ) ) {
 				return true;
 			}
 		}

 		return false;
	}

	public array function getArguments() {
		return IsNull( this.arguments ) ? [] : this.arguments;
	}
}