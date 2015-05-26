/**
 * Properties that inform the build about where to get things, etc.
 *
 * @accessors true
 */
component accessors=true {
	cwd     = GetDirectoryFromPath( GetCurrentTemplatePath() );
	docsDir = ExpandPath( "/docs/" );

	property name="functionReferenceDirectory" default="#docsDir#03.reference/01.functions/";
	property name="tagReferenceDirectory"      default="#docsDir#03.reference/02.tags/";
	property name="version"                    default="4.5.1";
	// property name="functionReferenceUrl" default="https://bitbucket.org/lucee/lucee/raw/a6b37ad6463707576ec03f03e1a3493f1e366a12/lucee-java/lucee-core/src/resource/fld/web-cfmfunctionlibrary_1_0";
	// property name="tagReferenceUrl"      default="https://bitbucket.org/lucee/lucee/raw/a6b37ad6463707576ec03f03e1a3493f1e366a12/lucee-java/lucee-core/src/resource/tld/web-cfmtaglibrary_1_0";
	property name="functionReferenceUrl" default="#cwd#funclib.xml";
	property name="tagReferenceUrl"      default="#cwd#taglib.xml";
	property name="editSourceLink"       default="https://bitbucket.org/lucee/documentation/src/master{path}";
	property name="dashBuildNumber"      default="1.0.2";
	property name="dashDownloadUrl"      default="http://docs.lucee.org/dash/lucee.tgz";
}