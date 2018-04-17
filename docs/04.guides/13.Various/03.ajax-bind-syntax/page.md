---
title: Ajax:Bind_Syntax
id: ajax-bind-syntax
categories:
- ajax
description: Most of the tags support a binding statement in the url or source attributes. The following syntax is supported.
---

## Binding Syntax ##

Most of the tags support a binding statement in the url or source attributes. The following syntax is supported.

### Bind to a cfc ###
```lucee
bind="cfc:component.dotted.path.cfcMethod({bindedElement})"
```
## Url Binding ##

```lucee
bind="url:url?name={bindedElement}&......."
```

## Javascript Binding ##

```lucee
bind="javascript:jsFunction({bindedElement})"
```
The 3 bindings fashions are not supported by any tag. Check the single tag docs for specific support.

### Parameters Syntax ###

The parameters passed to a binding statement can be declared following these rules:

On change of element with name myName the cfc is called passing myName=value as argument.

```lucee
bind="cfc:ajaxproxy.cfc.test.getInfo({myName})
```
On change of elements with name 'myName' or element with name 'myAge' contained by an element with id 'myForm' cfc is called passing both fields as arguments.

```lucee
bind="cfc:ajaxproxy.cfc.test.getInfo({myForm:myName},{myForm:myAge})
```

## Events ##

Adding '@' after the element name allows to choose what event binding will listen to.

Possible events are :

```lucee
* change ( default ) 
* mousedown
* keyup
* none
```

None will add the element to the querystring but will not trigger the binding if something happens to the element itself.

```lucee
bind="cfc:ajaxproxy.cfc.test.getInfo({myName@none},{myAge@none},{btn@mousedown})
```
