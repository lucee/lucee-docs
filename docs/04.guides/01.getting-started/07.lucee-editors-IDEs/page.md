---
title: Lucee Editors & IDEs
id: lucee-editors-IDEs
---

There are many modern IDE's which include support for CFML development 

## Lucee Dictionaries

Lucee dictionaries are available for download to support spell checking your code.

[Download cspell .txt dictionary](/dictionaries/lucee.txt)

[Download .json dictionary](/dictionaries/lucee.json)

<https://luceeserver.atlassian.net/browse/LD-115>

## CFEclipse
<https://www.cfeclipse.org>

## VS Code
<https://code.visualstudio.com>

<https://marketplace.visualstudio.com/items?itemName=ilich8086.ColdFusion>

<https://marketplace.visualstudio.com/items?itemName=KamasamaK.vscode-cflint>

<https://marketplace.visualstudio.com/items?itemName=streetsidesoftware.code-spell-checker>

## Sublime Text
<https://www.sublimetext.com>

<https://github.com/jcberquist/sublimetext-cfml>

<https://github.com/ckaznocha/SublimeLinter-contrib-CFLint>

## Adobe Coldfusion Builder
<https://www.adobe.com/products/coldfusion-builder.html>

## Atom
<https://atom.io>

<https://atom.io/packages/language-cfml>

## CFBrackets 
<http://cfbrackets.org>

## ActiveState Komodo
<https://www.activestate.com/komodo-ide>

<http://www.we3geeks.org/komodo-cfml/>

## IntelliJ IDEA
<https://www.jetbrains.com/idea/download/index.html>

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
