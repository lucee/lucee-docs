---
title: Extension Config XML Matrix
id: extension-config-xml-matrix
---

### config.xml matrix ###

**Tag config**

Attribute | Description
------------ | -------------
dynamic | This attribute contains a method name of the install.cfc. It can completely fill the form dynamically. The method receives the loaded ExtensionConfig CFC as an argument.

**Tag Step**

Attribute | Description
------------ | -------------
dynamic | This attribute contains a method name of the install.cfc. It can completely fill the form dynamically. The method receives the loaded ExtensionStep CFC as an argument.
label | Label of the step
description | Description of the step

**Tag group**

Attribute | Description
------------ | -------------
dynamic | This attribute contains a method name of the install.cfc. It can completely fill the form dynamically. The method receives the loaded ExtensionGroup CFC as an argument.
label | Label of the step
description | Description of the step

**Tag item**

Attribute | Description
------------ | -------------
full-dynamic | This attribute contains a method name of the install.cfc. In contrary to the attribute dynamic, the method does not receive the current item as a parameter, but the parent group element (ExtensionGroup CFC). This allows inserting items in an existing group dynamically.
dynamic | This attribute contains a method name of the install.cfc. It can completely fill the item of the group on a form step dynamically. The method receives the loaded ExtensionItem CFC as an argument.
label | Label of the step
description | Description of the step
name | 	Name of the item
type | Type of the item. Valid values are:<ul><li>text</li><li>radio</li><li>checkbox</li><li>checkbox</li><li>hidden</li><li>password</li></ul>
value | Default value of the item. The default value can be defined in the body of the tag as well.

**Tag option**

Attribute | Description
------------ | -------------
label | Label of the step
description | Description of the step
selected | Sets whether the option is selected or not. Valid values are true and false
value | Default value of the item. The default value can be defined in the body of the tag as well.

Next step - [[extension-cfcs-matrix]]