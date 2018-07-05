```luceescript+trycf
	enc=ESAPIDecode("html","&lt;table&gt;");//html
	writeDump(enc);//<table>
	enc=encodeForURL('http://download.lucee.org/?type=releases');//URL
	writeDump(enc);
	dec=ESAPIdecode('url','http%3A%2F%2Fdownload.lucee.org%2F%3Ftype%3Dreleases');
	writeDump(dec);//http://download.lucee.org/?type=releases
```