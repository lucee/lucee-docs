<!--
{
  "title": "Tag Islands",
  "id": "tag-islands",
  "description": "Tag islands allow you to switch into tag mode from inside cfscript",
  "keywords": [
  ],
  "categories": [
  
  ],
  "related": [
    "tag-script",
    "tags"
  ]
}
-->

## Tag Islands

Tag Islands allows you to switch to tag mode, i.e. like a `.cfm` file, from within [[tag-script]]

Simply use three backticks to switch into tag mode and then again to exit tag mode, like a code block in markdown.

Great for refactoring old code, or just when you need to do some quick tag style code.

Unfortunately, currently the docs markdown / wiki support doesn't quite allow escaping them for an example.

```cfml
<cfscript>
  access_level = 1;
  
  // three backticks to start
  <cfquery name="q">
    select name 
    from  users 
    where acess_level = <cfqueryparam value="#access_level#" type="integer"/>
  </cfquery>

  // three backticks to close
  loop query="q" {
    echo( q.name );
  }

</cfscript>
```
