<cfparam name="args.page" type="page" />

<cfset fn = args.page />
<cfset argumentsHaveDefaultValues = fn.argumentsHaveDefaultValues() />

<cfoutput>
	#getEditLink(path=fn.getSourceFile(), edit=args.edit)#
	#markdownToHtml( fn.getBody() )#

	<p><strong>Returns:</strong> #fn.getReturnType()#</p>

	<h2>Arguments</h2>
	<cfif !fn.getArguments().len()>
		<cfif fn.getArgumentType() == "dynamic">
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
						<cfif argumentsHaveDefaultValues><th>Default</th></cfif>
					</tr>
				</thead>
				<tbody>
					<cfloop array="#fn.getArguments()#" item="arg" index="i">
						<tr>
							<td><div class="argument">#arg.name#</div>
								<sub>(#arg.type#, #( arg.required ? 'required' : 'optional' )#)</sub>
							</td>
							<td>
								#getEditLink(path=fn.getSourceDir() & '_arguments/#arg.name#.md', edit=args.edit)#
								#markdownToHtml( Trim( arg.description ) )#
							</td>
							<cfif argumentsHaveDefaultValues>
 								<td>
 									#markdownToHtml( arg.default ?: "" )#
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
#fn.getUsageSignature()#
```
	<h2>Examples</h2>
	<cfif Len( Trim( fn.getExamples() ) ) or args.edit>
		#getEditLink(path=fn.getSourceDir() & & '_examples.md', edit=args.edit)#
	</cfif>
	<cfif Len( Trim( fn.getExamples() ) )>
		#markdownToHtml( fn.getExamples() )#
	<cfelse>
		<em>There are currently no examples for this function</em>
	</cfif>
</cfoutput>