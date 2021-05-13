component accessors=true extends="Page" {

	property name="name"         type="string";
	property name="description"  type="string";
	property name="returnType"   type="string";
	property name="argumentType" type="string";
	property name="arguments"    type="array";
	property name="examples"     type="string";
	property name="introduced"   type="string";
	property name="alias"        type="string";
	property name="status"        type="string";

	public string function getTitle() {
		return super.getTitle() & "()";
	}

	public string function getUsageSignature() {
		var usage = super.getTitle() & "(";
		var delim = " ";
		var optionalCount = 0;

		for( var argument in this.getArguments() ) {
			if ( !argument.required ) {
				usage &= "<em title='optional'>";
				optionalCount++;
			}
			usage &= delim & argument.name & "=";

			if ( IsArray( argument.values ?: "" ) && argument.values.len() ) {
				usage &= argument.values.toList( "|" );
			} else {
				usage &= argument.type;
		   	}
			usage &= "</em>";
			delim = ", ";
		}
		//usage &= "</em>";
		//usage &= RepeatString( " ]", optionalCount );
		usage &= " );";

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
