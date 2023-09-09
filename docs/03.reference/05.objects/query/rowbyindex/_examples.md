```lucee+trycf
<cfscript>
    q_tag = queryNew("tag,id")
    tags = getTagList();
    loop collection="#tags.cf#" item="tag" {
        res = queryAddRow(q_tag);
        QuerySetCell(q_tag, "tag", tag, res);
        QuerySetCell(q_tag, "id", res, res);
    }
</cfscript>

<cfquery name="q_tags_indexed" indexName="tag" dbtype="query">
    select * from q_tag;
</cfquery>

<cfscript>
    writeDump(q_tags_indexed.rowByIndex("tag",5));
</cfscript>
```