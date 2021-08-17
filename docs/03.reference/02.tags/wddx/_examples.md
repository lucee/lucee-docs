To use this tag in cfscript:
```
<cfscript>
  // This WDDX packet contains a struct with 4 keys: 3 strings and 1 array of numbers
  strWDDX = "<wddxPacket version='1.0'><header/><data><struct><var name='VERSION'><string>1.0.0</string></var><var name='COUNTDOWNARRAY'><array length='5'><number>5.0</number><number>4.0</number><number>3.0</number><number>2.0</number><number>1.0</number></array></var><var name='NAME'><string>Test Struct</string></var><var name='DESCRIPTION'><string>To illustrate serializing to WDDX</string></var></struct></data></wddxPacket>";
  
  wddx action='wddx2cfml' input=strWDDX output='example';
  
  dump(example);
</cfscript>
```
