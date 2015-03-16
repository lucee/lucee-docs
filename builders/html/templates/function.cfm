<cfparam name="args.page" type="page" />

<cfset fn = args.page />

<cfoutput>
	<h1>#fn.getName()#</h1>
	#markdownToHtml( fn.getDescription() )#
	<p><strong>Returns:</strong> #fn.getReturnType()#</p>

	<h2>Usage</h2>
	{{highlight:java}}#fn.getUsageSignature()#{{highlight}}

	<h2>Arguments</h2>
	<cfif !fn.getArguments().len()>
		<p><em>This function does not take any arguments.</em></p>
	<cfelse>
		<dl class="dl-horizontal">
			<cfloop array="#fn.getArguments()#" item="arg" index="i">
				<dt>
					#arg.name#<br>
					<aside class="light">(#arg.type#, #( arg.required ? 'required' : 'optional' )#)</aside>
				</dt>
				<dd>
					#markdownToHtml( arg.description )#
				</dd>
			</cfloop>
		</dl>
	</cfif>

	<cfif fn.getExamples().len()>
		<h2>Examples</h2>
		<!--- TODO --->
	</cfif>
</cfoutput>