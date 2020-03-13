###Tag Syntax

###Image Write
```lucee
<cfset newImg = imageNew("",200,200,"rgb","blue")>
<cfimage action="write" source="#newImg#" name="writeimg" destination="pathname" overwrite="true">
```
###Image captcha
```lucee
<cfimage action="captcha" text="Captcha!"  difficulty="low" height="30" width="150" fontSize="18" 
fonts="Comic Sans MS,Times New Roman">
```
###Image read
```lucee
<cfimage action="read" name="sourceImage" source="https://avatars1.githubusercontent.com/u/10973141?s=280&v=4">
<cfdump var="#sourceImage#" />
```
###Image Info
```lucee
<cfimage action="info" structname="sourceImage" source="https://avatars1.githubusercontent.com/u/10973141?s=280&v=4">
<cfdump var="#sourceImage#" />

```
###Image convert
```lucee
<cfimage action="convert" structname="sourceImage" destination="#expandpath("./lii.jpeg")#" 
source="https://avatars1.githubusercontent.com/u/10973141?s=280&v=4">
<cfimage action="writeToBrowser" source="#expandpath("./lii.jpeg")#">
```
###Image WriteToBrowser
```lucee
<cfimage action="writeToBrowser" source="https://avatars1.githubusercontent.com/u/10973141?s=280&v=4">
```
###Image Rotate
```lucee
<cfimage action="rotate" source="https://avatars1.githubusercontent.com/u/10973141?s=280&v=4" 
destination="#expandPath( 'rotated.jpg' )#" overwrite="true" angle="30" quality="1">
<cfimage action="writeToBrowser" source="#expandpath("./rotated.jpg")#">
```
###Image Resize
```lucee
<cfimage action="resize" source="https://avatars1.githubusercontent.com/u/10973141?s=280&v=4" 
name="resize" overwrite="true" height="300" width="400" quality="1">
<cfimage action="writeToBrowser" source="#resize#">

```
###Image border
```lucee
<cfimage action="border" source="https://avatars1.githubusercontent.com/u/10973141?s=280&v=4" color="red" 
name="withborder">
<cfimage action="writeToBrowser" source="#withborder#">
```
###Script Syntax

### Image write
```luceescript
 newImg = imageNew("",200,200,"rgb","blue");
cfimage(action="write", source="#newImg#", name="writeimg", destination="pathname", overwrite="true");
```
### Image Captcha
```luceescript
cfimage(action="captcha",text="Captcha!", difficulty="low",height="30",width="150",fontSize="18",
fonts="Comic Sans MS,Times New Roman");
```
### Image Read
```luceescript
cfimage(action="read",name="sourceImage",source="https://avatars1.githubusercontent.com/u/10973141?s=280&v=4")
writeDump(sourceImage);
```
### Image Info
```luceescript
cfimage(action="info",structname="sourceImage",source="https://avatars1.githubusercontent.com/u/10973141?s=280&v=4")
writeDump(sourceImage);
```
### Image Convert
```luceescript
cfimage(action="convert",structname="sourceImage",destination="#expandpath("./lii.jpeg")#",
source="https://avatars1.githubusercontent.com/u/10973141?s=280&v=4" overwrite="true")
cfimage(action="writeToBrowser",source="#expandpath("./lii.jpeg")#")
```
### Image WriteToBrowser
```luceescript
cfimage(action="writeToBrowser",source="https://avatars1.githubusercontent.com/u/10973141?s=280&v=4")
```
### Image Rotate
```luceescript
cfimage(action="rotate",source="https://avatars1.githubusercontent.com/u/10973141?s=280&v=4",
destination="#expandPath( 'rotated.jpg' )#",overwrite="true",angle="30",quality="1")
cfimage(action="writeToBrowser",source="#expandpath("./rotated.jpg")#")
```

### Image Resize
```luceescript
cfimage(action="resize",source="https://avatars1.githubusercontent.com/u/10973141?s=280&v=4",name="resize",
overwrite="true",height="300",width="400",quality="1")
cfimage(action="writeToBrowser",source="#resize#")
```
###Image border

```luceescript
cfimage(action="border" source="https://avatars1.githubusercontent.com/u/10973141?s=280&v=4" color="red" name="withborder");
cfimage(action="writeToBrowser" source="#withborder#");

```