```luceescript+trycf
	img=imageNew("", 250, 250, "RGB", "a29bfe");

	imagesetDrawingAlpha(img ,0.3);
	imagedrawRect(img, 50,  50, 50, 50);

	imagesetDrawingAlpha(img ,0.6);
	imagedrawRect(img, 75, 75, 75, 75);

	imagesetDrawingAlpha(img ,1);
	imagedrawRect(img, 100, 100, 100, 100);

	writeOutput(img);
```