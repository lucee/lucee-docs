---
title: The Lucee dialect
id: lucee-5-dialect-lucee
---
# New Language dialect Lucee #

**In addition to the existing "CFML" language dialect, Lucee 5 comes with a completely new dialect simply called "Lucee".**

The Lucee dialect is a light-weight dynamic scripting and tag language for the JVM that enables the rapid development of simple to highly sophisticated web applications.

## We love CFML ##

Lucee has its roots in the ColdFusion Markup Language (CFML). Continuing to support CFML and making improvements in CFML compatibility will remain the highest priority.

Lucee will continue to support CFML and you can continue to build CFML applications that run on Lucee. “Supporting CFML” means providing compatibility to Adobe ColdFusion (ACF) and the Lucee Association Switzerland (LAS) are committed to the following:

* If you find a compatibility issue between Lucee’s CFML implementation and ACF please raise a bug report and it will be reviewed and responded to.
* If Adobe develops something new that is seen as a popular enhancement then Lucee will add it to the roadmap, features with the most interest are added as a matter of priority.
* CFML applications will continue to run on Lucee.

Lucee, like Railo before it, has been trying to propel the CFML language forward. However, the more we advance the language the more we muddy the water of what CFML is.

Lucee Association Switzerland (LAS) wants to support Adobe CFML as well as possible, and at the same time be free to develop a modern language that delivers the features our community wants.

## The Lucee dialect ##

The Lucee dialect is a modern language based on the original concepts of CFML. It is completely open source and exposes the most advanced features of the underlying JVM with performance, class loading, OSGi and JSR-223 support at its core. The Lucee language will continue to evolve to meet the ever increasing demands of modern web application development.

The Lucee language is LAS’s opportunity to evolve a modern dialect that is both familiar to existing CF developers while providing the freedom to grow in a more ambitious direction and LAS are committed to this as much as they are to supporting the CFML development community.

## So what changes for me? ##

If you are happy to stick with CFML then nothing changes for you. If, however, you want to expand your possibilities going forward and are happy to embrace the new language then you will have the ability to take advantage of the new features the Lucee language will offer.

## How do I use it? ##

Dialects are controlled by the file extension, to use the classic "CFML" dialect simply use the file extension `.cfc` or `.cfm` and to use the new "Lucee" dialect simply use the file extension `.lucee` for both templates and components.

You can also mix the "Lucee" dialect with the "CFML" dialect, so you can for example include a Lucee template in your CFML template or call a Lucee component from your CFML template ...

## What does this look like? ##

Let's do some examples to get a feeling for the syntax.

Tag based template with a script island:

```lucee
<:script>
  mail=evaluate(url.mail);
</:script>
<:if hasMail>
  <:mail subject=mail.subject from=mail.from to=mail.to>
    <:output>#mail.body#</:output>
  </:mail>
</:if>
```

## How does it act? ##

As you can see above the syntax is not that different to CFML, the real difference is with the environment.

Let's take a look into some details, of course this does not cover everything, a complete overview of the language in detail will follow ASAP.

#### Full Null Support ####

The Lucee dialect has full null support, so the following is possible:

```luceescript
test=null;
// some code here that maybe change "test"
if(test==null)
  dump(test);
```

#### Local Scope ####

Inside a function if the scope has not been defined for a variable then the nearest scope is used, so in the following that would be the "local" scope and not the "variables" scope that the CFML dialect would use.

```luceescript
function test(){
  test=1; // sets "test" to the local scope
  variables.whatever=2; // sets "whatever" to the variables scope.
}
```

#### This Scope ####

The CFML dialect has 2 instance scopes for components `this` and `variables` and the scopes are completely separated. The Lucee dialect only has one scope, the `this` scope that can still be accessed with `variables`.

In the CFML dialect variables in the `this` scope are accessible from outside (public) which breaks encapsulation, in the Lucee dialect the `this` scope is private for variables by default.

#### Scope Cascading ####

In the CFML dialect if you call a variable, for example `#susi#`, the engine will look for "susi" in the following scopes [local,arguments,variables,cgi,url,form,cookie] however in the Lucee dialect it only checks the following scopes [local,arguments,variables].

```luceescript
 url.susi="Susanne";
 form.susi="Sorglos";
 dump(susi); // works in CFML, but fails in Lucee
```

#### Tag Attributes ####

In the CFML dialect if an attribute value is defined without (single or double) quotes, it is handled as a String, in the Lucee dialect the same is handled as a variable.

Take this example

```lucee
<cfmail subject=mail.subject from=mail.from to=mail.to>
</cfmail>
```

In CFML this is handled the same way as this

```lucee
<cfmail subject="mail.subject" from="mail.from" to="mail.to">
</cfmail>
```

and in Lucee this is handled the same way as this

```luceescript
<:mail subject="#mail.subject#" from="#mail.from#" to="#mail.to#">
</:mail>
```

**This is just a first peek of what is possible with the Lucee dialect, more will come soon!**
