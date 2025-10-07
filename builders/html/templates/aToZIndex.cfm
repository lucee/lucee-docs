<cfset local.args = arguments.args>
<cfparam name="args.page" type="page" />

<cfscript>
	local.pg = args.page;
	local.currentLetter = "";
</cfscript>

<cfoutput>
	#getEditLink(path=local.pg.getSourceFile(), edit=args.edit)#
	#_markdownToHtml( local.pg.getBody() )#
	<cfif ArrayLen(local.pg.getChildren()) lt 50 or local.pg.getListingStyle() eq "flat">
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
		<!--- Build quick nav for available letters --->
		<cfset local.availableLetters = [] />
		<cfloop array="#local.pg.getChildren()#" index="local.child">
			<cfset local.letter = UCase( local.child.getSlug()[1] ) />
			<cfif !ArrayContains( local.availableLetters, local.letter )>
				<cfset ArrayAppend( local.availableLetters, local.letter ) />
			</cfif>
		</cfloop>

		<div class="tile-toolbar">
			<button class="btn expand-a-z" data-expanded="true">Collapse All</button>
			<div style="margin-top: 10px;">
				<strong>Jump to:</strong>
				<cfloop array="#local.availableLetters#" index="local.letter">
					<a href="#local.pg.getPath()#.html##function-#LCase( local.letter )#" style="margin: 0 5px;">#local.letter#</a>
				</cfloop>
			</div>
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
					<div class="tile tile-collapse tile-collapse-full" id="function-#LCase( local.firstLetter )#">
						<div class="tile-toggle" data-target="##function-#LCase( local.firstLetter )#-content" data-toggle="tile">
							<div class="tile-inner">
								<div class="text-overflow"><strong>#UCase( local.firstLetter )#</strong></div>
							</div>
						</div>
						<div class="tile-active-show collapse in" id="function-#LCase( local.firstLetter )#-content">
				</cfif>

				<span class="tile">
					<div class="tile-inner">
						<div class="text-overflow">
							<span translate="no">[[#htmleditformat(local.child.getId())#]]</span>
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