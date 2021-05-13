```luceescript+trycf
  TextCharacteristics = { size="20", style="bold", strikethrough="false", underline="false"};
  imgObj = imageNew("",152,152,"rgb","149c82");
  imgObj.setDrawingTransparency(50);
  imgObj.drawText("Lucee",20,50,TextCharacteristics);
  cfimage(action="writeToBrowser", source=imgObj);
```
