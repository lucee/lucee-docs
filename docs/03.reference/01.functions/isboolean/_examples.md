### The following statements evaluate to `true`:

```luceescript+trycf
    writeDump(IsBoolean( true ));
    writeDump(IsBoolean( false ));
    writeDump(IsBoolean( 0 ));
    writeDump(IsBoolean( -10.4 ));
    writeDump(IsBoolean( 3.6 ));
    writeDump(IsBoolean( "yes" ));
    writeDump(IsBoolean( "no" ));
    writeDump(IsBoolean( "true" ));
    writeDump(IsBoolean( "false" ));
    writeDump(IsBoolean( "0" ));
    writeDump(IsBoolean( "-10.4" ));
    writeDump(IsBoolean( "3.6" ));
```

### The following statements evaluate to `false`:

```luceescript+trycf
    writeDump(IsBoolean( Now() ));
    writeDump(IsBoolean( {} ));
    writeDump(IsBoolean( [] ));
    writeDump(IsBoolean( QueryNew('') ));
    writeDump(IsBoolean( "" ));
    writeDump(IsBoolean( "a string" ));

```
