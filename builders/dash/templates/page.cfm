<cfset local.args = arguments.args><!--- scope hack --->
<cfparam name="args.page" type="page" />

<cfset local.pg = args.page />

<cfoutput>
	#getEditLink(path=local.pg.getSourceFile(), edit=args.edit)#
	#_markdownToHtml( local.pg.getBody() )#
</cfoutput>