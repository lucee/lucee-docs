`<cfcase>` blocks do **not** fall through. Once a matching case body finishes, the switch exits — there is no implicit fall-through to the next case and no need for an explicit break.

This differs from script `switch`/`case`, which follows C-style fall-through semantics where `break;` is required to stop after a match.

A consequence: `<cfbreak>` placed inside a `<cfcase>` does **not** "break the switch" (the switch is already exiting). If the switch sits inside a `<cfloop>` or `<cfwhile>`, the `<cfbreak>` will exit that enclosing loop instead. See [[tag-break]] for details.
