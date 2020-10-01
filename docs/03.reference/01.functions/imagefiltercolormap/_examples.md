```luceescript+trycf
img = imageRead("https://dev.lucee.org/uploads/default/original/2X/6/63711fa0d32b7ebd71a71286b77aa555c8d034fa.jpeg");
filter = "life";
map = ImageFilterColorMap(type="spectrum");
params = {
	colormap: map,
	iterations: 20,
	newColor: "990000",
};
ImageFilter(image = img, filtername = filter, parameters = params);
imageWriteToBrowser(img);
```
