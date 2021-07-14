### Simple format for cfzip

### Action unzip

```lucee
<cfzip action="unzip" destination="#gettempdirectory()#" file="zippath">
```

### Action delete

```lucee
<cfzip action="delete" file="#expandpath('./list.zip')#" entrypath="list/hai">
```

### Action zip

```lucee
<cfzip action="zip" source="#expandpath('./ziptest.txt')#" file="#expandpath("'./zip/')#">
```

### Action list

```lucee
<cfzip action="list" file="#expandpath('./list.zip')#" name="res">
```
