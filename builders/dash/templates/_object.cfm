<cfparam name="args.page" type="page" />

<cfset local.pg = args.page />
<cfoutput>
	
	#getEditLink(path=local.pg.getSourceFile(), edit=args.edit)#
	<p>
	<cfif local.pg.getBody().len() gt 0>
		#markdownToHtml( local.pg.getBody())#
	<cfelse>
		#markdownToHtml("Object")#
	</cfif>
	</p>
	
	<div class="tile-wrap">
		<cfloop array="#local.pg.getChildren()#" item="local.child">
			<span class="tile">
				<div class="tile-inner">
					<div class="text-overflow">[[#local.child.getId()#]] #htmleditformat(local.child.getDescription())#</div>
				</div>
			</span>
		</cfloop>
	</div>
</cfoutput>