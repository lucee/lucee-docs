```luceescript+trycf
   name = "yoyo".ljustify(10);
   writeDump(name);
   writeDump(len(name));
   writeDump(len(trim(name)));
   writeDump(len(ltrim(name)));
   writeDump(len(rtrim(name)));

	writeoutput("<hr>");
    s = "";
    res = s.lJustify(4);
    writeDump(len(res));
    writeoutput("<pre>|#res#|</pre><hr>");

    s = "abc";
    res = s.lJustify(4);
    writeDump(len(res));
    writeoutput("<pre>|#res#|</pre><hr>");

    s = "10";
    res = s.lJustify(4);
    writeDump(len(res));
    writeoutput("<pre>|#res#|</pre>");

```