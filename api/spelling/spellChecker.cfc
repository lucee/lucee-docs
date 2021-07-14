component accessors=true {
	property name="buildsDir"   type="string";
	property name="threads"     type="numeric";
    property name="dictionary"     type="struct";
    property name="LuceeWhiteListFile" default="./lucee_words.txt";

// CONSTRUCTOR
	public any function init(numeric threads=1) {
		setThreads(arguments.threads);
		setBuildsDir( ExpandPath( "/builds" ) );
		new api.build.Logger();
		return this;
	}

// PUBLIC API
	public void function spellCheck() {
        param name="form.whitelist" default="";
        if (len(form.whitelist) gt 0){
            whitelistWord(form.whitelist);
        } else {
            WriteOutput("<script src='/assets/js/jquery-3.3.1.js' type='text/javascript'></script>");
            WriteOutput("<script src='/assets/js/spellcheck.js' type='text/javascript'></script>");
            WriteOutput("<b>note: this scans the built html, examples are excluded</b><br>");
            loadDictionary();
            processFiles();
        }
	}

	public void function loadDictionary() {
        var words = {};

        words.append(extractFunctions());
        words.append(extractTags());
        words.append(extractMethods());
        words.append(extractObjects());

        request.logger("Loaded " & words.count() & " cfml words");
        var english = deserializeJSON(FileRead("./words_dictionary.json"));
        request.logger("Loaded " & english.count() & " english words");
        words.append(english);
        var luceeWords = ListToArray(FileRead(getLuceeWhiteListFile()),"#chr(10)##chr(13)#");
        var custom = {};
        for (var w in luceeWords)
            custom[w]="custom";
		words.append(custom);
        setDictionary(words);
	}

    private void function whitelistWord(word){
        FileAppend(getLuceeWhiteListFile(), trim(word) & chr(10));
        writeOutput("added");
        abort;
    };

    public any function processFiles() {
        var dict = getDictionary();
        var missing = {};
        var path = getBuildsDir() & "/html";
        var files = DirectoryList( path=getBuildsDir() & "/html", recurse=true, listInfo="path", filter="*.html" );
        writeOutput("<ol>");
        for (var file in files){
            var words = extractWords(file);
            var filePath = mid(file, path.len()+2);
            for (var word in words){
                if ( not dict.keyExists(word)){
                    if ( not missing.keyExists(word))
                        missing[word]={};
                    missing[word][filepath]="";
                }
            }
            if (missing.count() > 5000){
                renderMissing(missing);
                abort;
            }
        }
        WriteOutput("<h1>Scan done, #missing.count()# unknown words found</h1>");
        renderMissing(missing);
	}

    public any function renderMissing(missing){
        var q = QueryNew("word,count,pages");
        for (var word in missing){
            var r =QueryAddRow(q);
            querySetCell(q, "word", word, r);
            querySetCell(q, "count", missing[word].count(), r);
            querySetCell(q, "pages", missing[word], r);
        }
        querySort(q, "count,word", "desc,desc");

        writeOutput("<style> li {padding-top: 15px} li a.missing {font-weight: bolder;} </style>");

        for (var word in q){
            //writeOutPut("<li><a href='/#missing[word]#'>#word#</a>");
            writeOutPut("<li><span><a class='missing'>#q.word#</a> #((q.count == 1)? "" : q.count)# ");
            writeOutPut("<input type='button' class='whitelist' value='approve'></span>");
            for (var page in q.pages)
                writeOutPut("<br><a href='/#page#'>/#page#</a>");
            writeOutPut("</li>");
        }
    }

	public any function extractWords(file) {
        var text = listToArray(stripHTML( FileRead(file), file ), ",.();:?%&""|_!<>- `*{}[]='/\###chr(10)#", false, false);
        var words = {};
        for (word in text){
            word = trim(word);
            var c = left(word,1 );
            if ( word.len() lte 1 or c eq "&" or c eq ":" or c eq "-" or isNumeric(word))
                continue;

            words[word]="";
            //writeOutput(trim(word) & "<br>#chr(10)#");
        }
        //dump(var=words, label=file);
        return words;
	}

    private string function stripHtml ( required string html,  required string file) {
        var str = arguments.html;
        var pre = Find("<pre>", str, 1);
        // examples have lots of weird names, so excluding them
        while (pre > 0){
            var endPre = Find("</pre>", str, pre);
            if (endPre > 0)
                str = mid(str, 1, pre) & mid(str, endPre+6);
            pre = Find("<pre>", str, 1);
        }

		str = ReReplaceNoCase(str, "<*style.*?>(.*?)</style>"," ","all");
		str = ReReplaceNoCase(str, "<*script.*?>(.*?)</script>"," ","all");

		str = ReReplaceNoCase(str, "<.*?>"," ","all");
		str = ReReplaceNoCase(str, "^.*?>"," ");
		str = ReReplaceNoCase(str, "<.*$","");
        str = ReReplaceNoCase(str, "  "," ");

		return Trim( URLDecode(str) );
	}

    private struct function extractFunctions(boolean cspell="false") {
        var words = {};
		var referenceReader = new api.reference.ReferenceReaderFactory().getFunctionReferenceReader();
		Each (referenceReader.listFunctions(), function(functionName){
            var convertedFunc = referenceReader.getFunction( functionName );
            for (var arg in convertedFunc.arguments){
                words[arg.name]=functionName;
                if (cspell)
                    words[functionName & "." & arg.name]="function";
            }
            words[functionName]="function";

		}, true, 1);
        return words;
	}

	private struct function extractObjects(boolean cspell="false") {
		var words = {};
		var referenceReader = new api.reference.ReferenceReaderFactory().getObjectReferenceReader();

		Each (referenceReader.listObjects(), function(objectName) {
			words[objectName]="object";
		}, true, 1);
		return words;
	}

	private struct function extractMethods(boolean cspell="false") {
		var words = {};
		var referenceReader = new api.reference.ReferenceReaderFactory().getMethodReferenceReader();
		var objects = referenceReader.listMethods();
		Each (objects, function(object){
		//for( var object in objects ) {
			for (var method in objects[object] ){
				var methodData = referenceReader.getMethod( object, method);
                for (var arg in methodData.arguments){
                    words[arg.name]=method;
                    if (cspell)
                        words[arg.name & "." & method]="object";
                }
                words[object]="object";
                words[method]="method";
                if (cspell)
                    words[object & "." & method]="object";
			}
		}, true, 1);
        return words;
	}

	private struct function extractTags(boolean cspell="false") {
        var words = {};
		var referenceReader = new api.reference.ReferenceReaderFactory().getTagReferenceReader();
		Each (referenceReader.listTags(), function(tagName){
			var convertedTag = referenceReader.getTag( tagName );
            for (var attr in convertedTag.attributes)
                words[attr.name]=tagName;
            words[tagName]="tag";
            words["cf" & tagName]="tag";

		}, true, 1);
		return words;
	}

}