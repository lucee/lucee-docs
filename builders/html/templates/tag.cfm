<cfset local.args = arguments.args>
<cfparam name="args.page" type="page" />

<cfset local.tag = args.page />
<cfset local.attributesHaveDefaultValues = tag.attributesHaveDefaultValues() />

<cfoutput>
	#getEditLink(path=local.tag.getSourceFile(), edit=args.edit)#
	#_markdownToHtml( local.tag.getBody() )#

	#_markdownToHtml( Trim( local.tag.getBodyTypeDescription() ) )#
	#_markdownToHtml( Trim( local.tag.getScriptSupportDescription() ) )#

	<cfif len(local.tag.getStatus()) gt 0
			and (local.tag.getStatus() neq "implemented" and local.tag.getStatus() neq "implemeted")>
		<cfscript>
			if (local.tag.getStatus() eq "Deprecated") {
				local.status = _markdownToHtml( "[[deprecated|#local.tag.getStatus()#]]", true );
			} else {
				local.status = local.tag.getStatus();
			}
		</cfscript>	
		<p><strong>Status:</strong> #local.status#</p>
	</cfif>
	<cfif len(local.tag.getSrcExtension()) gt 0>
		<p><strong>Requires Extension: </strong> #local.tag.getSrcExtension().name#</p>
	</cfif>
	
	<code>
		#local.tag.getUsageSignature()#
	</code>

	<cfif !local.tag.getAttributes().len()>
		<p><em>This tag does not use any attributes.</em></p>
	<cfelse>
		<div class="table-responsive">
			<cfif local.tag.getAttributes().len() gt 5>
				<div class="tile-toolbar">
					<button class="btn collapse-description" data-expanded="true" data-target="tag-attributes">Collapse All</button>
				</div>
			</cfif>
			<cfset local.unimplementedAttribs = []>
			<table class="table attributes" title="Attributes" id="tag-attributes">
				<thead>
					<tr>
						<th>Attribute</th>
						<th>Description</th>
						<cfif local.attributesHaveDefaultValues><th>Default</th></cfif>
					</tr>
				</thead>
				<tbody>
					<cfloop array="#local.tag.getAttributes()#" item="local.attrib" index="i">
						<cfif local.attrib.status neq "implemented">
							<cfset arrayAppend(local.unimplementedAttribs, local.attrib)>
							<cfcontinue>
						</cfif>
						<tr>
							<td translate="no"><div class="attribute" id="attribute-#local.attrib.name#">#local.attrib.name#</div>
							<sub>#local.attrib.type#, #( local.attrib.required ? 'required' : 'optional' )#</sub>
							</td>
							<td>
								#getEditLink(path=local.tag.getSourceDir() & '_attributes/#local.attrib.name#.md', edit=args.edit)#
								#_markdownToHtml( local.attrib.description ?: "" )#
								<cfif structKeyExists(local.attrib, "aliases") && Arraylen(local.attrib.aliases) gt 0>
									<p title="for compatibility, this attribute has the following alias(es)"><sub>Alias:</strong>
									<span translate="no">#ArrayToList(local.attrib.aliases,", ")#</span></sub></p>
								</cfif>
								<cfif structKeyExists(local.attrib, "status") and local.attrib.status neq "implemented">
									<em>* #local.attrib.status# *</em>
								</cfif>
								#showOriginalDescription(props=local.attrib, edit=args.edit, _markdownToHtml=_markdownToHtml)#
								<cfif structKeyExists(local.attrib, "introduced") and len(local.attrib.introduced) gt 0>
									<p><strong>Introduced:</strong> #local.attrib.introduced#</p>
								</cfif>
							</td>
 							<cfif local.attributesHaveDefaultValues>
 								<td translate="no">
 									#_markdownToHtml( local.attrib.defaultValue ?: "" )#
 								</td>
							 </cfif>
						</tr>
					</cfloop>
				</tbody>
			</table>
			<cfif ArrayLen(unimplementedAttribs) gt 0>
				<h4>Unimplemented Attribute(s)</h4>
				<table class="table attributes" title="Attributes" id="tag-attributes">
					<thead>
						<tr>
							<th>Attribute</th>
							<th>Description</th>
							<cfif local.attributesHaveDefaultValues><th>Default</th></cfif>
						</tr>
					</thead>
					<tbody>
						<cfloop array="#unimplementedAttribs#" item="local.attrib" index="i">
							<tr>
								<td><div class="attribute" id="attribute-#local.attrib.name#" translate="no">#local.attrib.name#</div>
								<sub><span translate="no">#local.attrib.type#</span>, 
									#( local.attrib.required ? 'required' : 'optional' )#</sub>
								</td>
								<td>
									#getEditLink(path=local.tag.getSourceDir() & '_attributes/#local.attrib.name#.md', edit=args.edit)#
									#_markdownToHtml( local.attrib.description ?: "" )#
									<cfif structKeyExists(local.attrib, "aliases") && Arraylen(local.attrib.aliases) gt 0>
										<p title="for compatibility, this attribute has the following alias(es)"><sub>Alias:</strong> #ArrayToList(local.attrib.aliases,", ")#</sub></p>
									</cfif>
									<cfif structKeyExists(local.attrib, "status") and local.attrib.status neq "implemented">
										<em>* #local.attrib.status# *</em>
									</cfif>
									#showOriginalDescription(props=local.attrib, edit=args.edit, _markdownToHtml=_markdownToHtml)#
								</td>
								 <cfif local.attributesHaveDefaultValues>
									 <td translate="no">
										 #_markdownToHtml( local.attrib.defaultValue ?: "" )#
									 </td>
								 </cfif>
							</tr>
						</cfloop>
					</tbody>
				</table>
			</cfif>
		</div>
	</cfif>

	<cfif Len( Trim( local.tag.getUsageNotes() ) ) or args.edit>
		<div class="usage-notes">
			<h4>Usage Notes</h4>
			#getEditLink(path=local.tag.getSourceDir() & '_usageNotes.md', edit=args.edit)#
			<cfif Len( Trim( local.tag.getUsageNotes() ) )>
				#_markdownToHtml( local.tag.getUsageNotes() )#
			</cfif>
		</div>
	</cfif>	

	<h4>Examples</h4>
	<cfif Len( Trim( local.tag.getExamples() ) ) or args.edit>
		#getEditLink(path=local.tag.getSourceDir() & '_examples.md', edit=args.edit)#
	</cfif>
	<cfif Len( Trim( local.tag.getExamples() ) )>
		#_markdownToHtml( local.tag.getExamples() )#
	<cfelse>
		<em>There are currently no examples for this tag.</em>
	</cfif>
</cfoutput>
