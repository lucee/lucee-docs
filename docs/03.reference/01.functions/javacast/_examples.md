```luceescript+trycf
// Convert a ColdFusion Number to a Java double primitive
// Converts the number 180.0 degrees to radians using Java method: Math.toRadians(double degrees)
writeDump( createObject("java", "java.lang.Math").toRadians( javacast("double", 180.0) ) );
```
