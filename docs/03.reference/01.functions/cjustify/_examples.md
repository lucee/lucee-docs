```luceescript+trycf
	string = "A light-weight dynamic scripting language for the JVM.";
	dump(cJustify(string, 5));

	// member function
	dump(string.cJustify(5));

    s = "";
    res = cJustify(s, 4);
    writeDump(len(res)); // length is 4
    writeoutput("<pre>|#res#|</pre><hr>");

    s = "abc";
    res = cJustify(s, 10);
    writeDump(len(res)); // length is 10
    writeoutput("<pre>|#res#|</pre><hr>");

    s = "10";
    res = cJustify(s, 8);
    writeDump(len(res)); // length is 8
    writeoutput("<pre>|#res#|</pre>");

```