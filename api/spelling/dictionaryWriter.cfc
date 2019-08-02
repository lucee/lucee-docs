component accessors=true extends=spellchecker {
	property name="buildsDir"   type="string";
	property name="threads"     type="numeric";
    property name="dictionaryDir" default="";
    property name="cspellFile" default="lucee.txt";
    property name="jsonFile" default="lucee.json";

// CONSTRUCTOR
	public any function init(required string dictionaryDir, numeric threads=1) {
		setThreads(arguments.threads);
        setDictionaryDir(arguments.dictionaryDir);
		new api.build.Logger();
		return this;
	}

// PUBLIC API
	public void function build() {
        var words = structNew("ordered");
        words.append(extractFunctions(true));
        words.append(extractTags(true));
        words.append(extractMethods(true));
        words.append(extractObjects(true));
        words.append({ "lucee": "product"} );
        buildCSpell(words);
        buildJson(words);
    }

    private void function buildCSpell(words) {
        var dict = ArrayToList(ListToArray(structKeyList(arguments.words)).sort("textnocase"),chr(10));
        var file = getDictionaryDir() & getCspellFile();

        if (not directoryExists(getDictionaryDir()))
            directoryCreate(getDictionaryDir());

        request.logger("Lucee CSpell dictionary exported: #file#");
        FileWrite(file, dict);
    }
    private void function buildJson(words) {
        var dict = serializeJSON(arguments.words);
        var file = getDictionaryDir() & getJsonFile();

        if (not directoryExists(getDictionaryDir()))
            directoryCreate(getDictionaryDir());

        request.logger("Lucee json dictionary exported: #file#");
        FileWrite(file, dict);
    }
}
