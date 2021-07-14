Assume the following folder structure:

```
homefolder
\___ luceecode
    \___ contractpath
    |   \___ example.cfm
    \___ otherdirectory
        \___ example.cfm
```

And assume the following mappings:

  * /contractdemo = /homefolder/luceecode/contractpath
  * /luceestuff = /homefolder/luceecode

```luceescript
writeOutput( expandPath('example.cfm') );
// Outputs: /homefolder/luceecode/contractpath/example.cfm

writeOutput( contractPath( expandPath('example.cfm') ) );
// Outputs: /contractdemo/example.cfm

writeOutput( contractPath( expandPath('../otherdirectory/example.cfm') ) );
// Outputs: /luceestuff/otherdirectory/example.cfm

writeOutput( contractPath( expandPath('../../'), true ) );
// Outputs: /{home-directory}
```
