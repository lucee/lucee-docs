---
title: Extension CFCs matrix
id: extension-cfcs-matrix
categories:
- extensions
menuTitle: CFCs matrix
---

The methods marked red are system methods and should therefore not be called in the installation application. The hierarchy looks like follows: ExtensionConfig.cfc ? ExtensionStep.cfc ? ExtensionGroup.cfc ? ExtensionItem.cfc ? ExtensionOption.cfc

**ExtensionConfig.cfc**

Method | Description
------------ | -------------
createStep(string: label, string: description): ExtensionStep | Creates and links a new step.
getSteps(): ExtensionStep[] | Returns all ExtensionSteps of the ExtensionConfig.

**ExtensionStep.cfc**

Method | Description
------------ | -------------
init(string: label, string: description): ExtensionStep | Initializes the ExtensionStep CFC. Is called on creation.
createGroup(string: label, string: description): ExtensionStep | Creates and links a new group.
getGroups(): ExtensionGroup[] | Returns all ExtensionGroups of the ExtensionStep.
getLabel(): string | Returns the label of the step
getDescription(): string | Returns the description of the step.
setLabel(string: label): void | Sets the label
setDescription(string: label): void | Sets the description

**ExtensionGroup.cfc**

Method | Description
------------ | -------------
init(string: label, string: description): ExtensionGroup | Initializes the ExtensionGroup CFC. Is called on creation.
createItem(string: type, string: name, string: value, boolean: selected, string: label, string: description): ExtensionItem | Creates and links a new item.
getItems(): ExtensionItem[] | Returns all ExtensionItems of the ExtensionGroup.
getLabel(): string | Returns the label of the group
getDescription(): string | Returns the description of the group.
setLabel(string: label): void | Sets the label
setDescription(string: label): void | Sets the description

**ExtensionItem.cfc**

Method | Description
------------ | -------------
init(string: type, string: name, string: value, boolean: selected, string: label, string: description): ExtensionItem | Initializes the ExtensionItem CFC. Is called on creation.
createOption(string: value, boolean: selected, string: label, string: description): ExtensionOption | Creates and links a new option.
getOptions(): ExtensionOption[] | Returns all ExtensionOptions of the ExtensionItem.
getType(): string | Returns the type of the Item. Valid values are: <ul><li>text</li><li>radio</li><li>checkbox</li><li>checkbox</li><li>hidden</li><li>password</li></ul>
getName(): string | Returns the name of the item
getValue(): string | Returns the value of the item
getSelected(): boolean | Returns whether the item is selected or not. Can be used when type is: select,radio,checkbox
getLabel(): string | Returns the label of the item
getDescription(): string | Returns the description of the item
setType(string: type): void | Sets the type of the item. Valid values are:<ul><li>text</li><li>radio</li><li>checkbox</li><li>checkbox</li><li>hidden</li><li>password</li></ul>
setValue(string: value): void | Sets the value
setSelected(boolean: selected): void | 	Sets whether a certain option should be selected or not.
setLabel(string: label): void | Sets the label
setDescription(string: label): void | Sets the description

**ExtensionOption.cfc**

Method | Description
------------ | -------------
init(string: type, string: name, string: value, boolean: selected, string: label, string: description): ExtensionItem | Initializes the ExtensionOption CFC. Is called on creation.
getValue(): string | Returns the value of the item
getSelected(): boolean | Returns whether the item is selected or not.
getLabel(): string | Returns the label of the item
getDescription(): string | Returns the description of the item
setType(string: type): void | Sets the value of the option
setValue(string: value): void | Sets the value
setSelected(boolean: selected): void | 	Sets whether a certain option should be selected or not.
setLabel(string: label): void | Sets the label
setDescription(string: label): void | Sets the description
