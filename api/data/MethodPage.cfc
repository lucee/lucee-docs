component accessors=true extends="Page" {

	property name="name"         type="string";
	property name="methodObject" type="string";
	property name="methodName"   type="string";
	property name="description"  type="string";
	property name="returnType"   type="string";
	property name="argMin"       type="numeric";
	property name="argMax"       type="numeric";
	property name="returnType"   type="string";
	property name="argumentType" type="string";
	property name="arguments"    type="array";
	property name="keywords"     type="array";
	property name="examples"     type="string";
	property name="introduced"   type="string";
	property name="member"       type="struct";
	property name="alias"        type="string";

	public string function getUsageSignature() {
		var usage = this.getMethodObject() & "." & this.getMethodName() & "(";
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
		usage &= "</em>";
		//usage &= RepeatString( " ]", optionalCount );
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
		var args = Duplicate( IsNull( this.arguments ) ? [] : this.arguments );
		if (structKeyExists(this, "member") && structKeyExists(this.member, "position")){
			if ( ArrayLen( args ) >= this.member.position ) {
				args.deleteAt( this.member.position );
			}
		}
		return args;
	}

	public string function getReturnType() {
		if (structKeyExists(this.member, "chaining") && this.member.chaining)
			return this.member.type;
		else
			return this.returnType;
	}
}
