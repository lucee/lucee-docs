component accessors=true {

	property name="tags" type="struct";

	public any function init() {
		_loadTagDefinitions();

		return this;
	}

	public array function listTags() {
		return getTags().keyArray();
	}

	public struct function getTag( required string tagName ) {
		var tags = getTags();

		return tags[ arguments.tagName ] ?: {};
	}

// private helpers
	public void function _loadTagDefinitions() {
		var tagNames = getTagList().cf.keyArray().sort( "textnocase" );

		for( var tagName in tagNames ) {
			var convertedTag = _getTagDefinition( tagName );

			tags[ convertedTag.name ] = convertedTag;
		}

		setTags( tags );
	}

	private struct function _getTagDefinition( required string tagName ) {
		var coreDefinition = getTagData( "cf", arguments.tagName );
		var parsedTag      = StructNew( "linked" );

		parsedTag.name                 = coreDefinition.name ?: NullValue();
		parsedTag.type                 = coreDefinition.type ?: NullValue();
		parsedTag.description          = coreDefinition.description ?: NullValue();
		parsedTag.status               = coreDefinition.status ?: NullValue();
		parsedTag.appendix             = IsBoolean( coreDefinition.hasNameAppendix ?: "" ) && coreDefinition.hasNameAppendix; // ? what does this mean exactly
		parsedTag.bodyContentType      = coreDefinition.bodyType ?: "" // better name here?
		parsedTag.parseBody            = IsBoolean( coreDefinition.parseBody ?: "" ) && coreDefinition.parseBody;
		parsedTag.attributeType        = coreDefinition.attributeType ?: NullValue(); // better name here?
		parsedTag.attributeCollection  = IsBoolean( coreDefinition.attributeCollection ?: "" ) && coreDefinition.attributeCollection;
		parsedTag.minimumAttributes    = NullValue(); // ???
		parsedTag.handleException      = NullValue(); // ???
		parsedTag.allowRemovingLiteral = NullValue(); // ???

		parsedTag.script = StructNew( "linked" );
		parsedTag.script.type                   = coreDefinition.script.type       ?: NullValue();
		parsedTag.script.context                = coreDefinition.script.singletype ?: NullValue(); // ???
		parsedTag.script.runtimeExpressionValue = IsBoolean( coreDefinition.script.rtexpr ?: "" ) && coreDefinition.script.rtexpr;

		parsedTag.attributes = [];
		var attribs = coreDefinition.attributes ?: {};
		for( var attribName in attribs ) {
			var attrib = attribs[ attribName ];
			var parsedAttribute = StructNew( "linked" );

			parsedAttribute.name                   = attribName
			parsedAttribute.type                   = attrib.type ?: NullValue();
			parsedAttribute.description            = attrib.description ?: NullValue();
			parsedAttribute.status                 = attrib.status ?: NullValue();
			parsedAttribute.required               = IsBoolean( attrib.required ?: "" ) && attrib.required;
			parsedAttribute.default                = IsBoolean( attrib.default ?: "" ) && attrib.default;
			parsedAttribute.defaultValue           = attrib.defaultValue ?: NullValue();
			parsedAttribute.scriptSupport          = attrib.scriptSupport ?: NullValue();
			parsedAttribute.aliases                = ListToArray( attrib.alias ?: "" );
			parsedAttribute.values                 = attrib.values ?: [];
			parsedAttribute.noname                 = IsBoolean( attrib.noname ?: "" ) && attrib.noname;
			parsedAttribute.runTimeExpressionValue = IsBoolean( attrib.rtexpr ?: "" ) && attrib.rtexpr;

			parsedTag.attributes.append( parsedAttribute );
		}

		return parsedTag;
	}
}