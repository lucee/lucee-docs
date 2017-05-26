---
title: Lucee Server compared with .NET
id: lucee-server-compared-with-dotnet
---
## Structure ##

### ASP.NET aka Webforms ###

* There is no direct equivalent between ASP.NET Webforms and Lucee Server. ASP.NET Webforms offers the capability of managing state between forms, though this approach has fallen out of favour of late, with developers preferring .NET MVC instead.

### .NET MVC ###

* .NET MVC has some parallels with Lucee Server & CFML.

* Controllers and classes written in C# are comparable to CFCs.

* Views, either in .ASPX or Razor, are comparable to CFMs.

## Server ##

* Changes to Lucee Server are made with the Lucee Server administrator. Comparable changes would be made directly into web.config in .NET

## Pros & cons ##


### Pros ###

* CFML enables very fast prototyping.

* CFML typically allows for faster development

* CFML does not have strong typing, which some developers may prefer

* CFML uses a fraction of the amount of code lines .NET does

* CFML simplifies coding by abstracting away many details from developers

* Lucee Server can be extended with Java classes and libraries, whereas .NET can't

* Training staff to use Lucee Server will take a lot less time than .NET

* IDEs and editors can be much simpler

* No need to build as this is done when the code is run for the first time

### Cons of Lucee ###

* CFML does not have strong typing, whereas developers may prefer .NET's strong typing

* Clients may be resistant to change to Lucee Server

* Lucee Server & CFML do not enforce practices whereas .NET does

* CFML may not be as flexible as .NET because options are abstracted away

* IDEs and editors are not as fully featured as .NET environments

* Lucee Server does not support .NET libraries (except via web service calls)