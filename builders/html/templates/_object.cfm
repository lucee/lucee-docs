<cfset local.args = arguments.args>
<cfparam name="args.page" type="page" />

<cfset local.pg = args.page />
<cfoutput>

	#getEditLink(path=local.pg.getSourceFile(), edit=args.edit)#
	<p>
	<cfif local.pg.getBody().len() gt 0>
		#_markdownToHtml( local.pg.getBody())#
	<cfelse>
		#_markdownToHtml("Object")#
	</cfif>
	</p>

	<div class="tile-wrap">
		<cfloop array="#local.pg.getChildren()#" item="local.child">
			<span class="tile">
				<div class="tile-inner">
					<div class="word-wrap">[[#local.child.getId()#]] #htmleditformat(local.child.getDescription())#</div>
				</div>
			</span>
		</cfloop>
	</div>
</cfoutput>