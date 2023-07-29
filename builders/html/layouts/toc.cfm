<cfscript>
	args.tocItems     = args.tocItems ?: [];
	args.currentLevel = 1;
	args.tocItem      = "";
	args.tocIndex     = "";
</cfscript>

<cffunction name="renderTocItems">
	<cfargument name="items" type="array"   required="true" />
	<cfargument name="level" type="numeric" required="false" default="1" />

	<cfset var rendered = "">
	<cfset var tocItem  = "">
	<cfset var tocIndex = "">

	<cfsavecontent variable="rendered">
		<cfoutput>
			<cfloop array="#arguments.items#" item="tocItem" index="tocIndex">
				<li>
					<a href="###tocItem.slug#">#tocItem.title#</a>
					<cfif tocItem.children.len()>
						<ul class="toc-list toc-list-level-#(arguments.level+1)#">
							#renderTocItems( tocItem.children, arguments.level+1 )#
						</ul>
					</cfif>
				</li>
			</cfloop>
		</cfoutput>
	</cfsavecontent>

	<cfreturn rendered />
</cffunction>

<cfoutput>
	<nav class="toc-navigation">
		<h2 class="toc-navigation-title">Table of contents</h2>
		<ul class="toc-list toc-list-level-1">
			#renderTocItems( args.tocItems )#
		</ul>
	</nav>
</cfoutput>