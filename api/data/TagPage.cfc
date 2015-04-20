component accessors=true extends="Page" {
	property name="name"                 type="string"  default="";
	property name="description"          type="string"  default="";
	property name="status"               type="string"  default="";
	property name="appendix"             type="boolean" default=false;
	property name="bodyContentType"      type="string"  default="";
	property name="attributeType"        type="string"  default="";
	property name="minimumAttributes"    type="numeric" default=0;
	property name="handleException"      type="boolean" default=false;
	property name="allowRemovingLiteral" type="boolean" default=false;
	property name="script"               type="struct";
	property name="attributes"           type="array";
	property name="examples"             type="string";

	public string function getUsageSignature() {
		var newLine           = Chr(10);
		var indent            = RepeatString( " ", 4 );
		var tagName           = "cf" & LCase( this.getName() );
		var usage             = "<" & tagName;
		var closingTag        = "";
		var bodyType          = this.getBodyContentType();
		var unnamedAttributes = ( this.getAttributeType() ?: "" ) == "noname";

		for( var attribute in this.getAttributes() ) {
			if ( unnamedAttributes ) {
				usage &= " ###attribute.type# #attribute.name###";
			} else {
				usage &= newline & indent;
				if ( !attribute.required ) {
					usage &= "[";
				}

				usage &= '#attribute.name#="#attribute.type#"';

				if ( !attribute.required ) {
					usage &= "]";
				}
			}
		}

		if ( !unnamedAttributes && this.getAttributes().len() ) {
			usage &= newLine();
		}

		switch( bodyType ) {
			case "free":
				closingTag &=  "><!--- body --->[</#tagName#>]"
			break;
			case "prohibited":
				closingTag &= ">";
			break;
			default:
				closingTag &=  "><!--- body ---></#tagName#>"
			break;
		}

		usage &= closingTag;

		return usage;
	}
}