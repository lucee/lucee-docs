<cfif ( args.links ?: [] ).len()>
	<cfoutput>
		<h4>See also</h4>
		<ul class="list-unstyled">
			<cfloop array="#args.links#" index="local.i" item="local.link">
				<li>#local.link#</li>
			</cfloop>
		</ul>
	</cfoutput>
</cfif>