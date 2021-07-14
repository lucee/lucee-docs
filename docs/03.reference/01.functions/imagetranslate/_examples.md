```luceescript+trycf
  imgObj = imageNew("",152,152,"rgb","149c82");
  imgObj.translate(10,10);
  imgObj.drawRect(40,50,70,50,"yes");
  cfimage(action="writeToBrowser", source=imgObj);
```
