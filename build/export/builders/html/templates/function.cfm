<cfparam name="args.luceeFunction" type="LuceeFunction" />

<cfoutput>
	<h1>#args.luceeFunction.getName()#</h1>
	<blockquote>#args.luceeFunction.getDescription()#</blockquote>
</cfoutput>