<cfparam name="args.page" type="page" />

<cfset tag = args.page />

<cfoutput>
	#markdownToHtml( tag.getBody() )#

	<h2>Usage</h2>
```lucee
#tag.getUsageSignature()#
```

	#markdownToHtml( Trim( tag.getBodyTypeDescription() ) )#
	#markdownToHtml( Trim( tag.getScriptSupportDescription() ) )#

	<h2>Attributes</h2>
	<cfif !tag.getAttributes().len()>
		<p><em>This tag does not use any attributes.</em></p>
	<cfelse>
		<div class="table-responsive">
			<table class="table" title="Attributes">
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
								<sub>(#attrib.type#, #( attrib.required ? 'required' : 'optional' )#)</sub>
							</td>
							<td>#markdownToHtml( attrib.description ?: "" )#</td>
						</tr>
					</cfloop>
				</tbody>
			</table>
		</div>
	</cfif>

	<h2>Examples</h2>
	<cfif Len( Trim( tag.getExamples() ) )>
		#markdownToHtml( tag.getExamples() )#
	<cfelse>
		<em>There are currently no examples for this tag</em>
	</cfif>
</cfoutput>