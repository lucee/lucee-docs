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
	property name="examples"             type="array";
}