Listener for the mail. the listener can have 2 (optional) functions, "before" and "after" that get triggered before and after sending the mail.

The functions get all data about the mail.

Listener is only used when `async` (spoolEnable) is set to true.

This attribute overwrites any mail listener defined in the `application.cfc/cfapplication`.

The "before" function can also modify some data, by returning a struct containing the following keys:

`[ from, to, bcc, cc, replyTo, failTo, subject, charset]`

the listener can be a component looking like this:

```
component {
    function before( lastExecution, nextExecution, created, id, type, detail,
        tries, remainingTries, closed, caller, advanced ){}
    function after( lastExecution, nextExecution, created, id, type, detail, tries,
        remainingTries, closed, caller, advanced, passed, exception ){}
}
```

a struct looking like this:

`component {before:function(...){}, after:function(...){}}`