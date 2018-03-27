<cfparam name="args.page" type="page" />

<cfset pg = args.page />

<cfoutput>
	#getEditLink(path=pg.getSourceFile(), edit=args.edit)#
	#markdownToHtml( pg.getBody() )#
</cfoutput>