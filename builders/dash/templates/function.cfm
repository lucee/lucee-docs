<cfset local.args = arguments.args><!--- scope hack --->
<cfparam name="args.page" type="page" />

<cfset local.fn = args.page />
<cfset local.argumentsHaveDefaultValues = local.fn.argumentsHaveDefaultValues() />

<cfoutput>
	#getEditLink(path=local.fn.getSourceFile(), edit=args.edit)#
	#markdownToHtml( local.fn.getBody() )#

	<p><strong>Returns:</strong> #local.fn.getReturnType()#</p>
	<cfif len(local.fn.getAlias()) gt 0>
		<p><strong>Alias:</strong> #local.fn.getAlias()#</p>
	</cfif>
	<cfif len(local.fn.getIntroduced()) gt 0>
		<p><strong>Introduced:</strong> #local.fn.getIntroduced()#</p>
	</cfif>

	<h2>Arguments</h2>
	<cfif !local.fn.getArguments().len()>
		<cfif local.fn.getArgumentType() == "dynamic">
			<p><em>This function takes zero or more dynamic arguments. See examples for details.</em></p>
		<cfelse>
		<p><em>This function does not take any arguments.</em></p>
		</cfif>
	<cfelse>
		<div class="table-responsive">
			<table class="table" title="Arguments">
				<thead>
					<tr>
						<th>Argument</th>
						<th>Description</th>
						<cfif local.argumentsHaveDefaultValues><th>Default</th></cfif>
					</tr>
				</thead>
				<tbody>
					<cfloop array="#local.fn.getArguments()#" item="local.arg" index="local.i">
						<tr>
							<td><div class="argument">#local.arg.name#</div>
								<sub>(#local.arg.type#, #( local.arg.required ? 'required' : 'optional' )#)</sub>
							</td>
							<td>
								#getEditLink(path=local.fn.getSourceDir() & '_arguments/#local.arg.name#.md', edit=args.edit)#
								#markdownToHtml( Trim( local.arg.description ) )#
								<cfif len(local.arg.alias) gt 0>
									<p title="for compatibility, this argument has the following alias(es)">
										<sub>Alias:</strong> #ListChangeDelims(local.arg.alias,", ",",")#</sub>
									</p>
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
		</div>
	</cfif>

	<h2>Usage</h2>
```luceescript
#local.fn.getUsageSignature()#
```
	<h2>Examples</h2>
	<cfif Len( Trim( local.fn.getExamples() ) ) or args.edit>
		#getEditLink(path=local.fn.getSourceDir() & '_examples.md', edit=args.edit)#
	</cfif>
	<cfif Len( Trim( local.fn.getExamples() ) )>
		#markdownToHtml( local.fn.getExamples() )#
	<cfelse>
		<em>There are currently no examples for this function</em>
	</cfif>
</cfoutput>