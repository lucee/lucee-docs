<cfparam name="arguments.args.page" type="page" />

<cfset local.pg = arguments.args.page />

<cfscript>
	pg   = arguments.args.page;
	body = _markdownToHtml( pg.getBody() );
</cfscript>

<cfoutput>
	#getEditLink(path=local.pg.getSourceFile(), edit=arguments.args.edit)#
	#toc( body )#
	<cfif structKeyExists(pg, "since")>
		<b>Introduced:</b> #pg.since#<br>
	</cfif>
	#body#
</cfoutput>