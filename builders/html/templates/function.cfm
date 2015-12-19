<cfparam name="args.page" type="page" />

<cfset fn = args.page />

<cfoutput>
	<a class="pull-right" href="#getSourceLink( path=fn.getSourceFile() )#" title="Improve the docs"><i class="fa fa-pencil fa-fw"></i></a>
	#markdownToHtml( fn.getBody() )#

	<p><strong>Returns:</strong> #fn.getReturnType()#</p>

	<h2>Usage</h2>
```luceescript
#fn.getUsageSignature()#
```

	<h2>Arguments</h2>
	<cfif !fn.getArguments().len()>
		<cfif fn.getArgumentType() == "dynamic">
			<p><em>This function takes zero or more dynamic arguments. See examples for details.</em></p>
		<cfelse>
			<p><em>This function does not take any arguments.</em></p>
		</cfif>
	<cfelse>
<cfscript>
		// do we have default values?
		hasDefaultValue=false;
		loop array=fn.getArguments() item="arg" {
			if(!isNull(arg.default))
				hasDefaultValue=true;
		}
</cfscript>
		<div class="table-responsive">
			<table class="table" title="Arguments">
				<thead>
					<tr>
						<th>Argument</th>
						<th>Description</th>
						<cfif hasDefaultValue><th>Default</th></cfif>
					</tr>
				</thead>
				<tbody>
					<cfloop array="#fn.getArguments()#" item="arg" index="i">
						<tr>
							<td>
								#arg.name#<br>
								<sub>(#arg.type#, #( arg.required ? 'required' : 'optional' )#)</sub>
							</td>
							<td>
								<a class="pull-right" href="#getSourceLink( path=fn.getSourceDir() & '_arguments/#arg.name#.md' )#" title="Improve the docs"><i class="fa fa-pencil fa-fw"></i></a>
								#markdownToHtml( Trim( arg.description ) )#
							</td>
							<cfif hasDefaultValue>
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

	<h2>Examples</h2>
	<cfif Len( Trim( fn.getExamples() ) )>
		<a class="pull-right" href="#getSourceLink( path=fn.getSourceDir() & '_examples.md' )#" title="Improve the docs"><i class="fa fa-pencil fa-fw"></i></a>
		#markdownToHtml( fn.getExamples() )#
	<cfelse>
		<em>There are currently no examples for this function</em>
	</cfif>
</cfoutput>