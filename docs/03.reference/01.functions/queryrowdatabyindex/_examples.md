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
    select * from q_tag
</cfquery>

<cfscript>
    //dump(q_tags_indexed);
	dump(queryRowByIndex(q_tags_indexed, "query", -1));
	def = {tag:"unknown", id:"-1"};
	dump(queryRowDataByIndex(q_tags_indexed, "query", def));
	    dump(queryGetCellByIndex(q_tags_indexed, "query", "id", -1));
</cfscript>


```
