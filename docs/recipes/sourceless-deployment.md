<!--
{
  "title": "Deploying without CFML Source Code",
  "id": "sourceless-deployment",
  "description": "How to deploy a Lucee application without readable CFML source (the equivalent of cfencode): compile templates in place to bytecode with compileToBytecode() in Lucee 8, or ship sourceless Lucee archives.",
  "keywords": [
    "cfencode",
    "source protection",
    "compileToBytecode",
    "restoreToSource",
    "bytecode",
    "Precompiled",
    "Archive",
    ".lar",
    "Deployment",
    "Encrypt"
  ],
  "categories": ["server", "devops", "security"],
  "related": [
    "precompiled-code",
    "archives-creating-and-deploy"
  ]
}
-->

# Deploying without CFML Source Code

Lucee has no `cfencode` tool, but there are two ways to deploy an application without readable CFML source:

- **`compileToBytecode()`** (Lucee 8) replaces each `.cfm`, `.cfc` and `.cfs` file with its compiled bytecode, in place. Lucee detects that the file contains bytecode and executes it directly.
- **Sourceless archives** (`.lar`) package a mapping as compiled classes only. See [[archives-creating-and-deploy]].

Both deploy compiled code instead of source.

## Compile in place with compileToBytecode()

`compileToBytecode( path [, keepSource] [, privateKey] [, recursive] )` compiles a single file, or a whole directory, and writes the bytecode back over the original file.

| Argument | Default | Description |
| --- | --- | --- |
| `path` | required | Relative or absolute path to a CFML file or a directory |
| `keepSource` | `false` | When `true`, the source is copied to a dot-prefixed file next to the template (`index.cfm` becomes `.index.cfm`) |
| `privateKey` | none | RSA private key used to encrypt the bytecode, see "Encrypting the bytecode" below |
| `recursive` | `true` | When `path` is a directory, also process subdirectories |

It returns a struct with the keys `compiled`, `skipped`, `errors` and `warnings`. Errors are collected per file, so one failing template doesn't stop the rest. Dot-prefixed files, files that aren't CFML (by extension), and files that already contain bytecode are skipped, so running it again is safe.

```cfs
// build step, run on a copy of your application, never on the only copy of your source
result = compileToBytecode( path="/build/myApp", keepSource=false );

systemOutput( "compiled: #result.compiled.len()#, skipped: #result.skipped.len()#, errors: #result.errors.count()#", true );
```

Deploy the resulting directory as usual. When a request hits `index.cfm`, Lucee sees that the file contains bytecode and runs it, no source needed.

Things to be aware of:

- The source is **replaced**. Unless you use `keepSource=true`, the original is gone, so keep your source in version control and compile a copy in your build.
- Compilation can produce auxiliary classes (for example for Java code in functions) that are stored in the `cfclasses` directory. When `warnings` reports this, deploy the `cfclasses` directory together with the templates.
- Bytecode is only executed when it isn't blocked. The system property `lucee.compiler.block.bytecode` (environment variable `LUCEE_COMPILER_BLOCK_BYTECODE`) controls this and defaults to `false`, so bytecode runs. If a server has it set to `true`, direct execution of compiled `.cfm`, `.cfc` and `.cfs` files is refused. See [[environment-variables-system-properties]].
- A compiled `.cfm` can't be used as a component and a compiled `.cfc` can't be used as a regular template. Lucee throws an exception if the file type doesn't match.

### Encrypting the bytecode

Pass an RSA private key as `privateKey` to encrypt the bytecode when compiling. The matching public key must be available on every server that runs the code, as the `PUBLIC_KEY` environment variable or as the `PUBLIC_KEY` system property. Without it, executing an encrypted template fails with an exception that says so.

```cfs
result = compileToBytecode( path="/build/myApp", privateKey=privateKey );
```

Both keys are Base64 encoded RSA keys: the private key in PKCS#8 format and the public key in X.509 format.

### Restoring the source

If you compiled with `keepSource=true`, `restoreToSource( path [, recursive] )` puts the source back. It replaces the bytecode with the content of the dot-prefixed file and deletes that file. It returns a struct with the keys `restored`, `skipped` and `errors`.

```cfs
compileToBytecode( path="/build/myApp", keepSource=true );

// later, on the same directory
restoreToSource( path="/build/myApp" );
```

## Sourceless archives

A Lucee archive (`.lar`) can be built with `addCFMLFiles="false"`, so it contains only the compiled classes and none of the `.cfm` / `.cfc` source. This works in all Lucee versions that support archives and also covers component and custom tag mappings. The full workflow for creating and deploying archives is described in [[archives-creating-and-deploy]].

## Which one to use

- Use **`compileToBytecode()`** when you want to keep your normal directory layout and deploy a directory tree, or when you want to encrypt the code.
- Use an **archive** when you want a single file per mapping, or when you need this on a Lucee version before 8.

If you only want to avoid compilation on the production server, but don't need to hide the source, see [[precompiled-code]].
