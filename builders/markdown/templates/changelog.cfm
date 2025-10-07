<cfscript>
	param name="args.page" type="page";
	param name="args.docTree" type="any";

	local.args = arguments.args;
	local.changeLog = args.page;
	pc = args.docTree.getPageCache().getPages();
	checklist = {
		function: true,
		tag: true
	};
	q = QueryNew( "type,ref,name,introduced,sort,description" );

	function addChangeLog( q, page, ref, name, introduced, description ){
		var r = queryAddRow( q );
		querySetCell( q, "type", arguments.page.getPageType() );
		querySetCell( q, "ref", arguments.ref );
		querySetCell( q, "name", arguments.name );
		querySetCell( q, "introduced", arguments.introduced );

		var sort = [];
		var intro = [];
		loop list="#arguments.introduced#" delimiters="." item="local.v" {
			if ( v eq "000" ) v = 0;
			arrayAppend( sort, numberFormat( v, "0000" ) );
			arrayAppend( intro, v );
		}
		querySetCell( q, "introduced", intro.toList( "." ) );
		querySetCell( q, "sort", sort.toList( "" ) );
		querySetCell( q, "description", arguments.description );
	}

	loop collection="#pc#" key="key" value="value" {
		if ( structKeyExists( checklist, value.page.getPageType() ) ) {
			if ( len( value.page.getIntroduced() ) gt 0 ) {
				addChangeLog( q, value.page, key, value.page.getTitle(), value.page.getIntroduced(), "" );
			} else if ( value.page.getPageType() eq "tag" ) {
				tagAttr = value.page.getAttributes();
				if ( isArray( tagAttr ) ) {
					for ( attr in tagAttr ) {
						if ( len( attr.introduced ?: "" ) ) {
							addChangeLog( q, value.page, key, value.page.getName(), attr.introduced,
								'<cf#value.page.getName()# #attr.name#="#attr.type#">'
							);
						}
					}
				}
			} else if ( value.page.getPageType() eq "function" ) {
				funcArg = value.page.getArguments();
				if ( isArray( funcArg ) ) {
					for ( arg in funcArg ) {
						if ( len( arg.introduced ?: "" ) ) {
							addChangeLog( q, value.page, key, value.page.getName(), arg.introduced,
								'#listFirst( value.page.getTitle(), "()" )#( #arg.name#="#arg.type#")'
							);
						}
					}
				}
			}
		}
	}

	q = new Query( dbtype="query", q=q, sql="select * from q order by sort desc" ).execute().getResult();

	// Body
	echo( local.changeLog.getBody() & chr(10) & chr(10) );

	// Version
	echo( "Generated from **" & server.lucee.version & "**" & chr(10) & chr(10) );

	// Changelog items
	prevIntroduced = "";
	for ( row in q ) {
		if ( prevIntroduced neq row.introduced ) {
			echo( "## " & row.introduced & chr(10) & chr(10) );
			prevIntroduced = row.introduced;
		}
		echo( "- [[" & row.ref & "]] " );
		if ( len( row.description ) ) {
			echo( row.description );
		} else {
			echo( row.name );
		}
		echo( chr(10) );
	}
</cfscript>
