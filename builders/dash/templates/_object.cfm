<cfparam name="args.page" type="page" />

<cfset pg = args.page />
<cfoutput>
	
	#getEditLink(path=pg.getSourceFile(), edit=args.edit)#
	<p>
	<cfif pg.getBody().len() gt 0>
		#markdownToHtml( pg.getBody())#
	<cfelse>
		#markdownToHtml("Object")#
	</cfif>
	
	</p>
	
	<div class="tile-wrap">
		<cfloop array="#pg.getChildren()#" index="i" item="child">
			<span class="tile">
				<div class="tile-inner">
					<div class="text-overflow">[[#child.getId()#]] #htmleditformat(child.getDescription())#</div>					
				</div>
			</span>
		</cfloop>
	</div>
</cfoutput>