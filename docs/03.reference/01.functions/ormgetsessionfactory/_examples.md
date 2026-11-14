```luceescript
factory = ORMGetSessionFactory();

// Inspect entity metadata
meta = factory.getClassMetadata( "User" );
systemOutput( "Properties: #arrayToList( meta.getPropertyNames() )#", true );
systemOutput( "ID property: #meta.getIdentifierPropertyName()#", true );

// Check the active dialect
dialect = factory.getDialect();
systemOutput( "Dialect: #dialect.getClass().getName()#", true );
```
