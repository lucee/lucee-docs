/**
 * Properties that inform the build about where to get things, etc.
 *
 * @accessors true
 */
component accessors=true {
	buildDir = GetDirectoryFromPath( GetCurrentTemplatePath() );
	dataDir  = ExpandPath( buildDir & "/../docs/" );

	property name="referenceDirectory"   default="#dataDir#reference/";
	property name="version"              default="4.5.1";
	property name="functionReferenceUrl" default="https://bitbucket.org/lucee/lucee/raw/a6b37ad6463707576ec03f03e1a3493f1e366a12/lucee-java/lucee-core/src/resource/fld/web-cfmfunctionlibrary_1_0";
	property name="tagReferenceUrl"      default="https://bitbucket.org/lucee/lucee/raw/a6b37ad6463707576ec03f03e1a3493f1e366a12/lucee-java/lucee-core/src/resource/tld/web-cfmtaglibrary_1_0";
}