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
	property name="objectReferenceDirectory"   default="#docsDir#03.reference/05.objects/";
	property name="version"                    default="4.5.1";
	property name="editSourceLink"             default="https://github.com/lucee/lucee-docs/edit/master{path}";
	property name="issueTrackerLink" 		   default=
	"https://luceeserver.atlassian.net/secure/QuickSearch.jspa?jql=#urlEncodedFormat('text ~ "')#{search}#urlEncodedFormat('" ORDER BY updated')#";
	property name="testCasesLink"              default=
	"https://github.com/search?q={search}+repo%3Alucee%2FLucee+path%3A%2Ftest&type=code";
}
