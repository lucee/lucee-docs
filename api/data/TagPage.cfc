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
	property name="usageNotes"   		 type="string";

	public string function getUsageSignature() {
		var newLine           = Chr(10);
		var indent            = RepeatString( " ", 4 );
		var tagName           = "cf" & LCase( this.getName() );
		var usage             = "&lt;" & tagName;
		var closingTag        = "";
		var bodyType          = this.getBodyContentType();
		var unnamedAttributes = ( this.getAttributeType() ?: "" ) == "noname";

		for( var attribute in this.getAttributes() ) {

			if ( unnamedAttributes ) {
				usage &= " ###attribute.type# #attribute.name###";
			} else {
				usage &= newline & indent;
				if ( !attribute.required ) {
					usage &= "<em title='optional'>";
				}

				usage &= '#attribute.name#=';

				if ( IsArray( attribute.values ?: "" ) && attribute.values.len() ) {
 					usage &= attribute.values.toList( "|" );
				} else {
 					usage &= attribute.type;
				}

				if ( !attribute.required ) {
					usage &= "</em>";
				}
			}
		}

		if ( !unnamedAttributes && this.getAttributes().len() ) {
			usage &= newLine();
		}

		switch( bodyType ) {
			case "free":
				closingTag &=  htmlEditFormat("><!--- body --->[</#tagName#>]")
			break;
			case "required":
				closingTag &=  htmlEditFormat("><!--- body ---></#tagName#>")
			break;
			default:
				closingTag &= "&gt;";
			break;
		}

		usage &= closingTag;

		return usage;
	}

	public string function getBodyTypeDescription(){
		switch( this.getBodyContentType() ) {
			case "prohibited" :
			case "empty"      : return "This tag **cannot** have a body.";
			case "free"       : return "This tag **may** have a body.";
			case "required"   : return "This tag **must** have a body.";
			default			  : return "";
		}
	}

	public string function getScriptSupportDescription(){
		var scriptType = this.script.type ?: "";

		if ( scriptType == "none" ) {
			return "This tag has no [[tag-script]] support or it uses a different syntax.";
		}

		return "This tag is also supported within [[tag-script]]";
	}

	public boolean function attributesHaveDefaultValues() {
		for( var attr in getAttributes() ) {
			if ( !IsNull( attr.defaultValue ) ) {
				return true;
			}
		}
		return false;
	}

	public array function getAttributes(){
		return IsNull( this.attributes ) ? [] : this.attributes;
	}
}