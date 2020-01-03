```luceescript+trycf
	img = imageRead("https://avatars1.githubusercontent.com/u/10973141?s=280&v=4");
	img.Flip("antidiagonal");
	cfimage(action = "writeToBrowser",source = img);writeoutput("</br>");
	img = imageRead("https://avatars1.githubusercontent.com/u/10973141?s=280&v=4");
	img.Flip("diagonal");
	cfimage(action = "writeToBrowser",source = img);writeoutput("</br>");
	img = imageRead("https://avatars1.githubusercontent.com/u/10973141?s=280&v=4");
	img.Flip("vertical");
	cfimage(action = "writeToBrowser",source = img);
```