<cfparam name="args.pageLineage" type="array" />
<cfparam name="args.crumbs"      type="array" />
<cfparam name="args.docTree"     type="any" />

<cfoutput>
	<div class="navigation-container">
		<ol class="sidebar-nav" role="navigation">
			<cfloop array="#args.docTree.getTree()#" item="firstLevelPage" index="i">
				<cfif firstLevelPage.getId() neq "/home">
					<cfset firstLevelActive = args.pageLineage.find( firstLevelPage.getId() ) />
					<li<cfif firstLevelActive> class="active"</cfif>>

						[[#firstLevelPage.getId()#]]

						<cfif firstLevelActive and firstLevelPage.getChildren().len()>
							<ol role="navigation">
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
	</div>
</cfoutput>