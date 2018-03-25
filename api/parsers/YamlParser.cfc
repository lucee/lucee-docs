component {
	public any function init() {
		_setupYamlParser();

		return this;
	}

	public any function yamlToCfml( required string yaml ) {
		return _stripEmpty( _getYamlParser().load( arguments.yaml ) );
	}

// PRIVATE
	private void function _setupYamlParser() {
		var javaLib = [ "../lib/snakeyaml-1.15.jar" ];
		var parser  = CreateObject( "java", "org.yaml.snakeyaml.Yaml", javaLib ).init();

		_setYamlParser( parser );
	}

	private any function _getYamlParser() output=false {
		return _yamlParser;
	}
	private void function _setYamlParser( required any yamlParser ) output=false {
		_yamlParser = arguments.yamlParser;
	}

	private struct function _stripEmpty( required struct data ) {
		try {
			// remove all empty content
			for (var d in data){
				var hasContent = true;
				if (IsNull(data[d])){
					hasContent = false;
				} else if (isArray(data[d])) {
					if (arrayLen(data[d]) eq 1 and len(trim(data[d][1])) eq 0 )
						hasContent = false; // empty array
				} else if (isStruct(data[d])) {		
					if (structCount(data[d]) eq 0)	
						hasContent = false; // empty struct	
				} else if (len(trim(data[d])) eq 0){
					hasContent = false; // empty string
				}
				if (!hasContent)
					structDelete(data, d); // no need for empty attributes
			}
		} catch(e) {
			dump(data);
			throw(e);
			abort;
		}
		return data;
	}
}