component {
	property name="_markdownProcessor" type="object";
	property name="_noticeBoxRenderer" type="object";
	property name="flexmark" type="boolean" default="false";

	public any function init() {
		_setupNoticeBoxRenderer();
		return this;
	}

	public string function _markdownToHtml( required string markdown, required boolean stripParagraph=false) {
		// TODO code blocks with spaces or pre tags cause problems here
		var html = markdownToHtml( arguments.markdown );

		if  (arguments.stripParagraph ){ // used for inline content
			html = ReplaceNoCase( ReplaceNoCase( html, "<p>", "" ), "</p>", "");
		}
		return _getNoticeBoxRenderer().renderNoticeBoxes( html );
	}

	public void function validateMarkdown(required struct pageContent){
		var lines = ListToArray(arguments.pageContent.body, chr(10), true);
		var errors = [];
		local.lastLineEmpty = true;	// treat first row as empty
		local.inList = false;
		for (var l = 1; l <= lines.len();  l++){
			local.row = trim(lines[l]);
			local.empty=(len(row) eq 0);
			if (local.empty){
				local.inList = false;
				local.lastLineEmpty = true;
				continue;
			}
			local.first = left(local.row, 2);
			if (local.first eq "- "){
				if (local.lastLineEmpty){
					local.inList = true;
				} else if (not local.inList){
					errors.append({
						error: "list should be preceded by a new line",
						file: "#arguments.pageContent.sourceFile#",
						line: l,
						line: local.row
					});
					break;
				}
			}
			local.lastLineEmpty = local.empty;
		}

		if (ArrayLen(errors) gt 0){
			dump(var=errors, label=arguments.pageContent.sourceFile);
			writeOutput("<pre>#arguments.pageContent.body#</pre>");
			abort;
		}
	}

	private void function _setupNoticeBoxRenderer() {
		_setNoticeBoxRenderer( new api.rendering.NoticeBoxRenderer() );
	}

	private any function _getNoticeBoxRenderer() {
		return variables._noticeBoxRenderer;
	}
	private void function _setNoticeBoxRenderer( required any noticeBoxRenderer ) {
		variables._noticeBoxRenderer = arguments.noticeBoxRenderer;
	}

	// the markdown parser will skip continuous blocks of html, so replace empty lines with a <br>
	function replaceNewLines( html, placeholder ){
		var src = Replace(html, "#chr(10)##chr(13)#",chr(10), "all");
		var lines = ListToArray(src, chr(10), true);
		arrayEach( lines, function( el, idx, lines ) {
			if ( len( trim( arguments.el ) ) eq 0 ) {
				arguments.lines[ arguments.idx ] = placeholder;
			} else {
				arguments.lines[ arguments.idx ] &= chr(10);
			}
		});
		return arrayToList(lines, "");
	}

}
