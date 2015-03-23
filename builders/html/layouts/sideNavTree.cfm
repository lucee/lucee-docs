<cfparam name="args.pageLineage" type="array" />
<cfparam name="args.crumbs"      type="array" />
<cfparam name="args.docTree"     type="any" />

<cfoutput>
	<ol class="list-unstyled sidebar-nav" role="navigation">
		<cfloop array="#args.docTree.getTree()#" item="firstLevelPage" index="i">
			<cfif firstLevelPage.getId() neq "/home">
				<cfset firstLevelActive = args.pageLineage.find( firstLevelPage.getId() ) />
				<li<cfif firstLevelActive> class="active"</cfif>>

					<h2>[[#firstLevelPage.getId()#]]</h2>

					<cfif firstLevelPage.getChildren().len()>
						<ol class="list-unstyled" role="navigation">
							<cfloop array="#firstLevelPage.getChildren()#" item="secondLevelPage" index="n">
								<cfset secondLevelActive = args.pageLineage.find( secondLevelPage.getId() ) />
								<li<cfif secondLevelActive> class="active"</cfif>>[[#secondLevelPage.getId()#]]</li>
							</cfloop>
						</ol>
					</cfif>
				</li>
			</cfif>
		</cfloop>
	</ol>
</cfoutput>