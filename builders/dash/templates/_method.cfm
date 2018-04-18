<cfparam name="args.page" type="page" />

<cfset local.meth = args.page />
<cfset local.argumentsHaveDefaultValues = local.meth.argumentsHaveDefaultValues() />
<cfoutput>
	#getEditLink(path=local.meth.getSourceFile(), edit=args.edit)#
	#markdownToHtml( local.meth.getBody() )#

    <p><strong>Returns:</strong> #local.meth.getReturnType()#</p>
	<cfif len(local.meth.getIntroduced()) gt 0>
		<p><strong>Introduced:</strong> #local.meth.getIntroduced()#</p>
	</cfif>

    <h2>Arguments</h2>
	<cfif !local.meth.getArguments().len()>
		<cfif local.meth.getArgumentType() == "dynamic">
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
					<cfloop array="#local.meth.getArguments()#" item="local.arg" index="local.i">
						<tr>
							<td><div class="argument">#local.arg.name#</div>
								<sub>(#local.arg.type#, #( local.arg.required ? 'required' : 'optional' )#)</sub>
							</td>
							<td>
								#getEditLink(path=local.meth.getSourceDir() & '_arguments/#local.arg.name#.md', edit=args.edit)#
								#markdownToHtml( Trim( arg.description ) )#
								<cfif len(local.arg.alias) gt 0>
									<p title="for compatability, this argument has the following alias(es)">
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
#local.meth.getUsageSignature()#
```
	<h2>Examples</h2>
	<cfif Len( Trim( local.meth.getExamples() ) ) or args.edit>
		#getEditLink(path=local.meth.getSourceDir() & '_examples.md', edit=args.edit)#
	</cfif>
	<cfif Len( Trim( local.meth.getExamples() ) )>
		#markdownToHtml( local.meth.getExamples() )#
	<cfelse>
		<em>There are currently no examples for this function</em>
	</cfif>
</cfoutput>

