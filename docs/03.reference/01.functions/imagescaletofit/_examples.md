```luceescript+trycf
myImg = imageNew("",400,400,"rgb","70a1ff");
imageScaleToFit(myImg,80,"","hamming");
cfimage(action="writeToBrowser", source=myImg);
```