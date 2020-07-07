### Function Example

```luceescript+trycf
img = imageRead('https://avatars1.githubusercontent.com/u/10973141?s=280&v=4')
	writeDump(imageGetEXIFTag(img,'width'));
	writeDump(imageGetEXIFTag(img,'height'));
```