---
title: Tag Islands
id: tag-islands
---

## Tag Islands ##

Tag Islands let you switch back to using CFML Tag syntax, from inside [[tag-script]] or inside script based [[tag-component]]

To switch into Tag Islands, just wrap your CFML Tag code with three backticks [```].

This can be useful in a range of situations

- Generating HTML inside a function, 
- If you prefer using the [[tag-query]] [[tag-queryparam]] syntax

```luceescript+trycf
    // alas, trycf doesn't handle this syntax yet
    q = queryNew(
        "id,name", 
        "numeric,varchar", 
        { 
            id: [1,2,3], 
            name: ['Neo','Trinity','Morpheus'] 
        } 
    );
    \`\`\`
    <cfquery name="q_neo" dbtype="query">
        select id, name
        from q
        where name= <cfqueryparam value='Neo' sqltype='varchar'>
    </cfquery>
    \`\`\`
    dump(q_neo);
```

### Further Reading

- [Exploring Tag Islands (Tags In CFScript) In Lucee CFML 5.3.1.13](https://www.bennadel.com/blog/3768-exploring-tag-islands-tags-in-cfscript-in-lucee-cfml-5-3-1-13.htm)
- [add tag island in script](https://luceeserver.atlassian.net/browse/LDEV-1324)
