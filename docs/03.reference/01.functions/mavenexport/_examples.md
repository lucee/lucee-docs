Get the pom XML as a string:

```luceescript
pomXml = mavenExport();
dump( parseXml( pomXml ), true );
```

Write the snapshot to disk:

```luceescript
fileWrite( "/app/pom.xml", mavenExport() );
```

Snapshot after loading known-good dependencies — commit the pom, rehydrate elsewhere with [[function-mavenImport]]:

```luceescript
mavenLoad( "org.apache.poi:poi-ooxml:5.2.5" );
mavenLoad( "com.google.guava:guava:32.1.3-jre" );
fileWrite( "/app/mvn-cache.xml", mavenExport() );
```

Audit what's in an environment's cache (count distinct coords):

```luceescript
pom = xmlParse( mavenExport() );
count = arrayLen( xmlSearch( pom, "//*[ local-name()='dependency' ]" ) );
echo( "Cached deps: " & count, true );
```
