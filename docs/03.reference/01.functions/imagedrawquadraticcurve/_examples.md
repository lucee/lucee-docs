```luceescript+trycf
img=imageNew("",100,100,"RGB","a29bfe");
ImageDrawQuadraticCurve(img,0,80,50,0,75,20);
cfimage(action="writeToBrowser",source=img);
```