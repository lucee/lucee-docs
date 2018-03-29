<cfparam name="args.page" type="page" />

<cfscript>
	pg = args.page;
	currentLetter = "";
</cfscript>

<cfoutput>
	#getEditLink(path=pg.getSourceFile(), edit=args.edit)#
	#markdownToHtml( pg.getBody() )#

	<cfif ArrayLen(pg.getChildren()) lt 50>
		<div class="tile-wrap">
			<cfloop array="#pg.getChildren()#" index="i" item="child">
				<span class="tile">
					<div class="tile-inner">
						<div class="text-overflow">[[#child.getId()#]] #htmleditformat(child.getDescription())#</div>
					</div>
				</span>
			</cfloop>
		</div>
	<cfelse>
		<div class="tile-wrap <!---tile-wrap-animation--->">
			<cfloop array="#pg.getChildren()#" index="i" item="child">
				<cfset slug = child.getSlug() />
				<cfset firstLetter = slug[1] />
				<cfif firstLetter != currentLetter>
					<cfif currentLetter.len()>
							</div>
						</div>
					</cfif>
					<div class="tile tile-collapse tile-collapse-full">
						<div class="tile-toggle" data-target="##function-#LCase( firstLetter )#" data-toggle="tile">
							<div class="tile-inner">
								<div class="text-overflow"><strong>#UCase( firstLetter )#</strong></div>
							</div>
						</div>
						<div class="tile-active-show collapse" id="function-#LCase( firstLetter )#">
				</cfif>

				<span class="tile">
					<div class="tile-inner">
						<div class="text-overflow">[[#htmleditformat(child.getId())#]] #htmleditformat(child.getDescription())#</div>
					</div>
				</span>
				<cfset currentLetter = firstLetter />
			</cfloop>
				</div>
			</div>
		</div>
	</cfif>
</cfoutput>