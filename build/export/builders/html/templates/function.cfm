<cfparam name="args.luceeFunction" type="LuceeFunction" />

<cfset fn = args.luceeFunction />

<cfoutput>
	<ol class="breadcrumb">
		<li><a href="">home</a></li>
		<li><a href="functions.html">functions</a></li>
		<li class="active">#fn.getName()#</li>
	</ol>
	<h1>#fn.getName()#</h1>
	#markdownToHtml( fn.getDescription() )#
	<p><strong>Returns:</strong> #fn.getReturnType()#</p>

	<h2>Usage</h2>
	<pre class="signature"><code>#fn.getUsageSignature()#</code></pre>


	<h2>Arguments</h2>
	<cfif !fn.getArguments().len()>
		<p><em>This function does not take any arguments.</em></p>
	<cfelse>
		<dl class="dl-horizontal">
			<cfloop array="#fn.getArguments()#" item="arg" index="i">
				<dt>#arg.name#</dt>
				<dd>
					<aside class="light">(#arg.type#, #( arg.required ? 'required' : 'optional' )#)</aside>
					#markdownToHtml( arg.description )#
				</dd>
			</cfloop>
		</dl>
	</cfif>

	<h2>Examples</h2>
	<cfif !fn.getExamples().len()>
		<p><em>There are no examples for this function</em></p>
	<cfelse>

	</cfif>
</cfoutput>