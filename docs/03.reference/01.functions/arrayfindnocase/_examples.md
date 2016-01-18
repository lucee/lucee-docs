```luceescript+trycf
arrVariable = [ "Water", "Sky", 2, "Air" ];

WriteDump( ArrayFindNoCase( arrVariable, 5 ) ); // Outputs 0

WriteDump( ArrayFindNoCase( arrVariable, "air" ) ); // Outputs 4

WriteDump( ArrayFindNoCase( arrVariable, 2 ) ); // Outputs 3
```
