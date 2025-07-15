<cfparam name="arguments.args.pageLineage" type="array" />
<cfparam name="arguments.args.pageLineageMap" type="struct" />
<cfparam name="arguments.args.crumbs"      type="array" />
<cfparam name="arguments.args.docTree"     type="any" />



<cfoutput>
	<ul class="nav" itemscope itemtype="http://www.schema.org/SiteNavigationElement">
		<cfloop array="#arguments.args.docTree.getTree()#" item="local.firstLevelPage" index="local.i">
			<cfif local.firstLevelPage.getVisible() && local.firstLevelPage.getId() neq "/home">
				<cfscript>
					local.firstId = local.firstLevelPage.getId();
					local.firstLevelActive  = arguments.args.pageLineageMap.keyExists( local.firstId );
					local.firstLevelCurrent = (arguments.args.pageLineage[ arguments.args.pageLineage.len() ] === local.firstId);
					local.item = arguments.args.doctree.getPage(firstId);
				</cfscript>
				<li class="<cfif local.firstLevelActive>active</cfif> <cfif local.firstLevelCurrent>current</cfif>">
					<a href="#local.item.getPath()#.html" itemprop="url">
						<span itemprop="name">#HtmlEditFormat(local.item.getPageMenuTitle())#</span>
					</a>
					<cfsilent>
						<cfscript>
							local.subIsOpen = local.firstLevelActive;
							local.subnav = [];
							local.children = local.firstLevelPage.getChildren();
							for ( local.secondLevelPage in local.children ) {
								if ( local.secondLevelPage.getVisible() ) {
									local.secondLevelActive = arguments.args.pageLineageMap.keyExists( local.secondLevelPage.getId() );
									if (local.secondLevelActive eq true)
										local.subIsOpen = true;
									local.item = arguments.args.doctree.getPage(local.secondLevelPage.getId());
									subNav.append('<li' &
										(local.secondlevelactive eq true ? ' class="active"' : "") &
										'><a href="#local.item.getPath()#.html" itemprop="url">' &
										'<span itemprop="name">#HtmlEditFormat(local.item.getPageMenuTitle())#</span>' &
										'</a></li>'
									);
								}
							}
						</cfscript>
					</cfsilent>
					<cfif local.subnav.len()>
						<span class="menu-collapse-toggle <cfif !local.subIsOpen>collapsed</cfif>" data-target="###local.firstId#" data-toggle="collapse" aria-expanded="#local.subIsOpen#">
							<i class="icon icon-close menu-collapse-toggle-close"></i>
							<i class="icon icon-add menu-collapse-toggle-default"></i>
						</span>
						<ul class="menu-collapse <cfif local.subIsOpen>expand collapse in<cfelse>collapse</cfif>" id="#local.firstId#"
							itemscope itemtype="http://www.schema.org/SiteNavigationElement">
							#local.subnav.toList(chr(10))#
						</ul>
					</cfif>
				</li>
			</cfif>
		</cfloop>
	</ul>
</cfoutput>
