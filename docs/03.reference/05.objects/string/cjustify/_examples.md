```luceescript+trycf
	str = cJustify("ColdFusion", 35)
	writeDump(str.len());

	writeoutput("<hr>");
	s = "";
	res = s.cJustify(4);
	writeDump(len(res)); // length is 4
	writeoutput("<pre>|#res#|</pre><hr>");

	s = "abc";
	res = s.cJustify(10);
	writeDump(len(res)); // length is 10
	writeoutput("<pre>|#res#|</pre><hr>");

	s = "10";
	res = s.cJustify(8);
	writeDump(len(res)); // length is 8
	writeoutput("<pre>|#res#|</pre>");

```