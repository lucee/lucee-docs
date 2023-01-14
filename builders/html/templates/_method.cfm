<cfparam name="arguments.args.page" type="page" />
<cfset local.args = arguments.args>

<cfset local.meth = args.page />
<cfset local.argumentsHaveDefaultValues = local.meth.argumentsHaveDefaultValues() />
<cfoutput>
	#getEditLink(path=local.meth.getSourceFile(), edit=args.edit)#
	#markdownToHtml( local.meth.getBody() )#


	<cfif len(local.meth.getIntroduced()) gt 0>
		<p><strong>Introduced:</strong> #local.meth.getIntroduced()#</p>
	</cfif>
	<code>
		#local.meth.getUsageSignature()#
	</code>

<p>Returns:</strong> #local.meth.getReturnTypeLink()#</p>

	<cfif !local.meth.getArguments().len()>
		<cfif local.meth.getArgumentType() == "dynamic">
			<p><em>This function takes zero or more dynamic arguments. See examples for details.</em></p>
		<cfelse>
			<p><em>This function does not take any arguments.</em></p>
		</cfif>
	<cfelse>
		<div class="table-responsive">
			<table class="table arguments" title="Arguments">
				<thead>
					<tr>
						<th>Argument</th>
						<th>Description</th>
						<cfif local.argumentsHaveDefaultValues><th>Default</th></cfif>
					</tr>
				</thead>
				<tbody>
					<cfloop array="#local.meth.getArguments()#" item="local.arg" index="local.i">
						<cfif local.arg.status eq "hidden">
							<cfcontinue>
						</cfif>
						<tr>
							<td>
								<div class="argument" id="argument-#local.arg.name#" title="Argument name" translate="no">
									#local.arg.name#
								</div>
								<sub title="Argument type">
									<span translate="no">#local.arg.type#</span>,
									<span title="Is this argument required">
										#( local.arg.required ? 'required' : 'optional' )#
									</span>
								</sub>
							</td>
							<td>
								#getEditLink(path=local.meth.getSourceDir() & '_arguments/#local.arg.name#.md', edit=args.edit)#
								#markdownToHtml( Trim( arg.description ) )#
								<cfif local.arg.keyExists("alias") and len(local.arg.alias) gt 0>
									<p title="for compatibility, this argument has the following alias(es)"><sub>Alias:</strong> #ListChangeDelims(local.arg.alias,", ",",")#</sub></p>
								</cfif>
								#showOriginalDescription(props=local.arg, edit=args.edit, markdownToHtml=markdownToHtml)#
							</td>
							<cfif local.argumentsHaveDefaultValues>
 								<td translate="no">
 									#markdownToHtml( local.arg.default ?: "" )#
 								</td>
 							</cfif>
						</tr>
					</cfloop>
				</tbody>
			</table>
		</div>
	</cfif>

	<h4>Examples</h4>
	<cfif Len( Trim( local.meth.getExamples() ) ) or args.edit>
		#getEditLink(path=local.meth.getSourceDir() & '_examples.md', edit=args.edit)#
	</cfif>
	<cfif Len( Trim( local.meth.getExamples() ) )>
		#markdownToHtml( local.meth.getExamples() )#
	<cfelse>
		<em>There are currently no examples for this function</em>
	</cfif>
</cfoutput>

