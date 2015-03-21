<cfparam name="args.page" type="page" />

<cfset fn = args.page />

<cfoutput>
	<h1>#fn.getTitle()#</h1>

	#markdownToHtml( fn.getBody() )#

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

	<h2>Examples</h2>
	<cfif Len( Trim( fn.getExamples() ) )>
		#markdownToHtml( fn.getExamples() )#
	<cfelse>
		<em>There are currently no examples for this function</em>
	</cfif>
</cfoutput>