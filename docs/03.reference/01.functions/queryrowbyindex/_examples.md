```lucee+trycf
<cfscript>
    q_tag = queryNew("tag,id")
    tags = getTagList();
    loop collection="#tags.cf#" item="tag" {
        r = queryAddRow(q_tag);
        QuerySetCell(q_tag,"tag", tag, r);
        QuerySetCell(q_tag,"id", r, r);
    }
</cfscript>
<cfquery name="q_tags_indexed" indexName="tag" dbtype="query">
    select * from q_tag;
</cfquery>

<cfscript>
	dump(queryRowByIndex(q_tags_indexed, "cfquery", -1));
	dump(queryRowDataByIndex(q_tags_indexed, "cfquery", -1));
        dump(queryGetCellByIndex(q_tags_indexed, "id", "cfquery", -1));
</cfscript>
```