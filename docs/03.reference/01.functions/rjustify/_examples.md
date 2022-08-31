```luceescript+trycf
	writeDump(
		label:"",
		var:RJustify("",4));
	writeDump(
		label:"",
		var:RJustify("abc",1));
	writeDump(
		label:"",
		var:RJustify("abc",5));


    writeoutput("<hr>");
    s = "";
    res = rJustify(s, 4);
    writeDump(len(res)); // length is 4
    writeoutput("<pre>|#res#|</pre><hr>");

    s = "abc";
    res = rJustify(s, 10);
    writeDump(len(res)); // length is 10
    writeoutput("<pre>|#res#|</pre><hr>");

    s = "10";
    res = rJustify(s, 8);
    writeDump(len(res)); // length is 8
    writeoutput("<pre>|#res#|</pre>");

```