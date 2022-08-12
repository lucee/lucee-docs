
```luceescript+trycf
	s = "";
    res = lJustify(s, 4);
    writeDump(len(res)); // length is 4
    writeoutput("<pre>|#res#|</pre><hr>");

    s = "abc";
    res = lJustify(s, 10);
    writeDump(len(res)); // length is 10
    writeoutput("<pre>|#res#|</pre><hr>");

    s = "10";
    res = lJustify(s, 8);
    writeDump(len(res)); // length is 8
    writeoutput("<pre>|#res#|</pre>");

```