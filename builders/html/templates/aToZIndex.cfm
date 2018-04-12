<cfparam name="args.page" type="page" />

<cfscript>
	local.pg = args.page;
	local.currentLetter = "";
</cfscript>

<cfoutput>
	#getEditLink(path=local.pg.getSourceFile(), edit=args.edit)#
	#markdownToHtml( local.pg.getBody() )#

	<cfif ArrayLen(local.pg.getChildren()) lt 50>
		<div class="tile-wrap">
			<cfloop array="#local.pg.getChildren()#" index="local.i" item="local.child">
				<span class="tile">
					<div class="tile-inner">
						<div class="text-overflow">[[#local.child.getId()#]] #htmleditformat(local.child.getDescription())#</div>
					</div>
				</span>
			</cfloop>
		</div>
	<cfelse>
		<div class="tile-toolbar">
			<button class="btn expand-a-z" data-expanded="false">Expand All</button>
		</div>
		<div class="tile-wrap <!---tile-wrap-animation--->">
			<cfloop array="#local.pg.getChildren()#" index="local.i" item="local.child">
				<cfset local.slug = local.child.getSlug() />
				<cfset local.firstLetter = local.slug[1] />
				<cfif local.firstLetter != local.currentLetter>
					<cfif local.currentLetter.len()>
							</div>
						</div>
					</cfif>
					<div class="tile tile-collapse tile-collapse-full">
						<div class="tile-toggle" data-target="##function-#LCase( local.firstLetter )#" data-toggle="tile">
							<div class="tile-inner">
								<div class="text-overflow"><strong>#UCase( local.firstLetter )#</strong></div>
							</div>
						</div>
						<div class="tile-active-show collapse" id="function-#LCase( local.firstLetter )#">
				</cfif>

				<span class="tile">
					<div class="tile-inner">
						<div class="text-overflow">
							[[#htmleditformat(local.child.getId())#]]
							#htmleditformat( getMetaDescription(local.child, local.child.getBody()) )#
						</div>
					</div>
				</span>
				<cfset local.currentLetter = local.firstLetter />
			</cfloop>
				</div>
			</div>
		</div>
	</cfif>
</cfoutput>