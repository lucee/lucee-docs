---
title: Lucee Editors & IDEs
id: lucee-editors-IDEs
---

Here are the Modern IDEs which include support for CFML development

**Show your love and star these repos on GitHub!**

## VS Code

<https://code.visualstudio.com>

<https://marketplace.visualstudio.com/items?itemName=CFMLEditor.cfmleditor>

<https://marketplace.visualstudio.com/items?itemName=CFMLEditor.cfmleditor-lint>

<https://marketplace.visualstudio.com/items?itemName=streetsidesoftware.code-spell-checker>

### Step debugging Lucee with VS Code (highly recommended!)

[**LuceeDebug**](https://github.com/softwareCobbler/luceedebug) supports step debugging via breakpoints via a java agent and a [VS Code extension](https://marketplace.visualstudio.com/items?itemName=DavidRogers.luceedebug)


## Sublime Text

<https://www.sublimetext.com>

<https://github.com/jcberquist/sublimetext-cfml>

<https://github.com/ckaznocha/SublimeLinter-contrib-CFLint>

## Adobe ColdFusion Builder

<https://www.adobe.com/products/coldfusion-builder.html>

## CFLint

<https://github.com/cflint/CFLint>
is a very useful tool for linting (validating) your CFML code, there is integration available for many IDE's or you can run it in standalone mode over your whole code base

here is a sample .cflintrc file which reduces the noise

```
{
	"rule" : [ ],
	"excludes": [{"code":"ARGUMENT_ALLCAPS_NAME"},{"code":"ARGUMENT_HAS_PREFIX_OR_POSTFIX"},
		{"code":"ARGUMENT_INVALID_NAME"},{"code":"ARGUMENT_IS_TEMPORARY"},
		{"code":"ARGUMENT_TOO_LONG"},{"code":"ARGUMENT_TOO_SHORT"},{"code":"ARG_DEFAULT_MISSING"},
		{"code":"ARG_HINT_MISSING"},{"code":"ARG_HINT_MISSING_SCRIPT"},
		{"code":"ARG_TYPE_ANY"},{"code":"ARG_TYPE_MISSING"},{"code":"AVOID_USING_ARRAYNEW"},
		{"code":"AVOID_USING_CFABORT_TAG"},{"code":"AVOID_USING_CFDUMP_TAG"},
		{"code":"AVOID_USING_CFINCLUDE_TAG"},{"code":"AVOID_USING_CFMODULE_TAG"},{"code":"AVOID_USING_CREATEOBJECT"},
		{"code":"AVOID_USING_DEBUG_ATTR"},{"code":"AVOID_USING_ISDATE"},{"code":"AVOID_USING_STRUCTNEW"},
		{"code":"COMPONENT_HINT_MISSING"},{"code":"COMPONENT_INVALID_NAME"},
		{"code":"COMPONENT_TOO_LONG"},{"code":"COMPONENT_TOO_WORDY"},{"code":"EXCESSIVE_ARGUMENTS"},
		{"code":"EXCESSIVE_FUNCTIONS"},{"code":"EXCESSIVE_COMPONENT_LENGTH"},{"code":"EXCESSIVE_FUNCTION_LENGTH"},
		{"code":"UNUSED_METHOD_ARGUMENT"}, {"code":"SQL_SELECT_STAR"},
		{"code":"EXPLICIT_BOOLEAN_CHECK"},{"code":"FUNCTION_HINT_MISSING"},{"code":"FUNCTION_TOO_COMPLEX"},
		{"code":"FUNCTION_TYPE_ANY"},{"code":"FUNCTION_TYPE_MISSING"},{"code":"GLOBAL_LITERAL_VALUE_USED_TOO_OFTEN"},
		{"code":"GLOBAL_VAR"}, {"code":"LOCAL_LITERAL_VALUE_USED_TOO_OFTEN"},{"code":"METHOD_INVALID_NAME"},
		{"code":"METHOD_IS_TEMPORARY"},{"code":"METHOD_TOO_LONG"}, {"code":"METHOD_TOO_WORDY"},{"code":"NESTED_CFOUTPUT"},
		{"code":"OUTPUT_ATTR"},{"code":"PACKAGE_CASE_MISMATCH"},{"code":"STRUCT_ARRAY_NOTATION"},
		{"code":"UNQUOTED_STRUCT_KEY"},{"code":"VAR_ALLCAPS_NAME"},{"code":"VAR_HAS_PREFIX_OR_POSTFIX"},
		{"code":"VAR_IS_TEMPORARY"},{"code":"VAR_TOO_LONG"},{"code":"VAR_TOO_SHORT"},{"code":"VAR_TOO_WORDY"},
		{"code":"SCOPE_ALLCAPS_NAME"}, {"code":"AVOID_USING_ABORT"}, {"code":"VAR_INVALID_NAME"},
	],
	"includes" : [ ],
	"inheritParent" : false
}
```

## Analysis tools and Line Debuggers

<https://www.fusion-reactor.com/>

<http://www.fusion-debug.com/>

## Lucee Dictionaries

Lucee dictionaries are available for download to support spell checking your code.

[Download cspell .txt dictionary](/dictionaries/lucee.txt)

[Download .json dictionary](/dictionaries/lucee.json)

<https://luceeserver.atlassian.net/browse/LD-115>
