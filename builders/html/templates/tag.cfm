<cfparam name="args.page" type="page" />

<cfset tag = args.page />

<cfoutput>
	<h1>#HtmlEditFormat( tag.getTitle() )#</h1>

	#markdownToHtml( tag.getBody() )#

	<h2>Usage</h2>
	{{highlight:html}}#tag.getUsageSignature()#{{highlight}}

	<h2>Attributes</h2>
	<cfif !tag.getAttributes().len()>
		<p><em>This tag does not use any attributes.</em></p>
	<cfelse>
		<table class="table table-striped argument-table">
			<thead>
				<tr>
					<th>Attribute</th>
					<th>Description</th>
				</tr>
			</thead>
			<tbody>
				<cfloop array="#tag.getAttributes()#" item="attrib" index="i">
					<tr>
						<td>
							#attrib.name#<br>
							<aside class="light">(#attrib.type#, #( attrib.required ? 'required' : 'optional' )#)</aside>
						</td>
						<td>#markdownToHtml( attrib.description ?: "" )#</td>
					</tr>
				</cfloop>
			</tbody>
		</table>
	</cfif>

	<h2>Examples</h2>
	<cfif Len( Trim( tag.getExamples() ) )>
		#markdownToHtml( tag.getExamples() )#
	<cfelse>
		<em>There are currently no examples for this tag</em>
	</cfif>
</cfoutput>