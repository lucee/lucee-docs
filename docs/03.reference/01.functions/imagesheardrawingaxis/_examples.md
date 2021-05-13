```luceescript+trycf
  imgObj = imageNew("",152,152,"rgb","149c82");
  imgObj.shearDrawingAxis(0.5,0.5);
  imgObj.drawRect(40,50,70,50,"yes");
  cfimage(action="writeToBrowser", source=imgObj);
```
