<cfparam name="args.page" type="page" />

<cfset pg = args.page />
<cfset currentLetter = "" />

<cfoutput>
	#markdownToHtml( pg.getBody() )#

	<div class="row">
		<cfloop array="#pg.getChildren()#" index="i" item="child">
			<cfset slug = child.getSlug() />
			<cfset firstLetter = slug[1] />
			<cfif firstLetter != currentLetter>
			<cfif currentLetter.len()>
					</ul>
				</div>
			</cfif>
			<div class="col-md-4">
				<h3 id="letter-index-#firstLetter#">#firstLetter#</h3>
				<ul class="list-unstyled">
			</cfif>

			<li>[[#child.getId()#]]</li>

			<cfset currentLetter = firstLetter />
		</cfloop>

			</ul>
		</div>
	</div>
</cfoutput>