```luceescript+trycf
	img=imageNew("", 250, 250, "RGB", "a29bfe");

	img.setDrawingAlpha(0.3);
	img.drawRect(50, 50, 50, 50);

	img.setDrawingAlpha(0.6);
	img.drawRect(75, 75, 75, 75);

	img.setDrawingAlpha(1);
	img.drawRect(100, 100, 100, 100);

	writeOutput(img);
```