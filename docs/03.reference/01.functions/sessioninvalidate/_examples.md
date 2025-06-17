Application.cfc

```cfml
component  {

    this.name="sessionInvalidate" ;
    this.sessionManagement = true ;
  
}
```

session.cfm

```cfml
session.User = "lucee"
writeDump(session);
<a href="sessionInvalidate.cfm">Invalidate Session</a>
```

sessionInvalidate.cfm

```cfml
invalidate = sessionInvalidate();
writeDump(session)
<a href="session.cfm">session</a>
```