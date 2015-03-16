<cfparam name="args.page" type="page" />

<cfset pg = args.page />

<cfoutput>
	#markdownToHtml( pg.getBody() )#
</cfoutput>