```luceescript+trycf
    name = "yoyo".rjustify(10);
    writeDump(name);
    writeDump(len(name));
    writeDump(len(trim(name)));
    writeDump(len(ltrim(name)));
    writeDump(len(rtrim(name)));

    writeoutput("<hr>");
    s = "";
    res = s.rJustify(4);
    writeDump(len(res)); // length is 4
    writeoutput("<pre>|#res#|</pre><hr>");

    s = "abc";
    res = s.rJustify(10);
    writeDump(len(res)); // length is 10
    writeoutput("<pre>|#res#|</pre><hr>");

    s = "10";
    res = s.rJustify(8);
    writeDump(len(res)); // length is 8
    writeoutput("<pre>|#res#|</pre>");

```