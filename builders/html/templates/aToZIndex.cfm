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
		<div style="margin-bottom: 15px;">
			<input type="text" id="az-filter" class="form-control" placeholder="Filter..." style="max-width: 300px;">
		</div>
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
		<!--- Sort children case-insensitively by slug --->
		<cfset local.sortedChildren = local.pg.getChildren() />
		<cfset ArraySort( local.sortedChildren, function(a, b) {
			return Compare( LCase(a.getSlug()), LCase(b.getSlug()) );
		}) />

		<!--- Build quick nav for available letters --->
		<cfset local.availableLetters = [] />
		<cfloop array="#local.sortedChildren#" index="local.child">
			<cfset local.letter = UCase( local.child.getSlug()[1] ) />
			<cfif !ArrayContains( local.availableLetters, local.letter )>
				<cfset ArrayAppend( local.availableLetters, local.letter ) />
			</cfif>
		</cfloop>

		<div class="tile-toolbar">
			<div style="display: flex; gap: 10px; align-items: center; justify-content: space-between; margin-bottom: 10px;">
				<input type="text" id="az-filter" class="form-control" placeholder="Filter..." style="max-width: 300px;">
				<button class="btn expand-a-z" data-expanded="true" data-collapse-text="Collapse All" data-expand-text="Expand All">Collapse All</button>
			</div>
			<div style="padding-bottom: 15px; border-bottom: 1px solid var(--text-hint); margin-bottom: 20px;">
				<strong>Jump to:</strong>
				<cfloop array="#local.availableLetters#" index="local.letter">
					<a href="#local.pg.getPath()#.html##function-#LCase( local.letter )#" style="margin: 0 5px;">#local.letter#</a>
				</cfloop>
			</div>
		</div>
		<div class="tile-wrap <!---tile-wrap-animation--->">
			<cfloop array="#local.sortedChildren#" index="local.i" item="local.child">
				<cfset local.slug = local.child.getSlug() />
				<cfset local.firstLetter = UCase( local.slug[1] ) />
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