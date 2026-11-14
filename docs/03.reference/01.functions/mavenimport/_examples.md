Rehydrate a cache from a committed pom:

```luceescript
q = mavenImport( "/app/pom.xml" );
systemOutput( "Resolved " & q.recordcount & " dependencies", true );
```

Literal mode (default) — only the coords listed in the pom, no transitive walk — round-trips exactly against [[function-mavenExport]]:

```luceescript
fileWrite( "/tmp/pom.xml", mavenExport() );
// ... elsewhere, fresh install ...
mavenImport( "/tmp/pom.xml" );
```

Transitive mode — resolve each entry's full dependency tree, same as [[function-mavenLoad]]:

```luceescript
q = mavenImport( "/app/top-level-deps.xml", includeTransitive=true );
```

Inspect what was resolved:

```luceescript
q = mavenImport( "/app/pom.xml" );
loop query=q {
    systemOutput( q.groupId & ":" & q.artifactId & ":" & q.version & " -> " & q.path, true );
}
```
