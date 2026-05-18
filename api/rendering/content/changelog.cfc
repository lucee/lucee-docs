component {

	// Renders the most recently introduced tags, functions, arguments and attributes.
	// hashParam optionally sets the limit, e.g. [[content::latest-changelog#10]]
	function render( required any docTree, string hashParam="", boolean markdown=false ) {
		var limit = val( arguments.hashParam );
		if ( limit lte 0 ) limit = 20;

		var q = _buildChangelogQuery( arguments.docTree );

		if ( arguments.markdown ) {
			var lines = [ "" ];
			var count = 0;
			cfloop( query=q ) {
				if ( ++count gt limit ) break;
				var label = len( q.description ) ? q.description : q.name;
				arrayAppend( lines, "- **" & q.introduced & "** — [" & label & "](/reference/" & q.ref & ".html)" );
			}
			arrayAppend( lines, "" );
			return arrayToList( lines, chr( 10 ) );
		}

		var out = [ "<ul class='latest-changelog'>" ];
		var count = 0;
		cfloop( query=q ) {
			if ( ++count gt limit ) break;
			var label = len( q.description ) ? q.description : htmlEditFormat( q.name );
			arrayAppend( out, "<li><strong>" & q.introduced & "</strong> — <a href='/reference/"
				& q.ref & ".html'>" & label & "</a></li>" );
		}
		arrayAppend( out, "</ul>" );
		return arrayToList( out, chr( 10 ) );
	}

// PRIVATE
	private query function _buildChangelogQuery( required any docTree ) {
		var pc = arguments.docTree.getPageCache().getPages();
		var checklist = { function: true, tag: true };
		var q = queryNew( "type,ref,name,introduced,sort,description" );

		cfloop( collection=pc, key="key", value="value" ) {
			if ( !structKeyExists( checklist, value.page.getPageType() ) ) continue;

			if ( len( value.page.getIntroduced() ) gt 0 ) {
				_addRow( q, value.page, value.page.getId(), value.page.getTitle(), value.page.getIntroduced(), "" );
			} else if ( value.page.getPageType() eq "tag" ) {
				var tagAttr = value.page.getAttributes();
				if ( isArray( tagAttr ) ) {
					cfloop( array=tagAttr, item="attr" ) {
						if ( len( attr.introduced ?: "" ) ) {
							_addRow( q, value.page, value.page.getId(), value.page.getName(), attr.introduced,
								'&lt;cf' & value.page.getName() & ' ' & attr.name & '="' & attr.type & '"&gt;' );
						}
					}
				}
			} else if ( value.page.getPageType() eq "function" ) {
				var funcArg = value.page.getArguments();
				if ( isArray( funcArg ) ) {
					cfloop( array=funcArg, item="arg" ) {
						if ( len( arg.introduced ?: "" ) ) {
							_addRow( q, value.page, value.page.getId(), value.page.getName(), arg.introduced,
								listFirst( value.page.getTitle(), "()" ) & '( ' & arg.name & '="' & arg.type & '" )' );
						}
					}
				}
			}
		}

		querySort( q, "sort", "desc" );
		return q;
	}

	private void function _addRow( required query q, required any page, required string ref,
			required string name, required string introduced, required string description ) {
		var r = queryAddRow( arguments.q );
		querySetCell( arguments.q, "type", arguments.page.getPageType() );

		var formattedRef = arguments.ref;
		if ( arguments.page.getPageType() eq "function" ) {
			formattedRef = arguments.ref contains "function-"
				? replaceNoCase( arguments.ref, "function-", "functions/" )
				: "functions/" & arguments.ref;
		} else if ( arguments.page.getPageType() eq "tag" ) {
			formattedRef = arguments.ref contains "tag-"
				? replaceNoCase( arguments.ref, "tag-", "tags/" )
				: "tags/" & arguments.ref;
		}
		querySetCell( arguments.q, "ref", formattedRef );
		querySetCell( arguments.q, "name", arguments.name );

		var sort = [];
		var intro = [];
		cfloop( list=arguments.introduced, delimiters=".", item="local.v" ) {
			if ( local.v eq "000" ) local.v = 0;
			arrayAppend( sort, numberFormat( local.v, "0000" ) );
			arrayAppend( intro, local.v );
		}
		querySetCell( arguments.q, "introduced", intro.toList( "." ) );
		querySetCell( arguments.q, "sort", sort.toList( "" ) );
		querySetCell( arguments.q, "description", arguments.description );
	}
}
