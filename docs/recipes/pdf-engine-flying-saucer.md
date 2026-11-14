<!--
{
  "title": "PDF Engine - CFDOCUMENT using Flying Saucer",
  "id": "pdf-engine-flying-saucer",
  "related": [
    "tag-document"
  ],
  "categories": [
    "pdf"
  ],
  "description": "The new CFDOCUMENT PDF engine, Flying Saucer in Lucee 5.3",
  "menuTitle": "The new PDF engine, Flying Saucer in Lucee 5.3",
  "keywords": [
    "Flying Saucer",
    "PDF Engine",
    "CFDOCUMENT",
    "HTML to PDF"
  ]
}
-->

# PDF Engine - Flying Saucer (CFDocument)

[Flying Saucer](https://github.com/flyingsaucerproject/flyingsaucer) is Lucee's modern PDF engine for HTML to PDF conversion (5.3+).

## Benefits of moving to Flying Saucer from the old engine (PD4ML)

- Full support for CSS 2.1
- On average the generated PDFs are smaller
- Consume less Memory and CPU
- Engine in active development,
- Better Results

## Downsides to Flying Saucer compared to the old engine (PD4ML)

- The generated PDF does not always look exactly the same when generated with the new FC compared to files generated with the PD4ML.

If you need exact PD4ML compatibility, use the classic engine:

**Application.cfc:**

```luceescript
this.pdf.type = "classic";
```

**Application.cfm:**

```lucee
<cfapplication pdf="#\{type:'classic'\}#">
```

**Per-document (PDF Extension 1.0.0.92+):**

```lucee
<cfdocument type="modern">
  or
<cfdocument type="classic">
```

## Font Directory

Specify where your fonts (.ttf, .otf) are located:

```lucee
<cfdocument fontDirectory = "path/to/my/font">
```

**Application.cfc:**

```luceescript
this.pdf.fontDirectory = "path/to/my/font";
```

**Application.cfm:**

```lucee
<cfapplication pdf="#\{fontDirectory	:'path/to/my/font'\}#">
```

Default location: `/WEB_INF/lucee/fonts`

**Note**: Classic engine uses font names from `pd4fonts.properties`. Flying Saucer uses font-family-name from the .ttf file (case-sensitive).

### Simplified Attributes

Instead of verbose attributes:

```lucee
<cfdocument marginTop="5" marginBottom="5" marginLeft="5" marginRight="5" pageWidth="5" pageHeight="5" pageType="A4">
```

Use struct syntax:

```lucee
<cfdocument margin="#\{top:5,bottom:5,left:5,right:5\}#" page="#\{width:5,height:5,type:'A4'\}#">
```

Or even simpler (uniform margin):

```lucee
<cfdocument margin="5" page="#\{width:5,height:5,type:'A4'\}#">
```

### Additional Units

Besides "inch" and "cm", now supports "pixel" and "points":

```lucee
<cfdocument unit="in|cm|px|pt">
```

Report issues on the [mailing list](https://dev.lucee.org/). See also: [Flying Saucer video](https://www.youtube.com/watch?v=B3Yfa8SUKKg)
