<cfparam name="args.page" type="page" />

<cfset local.pg = args.page />

<cfoutput>
	#getEditLink(path=local.pg.getSourceFile(), edit=args.edit)#
	#markdownToHtml( local.pg.getBody() )#
</cfoutput>