<cfparam name="args.page" type="page" />

<cfset tag = args.page />

<cfoutput>
	<h1>#HtmlEditFormat( tag.getTitle() )#</h1>

	#markdownToHtml( tag.getBody() )#

	<h2>Attributes</h2>
	<cfif !tag.getAttributes().len()>
		<p><em>This tag does not use any attributes.</em></p>
	<cfelse>
		<dl class="dl-horizontal">
			<cfloop array="#tag.getAttributes()#" item="attrib" index="i">
				<dt>#attrib.name#</dt>
				<dd>
					<aside class="light">(#attrib.type#, #( attrib.required ? 'required' : 'optional' )#)</aside>

					#markdownToHtml( attrib.description ?: "" )#
				</dd>
			</cfloop>
		</dl>
	</cfif>
</cfoutput>