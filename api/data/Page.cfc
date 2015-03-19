component accessors=true {
	property name="id"           type="string";
	property name="slug"         type="string";
	property name="parentId"     type="string";
	property name="parent"       type="any";
	property name="pageType"     type="string";
	property name="children"     type="array";
	property name="depth"        type="numeric";
	property name="filePath"     type="string";
	property name="title"        type="string";
	property name="body"         type="string"  default="";
	property name="sortOrder"    type="numeric" default="0";
	property name="visible"      type="boolean" default=false;
	property name="related"      type="array";
	property name="listingStyle" type="string" default="";

	public void function addChild( required any childPage ) {
		getChildren().append( arguments.childPage );
	}
}