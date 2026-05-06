`<cfcase>` does **not** fall through to the next case. When a case body finishes, the `<cfswitch>` exits — there is no implicit fall-through and no explicit break is needed.

A `<cfbreak>` written inside a `<cfcase>` is therefore redundant for ending the case, and is a common footgun: if the `<cfswitch>` sits inside a `<cfloop>` or `<cfwhile>`, the `<cfbreak>` will exit that enclosing loop instead. See [[tag-break]] for details.

This differs from script `case`, which follows C-style fall-through semantics where `break;` is required to stop after a match.
