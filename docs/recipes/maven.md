
<!--
{
  "title": "Using Maven directly via CFML",
  "id": "maven",
  "categories": [
    "java"
  ],
  "description": "How to use Maven in Lucee",
  "keywords": [
    "Maven",
    "Java",
    "OSGi"
  ],
  "related":[
    "function-createobject",
    "tag-import"
  ]
}
-->

# Maven (Lucee 6.2)

Maven is a powerful tool for managing and retrieving Java libraries in modern applications. 
It allows developers to easily integrate dependencies and manage project libraries. In Lucee 6.2, Maven integration has been added, providing more flexibility when using Java libraries within your CFML codebase.

## Why Maven?

Maven is a widely-used framework that simplifies the management of Java dependencies. 
It automatically handles the retrieval and inclusion of required libraries and their dependencies, reducing the manual work needed to manage them. 
This makes integrating third-party Java libraries into your Lucee applications much easier and more efficient.

## How to Use Maven in Lucee

Lucee has supported the `this.javasettings` setting in the `Application.cfc` for a while. 
This allows developers to define directories containing Java classes or `.jar` files. Starting from Lucee 6.2, this functionality has been extended to support Maven libraries. 
You can now define Maven dependencies in the configuration file `.CFConfig.json`, within your `Application.cfc`, or directly in your CFML components.

Lucee uses these configurations to load Java classes in a structured manner, ensuring that dependencies are managed effectively.

## Lucee Config (`.CFConfig.json`)

In `.CFConfig.json`, you can define Maven dependencies that will be used globally by your Lucee server for loading Java classes.

```json
{
  "javasettings": {
    "maven": [
      {
        "groupId": "org.quartz-scheduler",
        "artifactId": "quartz",
        "version": "2.3.2"
      },
      {
        "groupId": "org.quartz-scheduler",
        "artifactId": "quartz-jobs",
        "version": "2.3.2"
      }
    ]
  }
}
```

The `version` attribute is optional. If not specified, Lucee will automatically fetch the latest version available for the specified Maven artifact.

In addition, we also support the more concise Gradle style.

```json
{
  "javasettings": {
    "maven": [
        "org.graalvm.polyglot:polyglot:24.1.1"
        , "org.graalvm.polyglot:python:24.1.1"
    ]
  }
}
```

## Application.cfc

In your `Application.cfc`, you can override or extend the global Java settings by adding Maven dependencies specific to your application.

```javascript
this.javasettings = {
  "maven": [
    {
      "groupid": "commons-beanutils",
      "artifactid": "commons-beanutils",
      "version": "1.9.4"
    }
  ]
};
```

This allows you to tailor the Java dependencies for your application, providing more flexibility in how libraries are loaded and used.

## Defining Maven Dependencies in a Component

You can also define Maven dependencies as part of a component, ensuring that only the classes loaded within that component will use the specified libraries.

```javascript
component javaSettings = '{
  "maven": [
    {
      "groupid": "commons-beanutils",
      "artifactid": "commons-beanutils",
      "version": "1.9.4"
    }
  ]
}' {

}
```

This encapsulation is highly beneficial because it isolates a component from the rest of the environment, allowing it to use different versions of the same libraries without causing conflicts. This ensures that you can integrate components seamlessly without worrying about library version clashes.

## Using Maven with `CreateObject`

You can also define Maven dependencies directly when creating a Java object using the `CreateObject` function.

```javascript
createObject("java", "org.apache.commons.beanutils.BeanUtils", {
  "maven": [
    {
      "groupid": "commons-beanutils",
      "artifactid": "commons-beanutils",
      "version": "1.9.4"
    }
  ]
});
```

This method provides even more flexibility, allowing you to load Java classes and libraries dynamically at runtime.

## Security

Lucee validates downloaded Maven artifacts against checksums to ensure integrity through dual validation:

Against Maven repository checksums
Against user-defined checksums (if provided)

Define checksums in .CFConfig.json:

```json
{
  "javasettings": {
    "maven": [
      {
        "groupId": "org.example",
        "artifactId": "mylib",
        "version": "1.0.0",
        "checksum": "sha1-d52b9abcd97f38c81342bb7e7ae1eee9b73cba51"
      }
    ]
  }
}
```

Or using Gradle style:

```
"commons-beanutils:commons-beanutils:1.9.4:compile:false:sha1-d52b9abcd97f38c81342bb7e7ae1eee9b73cba51"
```

Supported algorithms: MD5, SHA-1, SHA-256, SHA-512
If no checksum is specified, Lucee uses the default from the Maven repository. Failed checksum validations prevent dependency installation.

## Classloader Recycling

Lucee automatically generates a unique hash based on the defined Java settings and maintains a pool of corresponding classloaders. This means that classloaders are reused efficiently, minimizing resource consumption and avoiding the overhead of creating new classloaders unnecessarily.

## Limitations

- Maven libraries are downloaded at runtime, meaning you must ensure the necessary dependencies are available during the build phase. This can be handled in `Server.cfc->onBuild`, especially in Docker environments where the image is built beforehand.
- Currently, this feature is only supported in CFML. You cannot use it in Java-based extensions for Lucee, but future updates are planned to extend this functionality to Java code as well.

By integrating Maven support into Lucee, managing Java libraries becomes much more efficient and less error-prone. This feature ensures that dependencies are handled properly across different parts of your application, reducing potential conflicts and simplifying development.
