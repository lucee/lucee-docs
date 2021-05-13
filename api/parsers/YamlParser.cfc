component {
	property name="_yamlParser" type="object";

	public any function init() {
		_setupYamlParser();

		return this;
	}

	// snakeYaml only rarely has concurrency issues
	public any function yamlToCfml( required string yaml ) {
		lock name="snakeYamlIsntThreadSafe" timeout="5" type="exclusive" {
			try {
				return _stripEmpty( _getYamlParser().load( arguments.yaml ) );
			} catch (e){
				cfcatch.message = " " & cfcatch.message;
				cfcatch.detail = "YamlParser: " & HtmlCodeFormat(arguments.yaml);
				rethrow;
			}
		}
	}

	public any function cfmlToYaml( required struct data ) {
		lock name="snakeYamlIsntThreadSafe" timeout="5" type="exclusive" {
			return _getYamlParser().dumpAsMap( _stripEmpty(arguments.data) );
		}
	}

// PRIVATE
	private void function _setupYamlParser() {
		var javaLib = [ "../lib/snakeyaml-1.9.jar" ];
		var parser  = CreateObject( "java", "org.yaml.snakeyaml.Yaml", javaLib ).init();

		_setYamlParser( parser );
	}

	private any function _getYamlParser() output=false {
		return variables._yamlParser;
	}
	private void function _setYamlParser( required any yamlParser ) output=false {
		variables._yamlParser = arguments.yamlParser;
	}

	private struct function _stripEmpty( required struct data ) {
		try {
			// remove all empty content
			for (var d in arguments.data){
				var hasContent = true;
				if (IsNull(arguments.data[d])){
					hasContent = false;
				} else if (isArray(arguments.data[d])) {
					if (arrayLen(arguments.data[d]) eq 0 )
						hasContent = false; // empty array
					else if (arrayLen(arguments.data[d]) eq 1 and len(trim(arguments.data[d][1])) eq 0 )
						hasContent = false; // empty array
				} else if (isStruct(arguments.data[d])) {
					if (structCount(arguments.data[d]) eq 0)
						hasContent = false; // empty struct
				} else if (len(trim(arguments.data[d])) eq 0){
					hasContent = false; // empty string
				}
				if (not hasContent)
					structDelete(arguments.data, d); // no need for empty attributes
			}
		} catch(e) {
			request.logger("error stripping YAML properties: #cfcatch.message#");
		}
		return arguments.data;
	}
}
