<cfparam name="args.page"    type="page" />
<cfparam name="args.docTree" type="any" />

<cfscript>
	local.args = arguments.args;
	local.changeLog = args.page;
	pc = args.docTree.getPageCache().getPages();
	checklist= {
		function: true,
		tag: true
	};
	q = QueryNew("type,ref,name,introduced,sort,description");

	function addChangeLog(q, page, ref, name, introduced, description){
		var r = queryAddRow(q);
		querySetCell(q,"type", arguments.page.getPageType());
		querySetCell(q,"ref", arguments.ref);
		querySetCell(q,"name", arguments.name);
		querySetCell(q,"introduced", arguments.introduced);

		var sort=[];
		var intro = [];
		loop list="#arguments.introduced#" delimiters="." item="local.v" {
			if (v eq "000") v = 0;
			arrayAppend(sort, numberFormat(v, "0000"));
			arrayAppend(intro, v);
		}
		querySetCell(q,"introduced", intro.toList("."));
		querySetCell(q,"sort", sort.toList(""));
		querySetCell(q,"description", arguments.description);
	}
</cfscript>

<cfloop collection="#pc#" key="key" value="value">
	<cfif structKeyExists(checklist, value.page.getPageType())>
		<cfset changed = false>
		<cfif len(value.page.getIntroduced()) gt 0>
			<cfscript>
				addChangeLog(q, value.page, key, value.page.getTitle(), value.page.getIntroduced(), "");
			</cfscript>
		<cfelseif value.page.getPageType() eq "tag">
			<!--- check attributes --->
			<cfset tagAttr = value.page.getAttributes()>
			<cfif false>
				<Cfdump var=#value.page#><cfabort>
			</cfif>
			<cfif isArray(tagAttr)>
				<cfset newArgs = []>
				<cfloop array="#tagAttr#" item="attr">
					<cfif len(attr.introduced?:"")>
						<cfscript>
							addChangeLog(q, value.page, key, value.page.getName(), attr.introduced,
								'&lt;cf#value.page.getName()# #attr.name#="#attr.type#"&gt;'
							);
						</cfscript>
					</cfif>
				</cfloop>
			</cfif>
		<cfelseif value.page.getPageType() eq "function">
			<!--- check arguments --->
			<cfset funcArg = value.page.getArguments()>

			<cfif isArray(funcArg)>
				<cfset newArgs = []>
				<cfloop array="#funcArg#" item="arg">
					<cfif len(arg.introduced?:"")>
						<cfscript>
							addChangeLog(q, value.page, key, value.page.getName(), arg.introduced,
								'#listFirst(value.page.getTitle(),"()")#( #arg.name#="#arg.type#")'
							);
						</cfscript>
					</cfif>
				</cfloop>
			</cfif>
		</cfif>
</cfif>
</cfloop>

<cfquery name="q" dbtype="query">
	select * from q order by sort
</cfquery>

<cfoutput>

	#getEditLink(path=local.changeLog.getSourceFile(), edit=args.edit)#
	#markdownToHtml( local.changeLog.getBody() )#
</cfoutput>

<ul>
<cfoutput query=q group="introduced">
	<li>
		#q.introduced#
		<ul>
		<cfoutput>
			<li>
				<a href="#q.ref#.html">
				<cfif len(q.description)>
					#q.description#
				<cfelse>
					#htmlEditFormat(q.name)#
				</cfif>
				</a>
			</li>
		</cfoutput>
		</ul>
	</li>
</cfoutput>
</ul>
