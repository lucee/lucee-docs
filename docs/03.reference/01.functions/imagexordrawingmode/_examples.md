### Function Example
```luceescript+trycf
imgObj = imageNew("",152,152,"rgb","149c82");
imageXORDrawingMode(imgObj,"dddddd");
imagesetDrawingColor(imgObj,"white");
imagedrawRect(imgObj,50,50,50,50,"yes");
for (i=1;i LTE 100;i=i+1) {
    x = randRange(0,152);
    y = randRange(0,152);
    imagedrawPoint(imgObj,x,y);
}
cfimage(action="writeToBrowser", source=imgObj);
```