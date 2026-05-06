`<cfswitch>`/`<cfcase>` does **not** fall through — once a case body finishes, the switch exits. There is no need (and no way) for `<cfbreak>` to "break the switch."

If you place `<cfbreak>` inside a `<cfcase>` that sits inside a `<cfloop>` or `<cfwhile>`, the break hoists past the implicit case-end and terminates the **enclosing loop**:

```luceescript+trycf
<cfloop from="1" to="3" index="i">
    <cfswitch expression="#i#">
        <cfcase value="2">
            <cfoutput>hit two </cfoutput>
            <cfbreak>
        </cfcase>
        <cfdefaultcase>
            <cfoutput>i=#i# </cfoutput>
        </cfdefaultcase>
    </cfswitch>
</cfloop>
<!-- i=1 hit two -->
```

The loop never reaches `i=3` because `<cfbreak>` exits the loop, not the switch.

This differs from script `break;`, which follows C-style semantics — script `case` blocks fall through by default and `break;` exits the switch only, leaving the surrounding loop running.

| Construct | Case fall-through | What `break` exits |
| --- | --- | --- |
| `<cfswitch>` / `<cfcase>` | no (implicit case-end) | the enclosing `<cfloop>` / `<cfwhile>` |
| `switch` / `case` (script) | yes | the switch |

Mixing the two mental models is the usual footgun: a `<cfbreak>` added defensively inside a `<cfcase>` will silently cut an outer loop short, with no error or warning.
