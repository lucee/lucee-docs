```luceescript+trycf
	imgObj = imageNew("",200,200,"rgb","red");
	imgObj.rotate(50,50,60,"bilinear");
	cfimage(action = "writeToBrowser",source = imgObj);
	writeoutput("<br><br>");
	img1 = imageNew("",100,100,"RGB","blue");
	img1.rotate(60,40,120);
	cfimage(action = "writeToBrowser",source = img1);
```
