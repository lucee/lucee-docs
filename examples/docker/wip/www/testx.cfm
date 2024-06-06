<cfscript>
extensionList="https://extension.lucee.org/rest/extension/provider/info?withLogo=false";

function getAvailableExtensions() {
	http url=extensionList cachedWithin=0.01 result="local.res";
	var extensions=deserializeJson(res.filecontent,false).extensions;
	return extensions;
}
	
extensions=getAvailableExtensions();
</cfscript>



