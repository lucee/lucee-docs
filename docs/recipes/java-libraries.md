<!--
{
  "title": "Interacting with Java Libraries",
  "id": "java-libraries",
  "description": "Guide on using Java libraries in Lucee 6.2 with Maven and import",
  "since": "6.2",
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
  "related": [
    "maven"
  ]
}
-->

# Interacting with Java Libraries

Need functionality that doesn't exist in CFML? There's probably a Java library for it. Lucee lets you pull in Java libraries directly - no manual JAR downloads, no classpath configuration. Just declare what you need and start coding.

This recipe shows how to use external Java libraries. For working with Java's built-in classes, see [[java-class-interaction]].

## Adding Dependencies

Java has two main package managers: Maven and Gradle. Both identify libraries with three parts:

- **groupId**: The organization (e.g., `com.google.zxing`)
- **artifactId**: The library name (e.g., `core`)
- **version**: The version number (e.g., `3.3.0`)

Add dependencies to a component's `javasettings` attribute - Lucee downloads them automatically on first use.

### Object Syntax

```cfml
component javasettings='
{
	"maven": [
		{
			"groupId": "com.google.zxing",
			"artifactId": "core",
			"version": "3.3.0"
		},
		{
			"groupId": "com.google.zxing",
			"artifactId": "javase",
			"version": "3.3.0"
		}
	]
}' {
	// Your code here
}
```

### Shorthand Syntax

More concise - use the `group:artifact:version` string format:

```cfml
component javasettings='
{
	"maven": [
		"com.google.zxing:core:3.3.0",
		"com.google.zxing:javase:3.3.0"
	]
}' {
	// Your code here
}
```

**Note:** The `javasettings` attribute must be valid JSON, not a CFML struct literal.

This example uses the ZXing library for QR codes. See the [[maven]] recipe for more details.

## Importing Java Classes

Import Java classes the same way as CFML components:

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

Wildcard imports work too: `import java.util.*;`

See the [[import]] recipe for more details.

## Using Java Classes

Once imported, use Java classes like CFML components:

- `new ClassName()` - create instances
- `ClassName::methodName()` - call static methods
- `ClassName::CONSTANT` - access static fields/constants

Here's the complete QR code example:

```cfml
public static void function createQR( String data, String path, numeric height, numeric width ) {
	// Configure QR code options using Java's HashMap
	var hints = new HashMap();
	hints.put( EncodeHintType::ERROR_CORRECTION, ErrorCorrectionLevel::L );

	// Generate the QR code matrix
	var matrix = new MultiFormatWriter().encode(
		data,
		BarcodeFormat::QR_CODE,
		width,
		height
	);

	// Write to file - static method call with ::
	MatrixToImageWriter::writeToFile(
		matrix,
		listLast( path, "." ),
		new File( path )
	);
}
```

See [[new-operator]] for more on instantiating Java classes, and [[java-class-interaction]] for static methods and fields.
