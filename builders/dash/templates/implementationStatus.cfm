<cfset local.args = arguments.args>
<cfparam name="args.page" type="page" />

<cfscript>
	local.pg = args.page;	
	local.status = arguments.args.docTree.getReferenceByStatus(arguments.args.page.getStatusFilter());
</cfscript>

<cfoutput>
	#markdownToHtml( local.pg.getBody() )#

	<cfif StructCount(local.status.function) gt 0>
		<div class="tile-wrap">
			<h4>Functions</h4>
			<cfloop collection="#local.status.function#" index="local.i" item="local.child">
				<span class="tile">
					<div class="tile-inner">
						<div class="text-overflow">[[#local.child.getId()#]] #htmleditformat(local.child.getDescription())#</div>
					</div>
				</span>
			</cfloop>
		</div>
	</cfif>

	<cfif StructCount(local.status.tag) gt 0>
		<div class="tile-wrap">
			<h4>Tags</h4>
			<cfloop collection="#local.status.tag#" index="local.i" item="local.child">
				<span class="tile">
					<div class="tile-inner">
						<div class="text-overflow">[[#local.child.getId()#]] #htmleditformat(local.child.getDescription())#</div>
					</div>
				</span>
			</cfloop>
		</div>
	</cfif>
</cfoutput>