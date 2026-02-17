<!--
{
  "title": "Secret Management",
  "id": "secret-management",
  "categories": ["security","server"],
  "description": "Managing Secrets in Lucee applications",
  "since": "7.0",
  "keywords": [
    "security",
    "secrets",
    "credentials",
    "environment variables",
    "configuration"
  ],
  "related": [
    "function-secretproviderget"
  ]
}
-->

# Secret Management

Securely store and access sensitive data (credentials, API keys) using configurable secret providers. Keeps secrets out of code and config files.

> **Working Example Available**
> A complete Docker-based example demonstrating all providers covered in this document — including LocalStack for local AWS mocking — is available at:
> **[github.com/lucee/lucee-docs/tree/master/examples/docker/secret-provider](https://github.com/lucee/lucee-docs/tree/master/examples/docker/secret-provider)**

[[function-secretproviderget]]

## Configuration

Secret providers are configured in `.CFConfig.json` under the `secretProvider` key. Each provider has a name (used when calling `SecretProviderGet`), a class, and optional custom properties.

### Environment Variables Provider

Reads secrets directly from environment variables:
```json
"secretProvider": {
  "env": {
    "class": "lucee.runtime.security.EnvVarSecretProvider",
    "custom": {
      "caseSensitive": false
    }
  }
}
```

### File Provider

Reads secrets from a `.json` or `.env` file:
```json
"secretProvider": {
  "json": {
    "class": "lucee.runtime.security.FileSecretProvider",
    "custom": {
      "type": "json",
      "file": "/path/to/secrets.json",
      "caseSensitive": false
    }
  }
}
```

### AWS Secrets Manager Provider

Reads secrets from [AWS Secrets Manager](https://aws.amazon.com/secrets-manager/). Provided by the `org.lucee:aws-sm` library, loaded automatically via Maven:
```json
"secretProvider": {
  "sm": {
    "class": "org.lucee.extension.aws.sm.AWSSecretManagerProvider",
    "maven": "org.lucee:aws-sm:1.0.0.6-RC",
    "custom": {
      "accessKeyId": "your-access-key-id",
      "secretKey": "your-secret-key",
      "region": "us-east-1",
      "jsonTraversal": true,
      "timeout": 5000
    }
  }
}
```

### AWS Parameter Store Provider

Reads secrets from [AWS Systems Manager Parameter Store](https://docs.aws.amazon.com/systems-manager/latest/userguide/systems-manager-parameter-store.html). Also provided by the `org.lucee:aws-sm` library:
```json
"secretProvider": {
  "ps": {
    "class": "org.lucee.extension.aws.ssm.AWSParameterStoreProvider",
    "maven": "org.lucee:aws-sm:1.0.0.6-RC",
    "custom": {
      "accessKeyId": "your-access-key-id",
      "secretKey": "your-secret-key",
      "region": "us-east-1",
      "jsonTraversal": true,
      "timeout": 5000
    }
  }
}
```

### Combined Providers

The `AndSecretProvider` chains multiple providers together, checking each in order until a secret is found:
```json
"secretProvider": {
  "many": {
    "class": "lucee.runtime.security.AndSecretProvider",
    "custom": {
      "providers": "env,json"
    }
  }
}
```

### Full Example Configuration

A complete `.CFConfig.json` combining all built-in and AWS providers:
```json
{
  "secretProvider": {
    "env": {
      "class": "lucee.runtime.security.EnvVarSecretProvider",
      "custom": {
        "caseSensitive": false
      }
    },
    "json": {
      "class": "lucee.runtime.security.FileSecretProvider",
      "custom": {
        "type": "json",
        "file": "/path/to/secrets.json",
        "caseSensitive": false
      }
    },
    "sm": {
      "class": "org.lucee.extension.aws.sm.AWSSecretManagerProvider",
      "maven": "org.lucee:aws-sm:1.0.0.6-RC",
      "custom": {
        "accessKeyId": "your-access-key-id",
        "secretKey": "your-secret-key",
        "region": "us-east-1",
        "jsonTraversal": true,
        "timeout": 5000
      }
    },
    "ps": {
      "class": "org.lucee.extension.aws.ssm.AWSParameterStoreProvider",
      "maven": "org.lucee:aws-sm:1.0.0.6-RC",
      "custom": {
        "accessKeyId": "your-access-key-id",
        "secretKey": "your-secret-key",
        "region": "us-east-1",
        "jsonTraversal": true,
        "timeout": 5000
      }
    }
  }
}
```

## Supported Providers

| Provider | Class | Source |
|----------|-------|--------|
| Environment Variables | `lucee.runtime.security.EnvVarSecretProvider` | Lucee Core |
| File (JSON/ENV) | `lucee.runtime.security.FileSecretProvider` | Lucee Core |
| Combined/Chained | `lucee.runtime.security.AndSecretProvider` | Lucee Core |
| AWS Secrets Manager | `org.lucee.extension.aws.sm.AWSSecretManagerProvider` | [aws-sm extension](https://maven.lucee.org) |
| AWS Parameter Store | `org.lucee.extension.aws.ssm.AWSParameterStoreProvider` | [aws-sm extension](https://maven.lucee.org) |

## Provider Configuration Options

### EnvVarSecretProvider

| Option | Description | Default |
|--------|-------------|---------|
| `caseSensitive` | Whether key lookups are case-sensitive | `true` |

### FileSecretProvider

| Option | Description | Default |
|--------|-------------|---------|
| `type` | File format: `json` or `env` | `env` |
| `file` | Path to the secrets file (required) | — |
| `caseSensitive` | Whether key lookups are case-sensitive | `true` |
| `refreshInterval` | How often to check for file changes (ms) | `60000` |

### AndSecretProvider

| Option | Description | Default |
|--------|-------------|---------|
| `providers` | Comma-separated list of provider names to check in order (required) | — |

### AWSSecretManagerProvider / AWSParameterStoreProvider

| Option | Description | Default |
|--------|-------------|---------|
| `accessKeyId` | AWS access key ID | — |
| `secretKey` | AWS secret access key | — |
| `region` | AWS region | `us-east-1` |
| `endpoint` | Custom endpoint URL (useful for local mocking with LocalStack) | — |
| `jsonTraversal` | Enables dot-notation access into JSON secret values | `true` |
| `timeout` | Cache duration in milliseconds. `0` disables caching | `0` |
| `checkEnviroment` | Whether to fall back to environment credentials | `true` |

## Using Secrets in Your Application

Secrets are accessed via the [[function-SecretProviderGet]] function.
```cfml
// Get from a specific provider
apiKey = SecretProviderGet("API_KEY", "env");

// Get from any provider (first match wins)
dbPassword = SecretProviderGet("DB_PASSWORD");
```

### JSON Traversal

When a secret value is a JSON string and `jsonTraversal` is enabled, you can use dot notation to access nested keys directly:
```cfml
// Returns the full JSON string: {"username":"admin","password":"supersecret"}
secret = SecretProviderGet("mysecret", "sm");

// Returns just "supersecret"
password = SecretProviderGet("mysecret.password", "sm");
```

### Storing References at Startup

Secrets return a lazy reference — the actual value is only resolved when used. This means you can safely store references at application startup and they will always reflect the current secret value, even after rotation:
```cfml
// Application.cfc
component {
  function onApplicationStart() {
    application.secrets = {
      apiKey:   SecretProviderGet("API_KEY", "env"),
      dbHost:   SecretProviderGet("DB_HOST", "sm"),
      dbUser:   SecretProviderGet("DB_USER", "sm"),
      dbPass:   SecretProviderGet("DB_PASSWORD", "sm")
    };
  }
}
```

## Local Development with LocalStack

For local development you can mock AWS Secrets Manager and Parameter Store using [LocalStack](https://localstack.cloud/). Configure the `endpoint` property to point to your LocalStack instance instead of real AWS:
```json
"sm": {
  "class": "org.lucee.extension.aws.sm.AWSSecretManagerProvider",
  "maven": "org.lucee:aws-sm:1.0.0.6-RC",
  "custom": {
    "accessKeyId": "dummy",
    "secretKey": "dummy",
    "region": "us-east-1",
    "endpoint": "http://localstack:4566"
  }
}
```

Any non-empty string works for `accessKeyId` and `secretKey` when pointing at LocalStack.

## Key Features

### Lazy Resolution

`SecretProviderGet` returns a reference, not the actual value. The secret is resolved only when used as a simple value (string, number, boolean). This means:

- **Auto-updating**: If a secret rotates in the provider, your app picks up the new value automatically.
- **Reduced memory exposure**: Secret values aren't held in memory until actually needed.

### Obfuscation

Secret values are automatically obfuscated in `dump()` output and debug logs, reducing accidental exposure.

### Using External Classes via Maven

Since Lucee 6.2, external provider classes can be loaded directly from Maven by specifying the `maven` key:
```json
"sm": {
  "class": "org.lucee.extension.aws.sm.AWSSecretManagerProvider",
  "maven": "org.lucee:aws-sm:1.0.0.6-RC",
  "custom": { ... }
}
```

## Installing the AWS Extension

The `org.lucee:aws-sm` Maven jar is downloaded automatically by Lucee when first used — no manual installation required. However, pre-installing the extension means the jars are already available locally, avoiding any download at startup. This is recommended for production and air-gapped environments.

There are two ways to pre-install it in `.CFConfig.json`:

### Via Maven (downloads from Maven repository)
```json
"extensions": [
  {
    "id": "16953C9D-0A26-4283-904AD851B30506AF",
    "name": "AWS Secret Manager Extension",
    "version": "1.0.0.6-RC",
    "maven": "org.lucee:aws-sm-extension:1.0.0.6-RC"
  }
]
```

### Via Local File (no download needed)
```json
"extensions": [
  {
    "id": "16953C9D-0A26-4283-904AD851B30506AF",
    "name": "AWS Secret Manager Extension",
    "version": "1.0.0.6-RC",
    "source": "/path/to/aws-sm-extension-1.0.0.6-RC.lex"
  }
]
```

Use the `source` approach when you want fully offline/reproducible deployments — for example, by including the `.lex` file in your Docker image alongside your `artifacts/` directory.

## Creating Custom Secret Providers

You can implement your own provider as a CFML component using `implementsJava`:
```cfml
// MySecretProvider.cfc
component implementsJava="lucee.runtime.secrets.SecretProvider" {

  function init(struct config) {
    variables.config = config;
    return this;
  }

  function getSecret(string key) {
    var q = queryExecute(
      "SELECT value FROM app_secrets WHERE key = :key",
      {key: key},
      {datasource: config.datasource}
    );
    return q.recordCount ? q.value : javaNull();
  }

  function hasSecret(string key) {
    var q = queryExecute(
      "SELECT COUNT(*) as cnt FROM app_secrets WHERE key = :key",
      {key: key},
      {datasource: config.datasource}
    );
    return q.cnt > 0;
  }
}
```

Register it in `.CFConfig.json`:
```json
"secretProvider": {
  "database": {
    "component": "path.to.MySecretProvider",
    "custom": {
      "datasource": "secretsDB"
    }
  }
}
```

## Working Example

A complete working Docker-based example is available in the Lucee documentation repository:

**[github.com/lucee/lucee-docs/tree/master/examples/docker/secret-provider](https://github.com/lucee/lucee-docs/tree/master/examples/docker/secret-provider)**

It includes a Docker Compose setup with LocalStack mocking AWS Secrets Manager and Parameter Store, along with a `test.cfm` demonstrating all providers covered in this document.

## Troubleshooting

Lucee logs every secret access at `trace` level in the `application` log, including the key, provider name, and stack trace (but never the value). Enable trace-level logging to audit secret usage.
