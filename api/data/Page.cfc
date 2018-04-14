component accessors=true {
	property name="id"           type="string" default="";
	property name="path"         type="string" default="";
	property name="sourceDir"    type="string" default="";
	property name="sourceFile"   type="string" default="";
	property name="slug"         type="string" default="";
	property name="pageType"     type="string" default="";
	property name="children"     type="array";
	property name="depth"        type="numeric" default=0;
	property name="filePath"     type="string"  default="";
	property name="title"        type="string"  default="";
	property name="description"  type="string"  default="";
	property name="body"         type="string"  default="";
	property name="sortOrder"    type="numeric" default="0";
	property name="forceSortOrder"    type="numeric" default="-1";
	property name="visible"      type="boolean" default=false;
	property name="related"      type="array";
	property name="listingStyle" type="string" default="";
	property name="reference" 	 type="boolean" default="true"; // whether to include in see also

	property name="ancestors"    type="array";
	property name="lineage"      type="array";
	property name="parent"       type="any";
	property name="nextPage"     type="any";
	property name="previousPage" type="any";
	property name="categories"   type="array";

	property name="methodObject"  type="string"  default="";
	property name="methodName"  type="string"  default="";

	public void function addChild( required any childPage ) {
		getChildren().append( arguments.childPage );
	}

	public any function onMissingMethod() {
		// allow missing setters - fix for change in Lucee 5.2
	}

	// reset page when loading from from cache;
	public void  function reset() {
		ancestors = [];
		lineage = [];
		parent = NullValue();
		nextPage = NullValue();
		previousPage = NullValue();
		children= [];
	}

	public struct function getPageLineageMap(){
		var lineageMap = {};
		for (var l in variables.lineage)
			lineageMap[l]="";
		return lineageMap;
	}

	public boolean function isPage() {
		switch (this.getPageType()){
			case "homepage":
			case "page":
			case "chapter":
			case "category":
			case "function":
			case "listing":
			case "_object":
			case "_method":
			case "tag":
				return true;
			case "_arguments":
			case "_attributes":
			case "_examples":
			case "_image":
				return false;
			default:
				request.logger (text="Unknown pageType: #pageType#, #arguments.page.getPath()#", type="WARN");
				return false;
		};
	}
}