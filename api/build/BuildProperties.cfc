/**
 * Properties that inform the build about where to get things, etc.
 *
 * @accessors true
 */
component accessors=true {
	cwd     = GetDirectoryFromPath( GetCurrentTemplatePath() );	 
	property name="docsDir" default="#ExpandPath( "/docs/" )#";
	property name="functionReferenceDirectory" default="#docsDir#03.reference/01.functions/";
	property name="tagReferenceDirectory"      default="#docsDir#03.reference/02.tags/";
	property name="objectReferenceDirectory"      default="#docsDir#03.reference/05.objects/";	
	property name="version"                    default="4.5.1";

	property name="editSourceLink"       default="https://github.com/lucee/lucee-docs/edit/master{path}";
	property name="dashBuildNumber"      default="1.0.2";
	property name="dashDownloadUrl"      default="https://docs.lucee.org/dash/lucee.tgz";
	property name="issueTrackerLink" 		default=
	"https://luceeserver.atlassian.net/secure/QuickSearch.jspa?jql=#urlEncodedFormat('text ~ "')#{search}#urlEncodedFormat('" ORDER BY updated')#";
}

