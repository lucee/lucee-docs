
<!--
{
  "title": "Interacting with Java Libraries",
  "id": "java-libraries",
  "description": "Guide on using Java libraries in Lucee 6.2 with Maven and import",
  "keywords": [
    "java",
    "maven",
    "import",
    "Lucee",
    "libraries",
    "new operator"
  ],
  "categories": [
    "java"
  ],
}
-->

# Interacting with Java Libraries in Lucee 6.2

With Lucee 6.2, one of the main goals was to make Java integration as seamless as possible. This includes easily loading Java libraries and adapting Java code to work within CFML. With a few enhancements, integrating Java into Lucee is now much simpler and more efficient. This recipe will guide you through setting up a simple Java library with Maven, importing Java classes, and interacting with them in Lucee.

## Step 1: Using Maven for Dependencies

Maven allows you to automatically download Java libraries and their dependencies. Lucee 6.2 now supports Maven integration directly, making it much easier to load Java libraries in your code.

Here’s how to include Maven dependencies in a Lucee component:

```cfml
component javasettings='{
        "maven":[
            {
                "groupId" : "com.google.zxing",
                "artifactId" : "core",
                "version" : "3.3.0"
            },
            {
                "groupId" : "com.google.zxing",
                "artifactId" : "javase",
                "version" : "3.3.0"
            }
        ]
    }' {
    // Your code here
}
```

Lucee will automatically download these libraries when they’re needed. In this case, we’re using the ZXing library to work with QR codes.

For more details on Maven support, check out the [Lucee documentation on Maven](https://github.com/lucee/lucee-docs/blob/master/docs/recipes/maven.md).

## Step 2: Importing Java Classes

In Lucee 6.2, you can now import Java classes the same way you import CFML components. You can use the `import` keyword for both, making it easier to mix CFML and Java code in your projects.

Here’s how to import Java classes:

```cfml
import java.io.File;
import java.util.HashMap;
import com.google.zxing.BarcodeFormat;
import com.google.zxing.EncodeHintType;
import com.google.zxing.MultiFormatWriter;
import com.google.zxing.client.j2se.MatrixToImageWriter;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.qrcode.decoder.ErrorCorrectionLevel;
```

### Using Wildcards for Imports

You can import all classes from a package using a wildcard `*`:

```cfml
import java.util.*;
```

This works similarly to wildcard imports in other languages.

For more details on importing Java classes, check out the [Lucee documentation on imports](https://github.com/lucee/lucee-docs/blob/master/docs/recipes/import.md).

## Step 3: Interacting with Java Classes

Once you’ve imported the classes, interacting with them is straightforward. You can create instances of Java objects and call static methods just like you would with CFML components.

```cfml
public static void function createQR(String data, String path, numeric height, numeric width) {
            
    var hashMap = new HashMap();
    hashMap.put(EncodeHintType::ERROR_CORRECTION,ErrorCorrectionLevel::L);
    
    var matrix = new MultiFormatWriter().encode(data, BarcodeFormat::QR_CODE, width, height);
    MatrixToImageWriter::writeToFile(
        matrix,
        listLast(path,"."),
        new File(path));
}
```

In this example, we’re creating a QR code and writing it to a file using Java libraries, but the interaction feels much like working with CFML objects.

For more details on interacting with Java objects in Lucee, check out the [Lucee documentation on the `new` operator](https://github.com/lucee/lucee-docs/blob/master/docs/recipes/new-operator.md).

## Conclusion

By introducing easier Maven integration, flexible imports, and simplified Java interaction, Lucee 6.2 makes it more accessible than ever to work with Java libraries. These enhancements ensure you can leverage the power of Java without unnecessary complexity in your CFML projects.
