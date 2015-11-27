---
title: Handling unquoted arguments as variables
id: lucee-5-unquoted-arguments
---

#Handle unquoted tag attribute values as strings#
Unquoted values for tag attributes are handled as strings by default, however with Lucee 5 there is now a setting in the Administrator (under Settings - Language/Compiler) where you can select to handle these values as variables instead.

Take this example:

```lucee
<cfmail subject=subject from=from to=to />
```

With the default setting, this is interpreted as strings, e.g.:

```lucee
<cfmail subject="subject" from="from" to="to" />
```

However when this setting is enabled, it is interpreted as variables, e.g.:

```lucee
<cfmail subject="#subject#" from="#from#" to="#to#" />
```
