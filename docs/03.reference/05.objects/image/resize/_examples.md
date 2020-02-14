```luceescript+trycf
	img=imageNew("",200,200,"RGB","blue");
	cfimage(action="writeToBrowser",source=img);writeoutput("</br>");
	img.resize( "20%","100");
	cfimage(action="writeToBrowser",source=img);writeoutput("</br>");
	img.resize( "20%","75");writeoutput("</br>");
	cfimage(action="writeToBrowser",source=img);
```