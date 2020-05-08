<cfparam name="args.page" type="page" />

<cfset local.tag = args.page />
<cfset local.attributesHaveDefaultValues = tag.attributesHaveDefaultValues() />

<cfoutput>
	#getEditLink(path=local.tag.getSourceFile(), edit=args.edit)#
	#markdownToHtml( local.tag.getBody() )#

	#markdownToHtml( Trim( local.tag.getBodyTypeDescription() ) )#
	#markdownToHtml( Trim( local.tag.getScriptSupportDescription() ) )#

	<code>
		#local.tag.getUsageSignature()#
	</code>

	<cfif !local.tag.getAttributes().len()>
		<p><em>This tag does not use any attributes.</em></p>
	<cfelse>
		<div class="table-responsive">
			<table class="table attributes" title="Attributes">
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
							<td><div class="attribute" id="attribute-#local.attrib.name#">#local.attrib.name#</div>
							<sub>#local.attrib.type#, #( local.attrib.required ? 'required' : 'optional' )#</sub>
							</td>
							<td>
								#getEditLink(path=local.tag.getSourceDir() & '_attributes/#local.attrib.name#.md', edit=args.edit)#
								#markdownToHtml( local.attrib.description ?: "" )#
								<cfif structKeyExists(local.attrib, "aliases") && Arraylen(local.attrib.aliases) gt 0>
									<p title="for compatability, this attribute has the following alias(es)"><sub>Alias:</strong> #ArrayToList(local.attrib.aliases,", ")#</sub></p>
								</cfif>
								<cfif structKeyExists(local.attrib, "status") and local.attrib.status neq "implemented">
									<em>* #local.attrib.status# *</em>
								</cfif>
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

	<h4>Examples</h4>
	<cfif Len( Trim( local.tag.getExamples() ) ) or args.edit>
		#getEditLink(path=local.tag.getSourceDir() & '_examples.md', edit=args.edit)#
	</cfif>
	<cfif Len( Trim( local.tag.getExamples() ) )>
		#markdownToHtml( local.tag.getExamples() )#
	<cfelse>
		<em>There are currently no examples for this tag.</em>
	</cfif>
</cfoutput>
