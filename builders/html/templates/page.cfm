<cfparam name="arguments.args.page" type="page" />

<cfset local.pg = arguments.args.page />

<cfscript>
	pg   = arguments.args.page;
	body = _markdownToHtml( pg.getBody() );
</cfscript>

<cfoutput>
	#getEditLink(path=local.pg.getSourceFile(), edit=arguments.args.edit)#
	#toc( body )#
	#body#
</cfoutput>