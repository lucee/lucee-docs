---
title: Mail Listeners
id: cookbook-mail-listeners
related:
- tag-application
- tag-mail
categories:
- application
description: Mail Listeners can be configured to fire before and after sending an email.
---

# Mail Listeners in Lucee

Mail Listeners can be configured to triggered before and after sending mails (only for mail sending as async).

These follow the same pattern as [[cookbook-query-listeners]]

This is available as an experimental feature in Lucee 5.3 and is officially supported in Lucee 6.0.

>>>**Note:** Mail listener only triggered when the mail sending as **async (spool enable)**.

It can be configured:

- application wide, via [[tag-application]] i.e. `Application.cfc`
- per [[tag-mail]] tag (listeners defined in listener attribute overwrites any mail listener defined in the [[tag-application]])

You can change the arguments (content) of an email in via the `before` listener method, by returning a modified arguments struct, which has the following keys:

- from 
- to, 
- bcc 
- replyTo 
- failTo 
- subject (ex: <code>{from:"modified@lucee.org" 
- to:"modifiedto@lucee.org"}</code>)

A Mail Listener is a component with two methods, `before()` and `after()`. You can have other methods in your listener component, but Lucee will only call these two.

Also Mail listener can be a struct (that has a keys before/after with closures as value) OR closure (that triggered after the sending mails).

```luceescript
this.mail.listener = {
	before = function () {
		return arguments;
	}
	,after = function () {
		if (structKeyExists(arguments,"exception")) {
			writelog(text:"Sending mail failed, from:#arguments.detail.from# to:#arguments.detail.to# 
			with message:#arguments.exception.message# ", file:"mailFailed.log");
           	 }
	}
};

OR

this.mail.listener = function () {
	if (structKeyExists(arguments,"exception")) {
		writelog(text:"Sending mail failed, from:#arguments.detail.from# to:#arguments.detail.to# 
		with message:#arguments.exception.message# ", file:"mailFailed.log");
	}
};
```

## Examples

i.e. `MailListener.cfc`

```luceescript
<cfscript>
component {

	function before() {
		// modified the from and to mails
		return {from:"modified@testlucee.org", to:"modifiedto@testlucee.org"};
	}

	function after() { 
		return arguments;
	}
}
</cfscript>
```

To add an Application wide Mail listener, add the following to your `Application.cfc`:

```luceescript
this.mail.listener = new MailListener();
```

To add a Mail listener to an individual [[tag-mail]] tag (listeners defined in the listener attribute overwrites any mail listener defined in the [[tag-application]]:

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

You can see the `from` and `to` mail ids were changed in the arguments to the `after` function, the args struct contains the modified `from` and `to` keys from the `before` function:

<img alt="Mail Listener After()" src="/assets/images/listeners/MailListener_after_arguments.png">
