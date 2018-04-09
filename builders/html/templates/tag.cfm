<cfparam name="args.page" type="page" />

<cfset local.tag = args.page />
<cfset local.attributesHaveDefaultValues = tag.attributesHaveDefaultValues() />

<cfoutput>
	#getEditLink(path=local.tag.getSourceFile(), edit=args.edit)#
	#markdownToHtml( local.tag.getBody() )#

	#markdownToHtml( Trim( local.tag.getBodyTypeDescription() ) )#
	#markdownToHtml( Trim( local.tag.getScriptSupportDescription() ) )#

	<h2>Attributes</h2>
	<cfif !local.tag.getAttributes().len()>
		<p><em>This tag does not use any attributes.</em></p>
	<cfelse>
		<div class="table-responsive">
			<table class="table" title="Attributes">
				<thead>
					<tr>
						<th>Attribute</th>
						<th>Description</th>
						<cfif local.attributesHaveDefaultValues><th>Default</th></cfif>
					</tr>
				</thead>
				<tbody>
					<cfloop array="#local.tag.getAttributes()#" item="local.attrib" index="i">
						<tr>
							<td><div class="attribute">#local.attrib.name#</div>
							<sub>(#local.attrib.type#, #( local.attrib.required ? 'required' : 'optional' )#)</sub>
							</td>
							<td>
								#getEditLink(path=local.tag.getSourceDir() & '_attributes/#local.attrib.name#.md', edit=args.edit)#
								#markdownToHtml( local.attrib.description ?: "" )#
							</td>
 							<cfif local.attributesHaveDefaultValues>
 								<td>
 									#markdownToHtml( local.attrib.defaultValue ?: "" )#
 								</td>
 							</cfif>
						</tr>
					</cfloop>
				</tbody>
			</table>
		</div>
	</cfif>

	<h2>Usage</h2>
```lucee
#local.tag.getUsageSignature()#
```
	<h2>Examples</h2>
	<cfif Len( Trim( local.tag.getExamples() ) ) or args.edit>
		#getEditLink(path=local.tag.getSourceDir() & '_examples.md', edit=args.edit)#
	</cfif>
	<cfif Len( Trim( local.tag.getExamples() ) )>
		#markdownToHtml( local.tag.getExamples() )#
	<cfelse>
		<em>There are currently no examples for this tag.</em>
	</cfif>
</cfoutput>