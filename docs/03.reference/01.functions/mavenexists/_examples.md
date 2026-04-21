Gradle-style coordinate, specific version:

```luceescript
mavenExists( "org.apache.poi:poi-ooxml:5.2.5" );
```

Three-argument form:

```luceescript
mavenExists( "org.apache.poi", "poi-ooxml", "5.2.5" );
```

Any version of the coord is cached:

```luceescript
mavenExists( "org.apache.poi:poi-ooxml" );
// or
mavenExists( "org.apache.poi", "poi-ooxml" );
```