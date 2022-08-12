<cfparam name="arguments.args.page" type="page" />
<cfset local.args = arguments.args>

<cfset local.fn = args.page />
<cfset local.argumentsHaveDefaultValues = local.fn.argumentsHaveDefaultValues() />
<cfoutput>
	#getEditLink(path=local.fn.getSourceFile(), edit=args.edit)#
	#markdownToHtml( local.fn.getBody() )#
	<!--- https://github.com/lucee/Lucee/pull/876 --->
	<cfif len(local.fn.getStatus()) gt 0
			and (local.fn.getStatus() neq "implemented" and local.fn.getStatus() neq "implemeted")>
		<cfscript>
			if (local.fn.getStatus() eq "Deprecated") {
				local.status = markdownToHtml( "[[deprecated|#local.fn.getStatus()#]]", true );
			} else {
				local.status = local.fn.getStatus();
			}
		</cfscript>	
		<p><strong>Status:</strong> #local.status#</p>
	</cfif>
	<cfif len(local.fn.getAlias()) gt 0>
		<p><strong>Alias:</strong> #local.fn.getAlias()#</p>
	</cfif>
	<cfif len(local.fn.getIntroduced()) gt 0>
		<p><strong>Introduced:</strong> #local.fn.getIntroduced()#</p>
	</cfif>
	<cfif len(local.fn.getSrcExtension()) gt 0>
		<p><strong>Requires Extension: </strong> #local.fn.getSrcExtension().name#</p>
	</cfif>
	<code>
	#local.fn.getUsageSignature()#
	</code>
	<div class="func-return-type-desc">
		<p>Returns: #local.fn.getReturnTypeLink()#</p>
		<cfif Len( Trim( local.fn.getReturnTypeDesc() ) ) or args.edit>
			
			<div class="func-return-type-desc-edit">
				<cfif args.edit>
					<strong>Return Type Description (title only shown in edit mode, normally just a paragraph)</strong>
				</cfif>
				#getEditLink(path=local.fn.getSourceDir() & '_returnTypeDesc.md', edit=args.edit)#
			</div>
			<cfif Len( Trim( local.fn.getReturnTypeDesc() ) )>
				#markdownToHtml( local.fn.getReturnTypeDesc() )#
			</cfif>		
		</cfif>
	</div>

	<cfif !local.fn.getArguments().len()>
		<cfif local.fn.getArgumentType() == "dynamic">
			<p><em>This function takes zero or more dynamic arguments. See examples for details.</em></p>
		<cfelse>
			<p><em>This function does not take any arguments.</em></p>
		</cfif>
	<cfelse>
		<div class="table-responsive">
			<cfif local.fn.getArguments().len() gt 5>
				<div class="tile-toolbar">
					<button class="btn collapse-description" data-expanded="true" data-target="table-arguments">Collapse All</button>
				</div>
			</cfif>
			<cfset local.unimplementedArgs = []>
			<table class="table arguments table-arguments" title="Arguments">
				<thead>
					<tr>
						<th>Argument</th>
						<th>Description</th>
						<cfif local.argumentsHaveDefaultValues><th>Default</th></cfif>
					</tr>
				</thead>
				<tbody>
					<cfloop array="#local.fn.getArguments()#" item="local.arg" index="local.i">
						<cfif local.arg.status neq "implemented">
							<cfset arrayAppend(unimplementedArgs, local.arg)>
							<cfcontinue>
						</cfif>
						<tr>
							<td>
								<div class="argument" id="argument-#local.arg.name#" title="Argument name">
									#local.arg.name#
								</div>
								<sub title="Argument type">
									#local.arg.type#,
									<span title="Is this argument required">
										#( local.arg.required ? 'required' : 'optional' )#
									</span>
								</sub>
							</td>
							<td>
								#getEditLink(path=local.fn.getSourceDir() & '_arguments/#local.arg.name#.md', edit=args.edit)#
								#markdownToHtml( Trim( local.arg.description ) )#
								<cfif len(local.arg.alias) gt 0>
									<p title="for compatibility, this argument has the following alias(es)"><sub>Alias:</strong> #ListChangeDelims(local.arg.alias,", ",",")#</sub></p>
								</cfif>
								<cfif structKeyExists(local.arg, "status") and local.arg.status neq "implemented">
									<em>* #local.arg.status# *</em>
								</cfif>
								#showOriginalDescription(props=local.arg, edit=args.edit, markdownToHtml=markdownToHtml)#
								<cfif structKeyExists(local.arg, "introduced") and len(local.arg.introduced) gt 0>
									<p><strong>Introduced:</strong> #local.arg.introduced#</p>
								</cfif>
							</td>
							<cfif local.argumentsHaveDefaultValues>
 								<td>
 									#markdownToHtml( local.arg.default ?: "" )#
 								</td>
							</cfif>
							
						</tr>
					</cfloop>
				</tbody>
			</table>
			<cfif ArrayLen(unimplementedArgs) gt 0>
				<h4>Unimplemented Argument(s)</h4>
				<table class="table arguments table-arguments" title="Arguments">
					<thead>
						<tr>
							<th>Argument</th>
							<th>Description</th>
							<cfif local.argumentsHaveDefaultValues><th>Default</th></cfif>
						</tr>
					</thead>
					<tbody>
						<cfloop array="#unimplementedArgs#" item="local.arg" index="local.i">
							<tr>
								<td>
									<div class="argument" id="argument-#local.arg.name#" title="Argument name">
										#local.arg.name#
									</div>
									<sub title="Argument type">
										#local.arg.type#,
										<span title="Is this argument required">
											#( local.arg.required ? 'required' : 'optional' )#
										</span>
									</sub>
								</td>
								<td>
									#getEditLink(path=local.fn.getSourceDir() & '_arguments/#local.arg.name#.md', edit=args.edit)#
									#markdownToHtml( Trim( local.arg.description ) )#
									<cfif len(local.arg.alias) gt 0>
										<p title="for compatibility, this argument has the following alias(es)"><sub>Alias:</strong> #ListChangeDelims(local.arg.alias,", ",",")#</sub></p>
									</cfif>
									<cfif structKeyExists(local.arg, "status") and local.arg.status neq "implemented">
										<em>* #local.arg.status# *</em>
									</cfif>
									#showOriginalDescription(props=local.arg, edit=args.edit, markdownToHtml=markdownToHtml)#
								</td>
								<cfif local.argumentsHaveDefaultValues>
									 <td>
										 #markdownToHtml( local.arg.default ?: "" )#
									 </td>
								 </cfif>
							</tr>
						</cfloop>
					</tbody>
				</table>
			</cfif>
		</div>
	</cfif>

	<cfif Len( Trim( local.fn.getUsageNotes() ) ) or args.edit>
		<div class="usage-notes">
			<h4>Usage Notes</h4>
			#getEditLink(path=local.fn.getSourceDir() & '_usageNotes.md', edit=args.edit)#
			<cfif Len( Trim( local.fn.getUsageNotes() ) )>
				#markdownToHtml( local.fn.getUsageNotes() )#
			</cfif>
		</div>
	</cfif>

	<h4>Examples</h4>
	<cfif Len( Trim( local.fn.getExamples() ) ) or args.edit>
		#getEditLink(path=local.fn.getSourceDir() & '_examples.md', edit=args.edit)#
	</cfif>
	<cfif Len( Trim( local.fn.getExamples() ) )>
		#markdownToHtml( local.fn.getExamples() )#
	<cfelse>
		<em>There are currently no examples for this function</em>
	</cfif>
</cfoutput>
