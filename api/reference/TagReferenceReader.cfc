component accessors=true {

	property name="tags" type="struct";

	public any function init() {
		_loadExtensionInfo();
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
		var tags = {};
		for( var tagName in tagNames ) {
			var convertedTag = _getTagDefinition( tagName );
			if (  convertedTag.status neq "hidden" )
				tags[ convertedTag.name ] = convertedTag;
		}

		setTags( tags );
	}

	private struct function _getTagDefinition( required string tagName ) {
		silent {  // some tags leak new lines https://luceeserver.atlassian.net/browse/LDEV-1796
			var coreDefinition = getTagData( "cf", arguments.tagName );
		}
		var parsedTag      = StructNew( "linked" );

		parsedTag.name                 = coreDefinition.name ?: NullValue();
		parsedTag.type                 = coreDefinition.type ?: NullValue();
		parsedTag.description          = coreDefinition.description ?: NullValue();
		parsedTag.status               = coreDefinition.status ?: NullValue();
		parsedTag.appendix             = IsBoolean( coreDefinition.hasNameAppendix ?: "" ) && coreDefinition.hasNameAppendix; // ? what does this mean exactly
		parsedTag.bodyContentType      = coreDefinition.bodyType ?: ""; // better name here?
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

		if ( structKeyExists( variables.extensionMap, coreDefinition.name ) )
			parsedTag.srcExtension = variables.extensionMap[ coreDefinition.name ];

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
			parsedAttribute.introduced             = attrib.introduced	?: NullValue();
			if ( attrib.status neq "hidden" )
				parsedTag.attributes.append( parsedAttribute );
		}

		return parsedTag;
	}

	private void function _loadExtensionInfo(){
		// load java tags
		variables.extensionMap = {};
		var cfg = getPageContext().getConfig();
		var tlds = cfg.getTLDs(1);
		//dump(tlds); abort;
		var tags = tlds[1].getTags();
		//dump(tags); abort;
		for (var tag in tags){
		    //dump(tag); abort;
			try {
				var bi = bundleInfo( createObject( 'java', tags[tag].getTagClassDefinition().getClazz().getName() ) );
				if ( bi.name != "lucee.core" ) {
					var e = getExtensionOfBundle( bi.name ).toStruct();
					variables.extensionMap[ tag ] = {
						name: e.name,
						id: e.id,
						version: e.version
					}
				}
			} catch (e) { 
				//ignore 
			}
		}

		// load cfml tags
		var extensions = extensionList();
		loop query="extensions" {
			local.e = queryRowData ( extensions, extensions.currentrow, "struct" );
			if (len(e.functions) ){
				for ( fname in e.tags ){
					if ( listLen( fname, "/\" eq 1 ) ){ // avoid lucee/core/ajax/css/jquery/images/ui-anim_basic_16x16.gif.cfm etc
						variables.extensionMap[ listFirst( fname, "." ) ] = {
							name: e.name,
							id: e.id,
							version: e.version
						}
					}
				}
			}

		}
	}

	private any function getExtensionOfBundle( bundleName ) {
		var cfg = getPageContext().getConfig();
		var extensions = cfg.getAllRHExtensions();
		loop collection=extensions.iterator() item="local.ext" {
			loop array = ext.bundles item="local.bundle" {
				if ( bundle.symbolicName == bundleName ) return ext;
			}
		}
		throw "could not find extension for bundle [#bundleName#]";
	}

}