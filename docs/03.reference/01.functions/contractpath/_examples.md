Assume the following folder structure:
```
/homefolder
    /luceecode
        /contractpath
            /example.cfm
        /otherdirectory
            /example.cfm
```

And assume the following mappings:

  * /contractdemo = /homefolder/luceecode/contractpath
  * /luceestuff = /homefolder/luceecode


```luceescript
<cfscript>
    writeOutput( expandPath('example.cfm') ); // /homefolder/luceecode/contractpath/example.cfm
    writeOutput( contractPath( expandPath('example.cfm') ) ); // /contractdemo/example.cfm
    writeOutput( contractPath( expandPath('../otherdirectory/example.cfm') ) ); // /luceestuff/otherdirectory/example.cfm
    writeOutput( contractPath( expandPath('../../'), true ) ); // /{home-directory}
</cfscript>

```
