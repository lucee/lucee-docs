<cfparam name="args.page" type="page" />

<cfset meth = args.page />
<cfset argumentsHaveDefaultValues = meth.argumentsHaveDefaultValues() />
<cfoutput>
	#getEditLink(path=meth.getSourceFile(), edit=args.edit)#
	#markdownToHtml( meth.getBody() )#

    <p><strong>Returns:</strong> #meth.getReturnType()#</p>	
	<cfif len(meth.getIntroduced()) gt 0>
		<p><strong>Introduced:</strong> #meth.getIntroduced()#</p>	
	</cfif>

    <h2>Arguments</h2>
	<cfif !meth.getArguments().len()>
		<cfif meth.getArgumentType() == "dynamic">
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
					<cfloop array="#meth.getArguments()#" item="arg" index="i">
						<tr>
							<td><div class="argument">#arg.name#</div>
								<sub>(#arg.type#, #( arg.required ? 'required' : 'optional' )#)</sub>
							</td>
							<td>
								#getEditLink(path=meth.getSourceDir() & '_arguments/#arg.name#.md', edit=args.edit)#
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
#meth.getUsageSignature()#
```
	<h2>Examples</h2>
	<cfif Len( Trim( meth.getExamples() ) ) or args.edit>
		#getEditLink(path=meth.getSourceDir() & '_examples.md', edit=args.edit)#
	</cfif>
	<cfif Len( Trim( meth.getExamples() ) )>
		#markdownToHtml( meth.getExamples() )#
	<cfelse>
		<em>There are currently no examples for this function</em>
	</cfif>
</cfoutput>

