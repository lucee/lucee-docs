```luceescript+trycf
myImg = imageNew("",300,200,"rgb","eccc68");
imageSetDrawingColor(myImg,"009432");//All subsequent graphics operations use the specified color.
ImageDrawLine(myImg,0,0,300,200)
ImageDrawText(myImg,"Plant green,",10,90)
ImageDrawText(myImg,"Save world!",180,100)
cfimage(action="writeToBrowser", source=myImg);
```