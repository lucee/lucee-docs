The following statements evaluate to `true`:

```luceescript
IsBoolean( true );
IsBoolean( false );
IsBoolean( 0 );
IsBoolean( -10.4 );
IsBoolean( 3.6 );
IsBoolean( "yes" );
IsBoolean( "no" );
IsBoolean( "true" );
IsBoolean( "false" );
IsBoolean( "0" );
IsBoolean( "-10.4" );
IsBoolean( "3.6" );
```

The following statements evaluate to `false`:

```luceescript
IsBoolean( Now() );
IsBoolean( {} );
IsBoolean( [] );
IsBoolean( QueryNew('') );
IsBoolean( "" );
IsBoolean( "a string" );
```