<cfparam name="args.page" type="page" />

<cfset pg = args.page />

<cfoutput>
	<h1>#pg.getTitle()#</h1>

	#markdownToHtml( pg.getBody() )#
</cfoutput>