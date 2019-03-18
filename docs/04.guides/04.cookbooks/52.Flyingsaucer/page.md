---
title: Flying saucer
id:  flying_saucer
categories:
- pdf
---

This document provides information about the new PDF engine, Flying Saucer (FS) in Lucee 5.3


Flying saucer is a new PDF engine in Lucee. PDF engines are mainly used to convert HTML to PDF format.


### Benefits of moving to FS(Flying Saucer) from the old engine (PD4ML) ###

* Full support for css 2.1,
* On average the generated PDFs are smaller,
* Consume less Memory and CPU,
* Engine in active development,
* Better Results

### Downsides to FS(Flying Saucer) compared to the old engine (PD4ML) ###

* The generated PDF does not always look exactly the same when generated with the new FC compared to files generated with the PD4ML.

If it is important to you that they PDF output looks exactly the same as the old PD4ML-generated file, you will need to check it manually.

If you don't have time to check all PDF outputs, or you really don't care about the fancy new engine, simply add the following code to use the old PDF engine.

In application.cfc,

```luceescript this.pdf.type = "classic";```

If we application.cfm, 

```lucee <cfapplication pdf="#{type:'classic'}#">```

### Features of FS ###

You can define a font directory where you have the fonts(.ttf,.otf) you are using in your PDF.

### Define the font directory ####

<cfdocument fontDirectory = "path/to/my/font">

Define the font directory Application itself:

Use ```luceescript this.pdf.fontDirectory = "path/to/my/font";``` in  Application.cfc,

Use ```lucee<cfapplication pdf="#{fontDirectory	:'path/to/my/font'}#">``` in application.cfm

If font directory is not defined, Lucee checks  WEB_INF/lucee/fonts and uses them if they match.


#### Simplify Attributes ####

Attributes with cfdocument are a mess. You can make it easier to use by doing the following:

Example:
<cfdocument marginTop="5" marginBottom="5" marginLeft="5" marginRight="5" pageWidth="5" pageHeight="5" pageType="A4">

In Lucees you would do the following:

```lucee<cfdocument margin="#{top:5,bottom:5,left:5,right:5}#" page="#{width:5,height:5,type:'A4'}#">```

Or even simpler

```lucee<cfdocument margin="5" page="#{width:5,height:5,type:'A4'}#">```


#### More Units ####

In addition to "inch" and "cm", the attribute unit now supports "pixel" and "points".

<cfdocument unit="in|cm|px|pt">


If you find any issues while using the new PDF engine, please create a bug post in https://dev.lucee.org/ or create a ticket here: https://luceeserver.atlassian.net
We will look into these issues as the highest priority.

### Footnotes ###

You can see the details in this video:
[Flying saucer](https://www.youtube.com/watch?v=B3Yfa8SUKKg)
