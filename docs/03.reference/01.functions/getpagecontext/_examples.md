```luceescript+trycf
echo("Click to expand");
    pc = getPageContext();
    dump(var=pc, label="PageContext", expand=false);
    dump(var=pc.getCFMLFactory(), label="CFMLFactory", expand=false);
    dump(var=pc.getCFMLFactory().getEngine(), label="Engine",expand=false);
    if( listFirst(server.lucee.version,".") lte 5)
        dump(var=pc.getCFMLFactory().getConfig(), label="Config",expand=false);
    else
        dump(var=pc.getCFMLFactory().getConfigServer(), label="ConfigServer",expand=false);
    dump(var=pc.getCFMLFactory().getScopeContext(), label="ScopeContext",expand=false);
```