component accessors=true {

	property name="tags" type="struct";

	public any function init( required string sourceFileOrUrl ) {
		_loadTagsFromXmlDefinition( arguments.sourceFileOrUrl );

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
	public void function _loadTagsFromXmlDefinition( required string sourceFileOrUrl ) {
		var referenceXml  = XmlParse( arguments.sourceFileOrUrl );
		var xmlTags       = XmlSearch( referenceXml, "/taglib/tag" );
		var tags          = StructNew( "linked" );

		for( var tag in xmlTags ) {
			_parseXmlTagDefinition( tag, tags);
		}

		setTags( tags );
	}

	private void function _parseXmlTagDefinition( required xml tag, struct tags) output=false {
		var parsedTag = StructNew( "linked" );

		parsedTag.name                 = tag.name.xmlText ?: NullValue();
		parsedTag.description          = tag.description.xmlText ?: NullValue();
		parsedTag.status               = tag.status.xmlText ?: NullValue();

		if(!isNull(parsedTag.status) && (parsedTag.status=="hidden" || parsedTag.status=="unimplemented")) return ;

		parsedTag.appendix             = IsBoolean( tag.apppendix.xmlText ?: "" ) && tag.appendix.xmlText; // ? what does this mean exactly
		parsedTag.bodyContentType      = tag[ "body-content" ].xmlText ?: NullValue(); // better name here?
		parsedTag.attributeType        = tag[ "attribute-type" ].xmlText ?: NullValue(); // better name here?
		parsedTag.minimumAttributes    = tag[ "attribute-min" ].xmlText ?: NullValue(); // better name here?
		parsedTag.handleException      = tag[ "handle-exception" ].xmlText ?: NullValue(); // better name here?
		parsedTag.allowRemovingLiteral = tag[ "allow-removing-literal" ].xmlText ?: NullValue(); // better name here? what does it mean?! It's always "yes".

		parsedTag.sourceClasses = StructNew( "linked" );
		parsedTag.sourceClasses.tag  = tag[ "tag-class" ].xmlText  ?: NullValue();
		parsedTag.sourceClasses.ttt  = tag[ "ttt-class" ].xmlText  ?: NullValue();
		parsedTag.sourceClasses.tdbt = tag[ "tdbt-class" ].xmlText ?: NullValue();
		parsedTag.sourceClasses.att  = tag[ "att-class" ].xmlText  ?: NullValue();
		parsedTag.sourceClasses.tte  = tag[ "tte-class" ].xmlText  ?: NullValue();

		parsedTag.script = StructNew( "linked" );
		parsedTag.script.type                   = tag.script.type.xmlText        ?: NullValue();
		parsedTag.script.runtimeExpressionValue = tag.script.rtexprvalue.xmlText ?: NullValue();
		parsedTag.script.context                = tag.script.context.xmlText     ?: NullValue();

		parsedTag.attributes = [];
		for( var child in tag.xmlChildren ) {
			if ( child.xmlName == "attribute" ) {
				var parsedAttribute = StructNew( "linked" );				
				parsedAttribute.status                 = child.status.xmlText ?: NullValue();

				if(!isNull(parsedAttribute.status) && (parsedAttribute.status=="hidden" || parsedAttribute.status=="unimplemented")) continue;
				
				parsedAttribute.name                   = child.name.xmlText ?: NullValue();
				parsedAttribute.type                   = child.type.xmlText ?: NullValue();
				parsedAttribute.default                = IsBoolean( child.default.xmlText ?: "" ) && child.default.xmlText;
				parsedAttribute.defaultValue           = child[ "default-value" ].xmlText ?: NullValue();
				parsedAttribute.description            = child.description.xmlText ?: NullValue();
				parsedAttribute.aliases                = ListToArray( child.alias.xmlText ?: "" );
				parsedAttribute.values                 = ListToArray( child.values.xmlText ?: "" );
				parsedAttribute.required               = IsBoolean( child.required.xmlText ?: "" ) && child.required.xmlText;
				parsedAttribute.noname                 = IsBoolean( child.noname.xmlText ?: "" ) && child.noname.xmlText;
				parsedAttribute.scriptSupport          = child[ "script-support" ].xmlText ?: NullValue();
				parsedAttribute.runTimeExpressionValue = IsBoolean( child.rtexprvalue.xmlText ?: "" ) && child.rtexprvalue.xmlText;

				parsedTag.attributes.append( parsedAttribute );
			}
		}
		tags[ parsedTag.name ] = parsedTag;
	}

}