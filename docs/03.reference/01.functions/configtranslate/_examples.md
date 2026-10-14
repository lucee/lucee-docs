```luceescript

//Translate Lucee Server XML configuration to .CFConfig JSON format
configResult = configTranslate(
    source = "C:/lucee_old/tomcat/lucee-server/context/lucee-server.xml.cfm",
    target = "C:/lucee_new/tomcat/lucee-server/context/.CFConfig.json",
    type = "server",
    mode = "single"
);
writeDump(configResult);

```