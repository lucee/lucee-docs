<cfparam name="args.crumbs"  type="array" />
<cfparam name="args.docTree" type="any" />

<cfoutput>
	<ol class="list-unstyled sidebar-nav" role="navigation">
		<cfloop array="#args.docTree.getTree()#" item="firstLevelPage" index="i">
			<cfif firstLevelPage.getId() neq "/home">
				<li>
					<h2>{{ref:#firstLevelPage.getId()#}}</h2>

					<cfif firstLevelPage.getChildren().len()>
						<ol class="list-unstyled" role="navigation">
							<cfloop array="#firstLevelPage.getChildren()#" item="secondLevelPage" index="n">
								<li>{{ref:#secondLevelPage.getId()#}}</li>
							</cfloop>
						</ol>
					</cfif>
				</li>
			</cfif>
		</cfloop>
	</ol>
</cfoutput>