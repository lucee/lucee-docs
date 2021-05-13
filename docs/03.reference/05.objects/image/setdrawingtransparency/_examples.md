
```luceescript+trycf
	TextCharacteristics = { size="17", style="bold", strikethrough="false", underline="false"};
	imgObj = imageNew("",152,152,"rgb","149c82");
	imgObj.setDrawingTransparency(75);
	imgObj.drawText("Lucee",20,70,TextCharacteristics);
	imgObj.setDrawingTransparency(50);
	imgObj.drawText("Lucee",70,20,TextCharacteristics);
	imgObj.setDrawingTransparency(30);
	imgObj.drawText("Lucee",70,30,TextCharacteristics);
	cfimage(action="writeToBrowser", source=imgObj);
```
