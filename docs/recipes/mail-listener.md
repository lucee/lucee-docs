<!--
{
  "title": "Mail Listeners",
  "id": "mail-listeners",
  "since": "6.0",
  "description": "Learn how to define mail listeners in Lucee. This guide demonstrates how to set up global mail listeners in the Application.cfc file to listen to or manipulate every mail executed. Examples include defining listeners directly in Application.cfc and using a component as a mail listener.",
  "keywords": [
    "mail",
    "listener",
    "Application.cfc",
    "component"
  ],
  "related": [
    "tag-mail",
    "tag-application"
  ],
  "categories": [
    "protocols"
  ]
}
-->

# Mail Listeners

Define listeners in Application.cfc to intercept or manipulate every mail sent.

### Global per Application.cfc Listeners

```lucee
this.mail.listener = {
    before: function (caller, nextExecution, created, detail, closed, advanced, tries, id, type, remainingtries) {
        detail.from &= ".de";
        return arguments.detail;
    },
    after: function (caller, created, detail, closed, lastExecution, advanced, tries, id, type, passed, remainingtries) {
        systemOutput(arguments.keyList(), 1, 1);
    }
}
```

The listener can also be a component:

```lucee
this.mail.listener = new MailListener();
```

The component would look like this:

```lucee
component {
    function before(caller, nextExecution, created, detail, closed, advanced, tries, id, type, remainingtries) {
        detail.from &= ".de";
        return arguments.detail;
    }

    function after(caller, created, detail, closed, lastExecution, advanced, tries, id, type, passed, remainingtries) {
        systemOutput(arguments.keyList(), 1, 1);
    }
}
```

### Per tag Listeners

To add a Mail Listener to an individual [[tag-mail]] tag (listeners defined in the listener attribute overwrites any mail listener defined in the [[tag-application]]:

```luceescript
<cfset listener = new MailListener()>
<cfmail from="testlistener@testlucee.org" to="testlistener@testlucee.org" server="stmp.testlucee.org" port="25" 
	username="testlistener@testlucee.org" password="***********" subject="Test listener" listener="#listener#">
	test listener mail body
</cfmail>
```

### Dump of arguments to the Mail Listener before() method

<img alt="Mail Listener Before()" src="/assets/images/listeners/MailListener_before_arguments.png">

### Dump of arguments to the Mail Listener after() method (cfmail)

You can see the `from` and `to` mail IDs were changed in the arguments to the `after` function, the arguments struct contains the modified `from` and `to` keys from the `before` function.

<img alt="Mail Listener After()" src="/assets/images/listeners/MailListener_after_arguments.png">
