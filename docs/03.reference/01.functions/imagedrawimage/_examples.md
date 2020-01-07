```lucee+trycf
	imgOne=imageNew("",100,100,"RGB","blue");
	imgTwo=imageNew("",50,50,"RGB","green");
	imagedrawImage(imgOne,imgTwo,25,45);
	cfimage(action="writeToBrowser",source=imgOne);
```
