<!--
{
  "title": "Secret Management",
  "id": "secret-management",
  "categories": ["security"],
  "description": "Managing Secrets in Lucee applications",
  "since": "7.0",
  "keywords": [
    "security",
    "secrets",
    "credentials",
    "environment variables",
    "configuration"
  ]
}
-->

# Secret Management

Lucee 7 introduces built-in support for secrets management, allowing you to securely store and access sensitive information such as database credentials, API keys, and other confidential data. This feature helps maintain security best practices by keeping sensitive data out of application code and configuration files.

## Configuration

In Lucee 7, secret providers can be configured similarly to datasources, caches, or AI connections, either in the Lucee Administrator (work in progress) or directly in `.CFConfig.json`. Here are sample configurations:

### Environment Variables Provider

Read the secret directly from the environment variables:

```json
"secretProviders": {
  "env": {
    "class": "lucee.runtime.secrets.EnvVarSecretProvider",
    "custom": {
      "caseSensitive": false
    }
  }
}
```

### File Provider

Read the secrets from a file, format can be json or env:

```json
"secretProviders": {
   "json": {
      "class": "lucee.runtime.security.FileSecretProvider",
      "custom": {
        "type": "json",
        "file": "/my/secrets/vars.json",
        "caseSensitive": false
      }
    }
}
```

### Combined Providers

The `AndSecretProvider` allows you to combine multiple providers, checking each one in the order specified until a secret is found:

```json
"secretProviders": {
  "many": {
    "class": "lucee.runtime.security.AndSecretProvider",
    "custom": {
      "providers": "env,json"
    }
  }
}
```

### Using External Classes

Similar to other Lucee features, you can specify external classes for your secret providers using various methods:

#### OSGi Bundles

```json
"secretProviders": {
  "custom": {
    "class": "com.mycompany.secrets.CustomSecretProvider",
    "bundleName": "com.mycompany.secrets",
    "bundleVersion": "1.2.0",
    "custom": {
      "configParam1": "value1",
      "configParam2": "value2"
    }
  }
}
```

#### Maven Dependencies

Since Lucee 6.2, you can load classes directly from Maven repositories:

```json
"secretProviders": {
  "vault": {
    "class": "com.company.secrets.VaultSecretProvider",
    "maven": "com.company:vault-provider:1.0.0,com.company:common-utils:1.5.0",
    "custom": {
      "url": "https://vault.example.com",
      "timeout": 5000
    }
  }
}
```

This allows you to specify one or more comma-separated Maven dependencies in gradle-style format.

#### CFML Components (Lucee 7+)

You can implement your own secret provider as a CFML component:

```json
"secretProviders": {
  "myCustom": {
    "component": "path.to.MySecretProviderComponent",
    "custom": {
      "configParam1": "value1"
    }
  }
}
```

The component must implement `lucee.runtime.secrets.SecretProvider` via `implementsJava="lucee.runtime.secrets.SecretProvider"` annotation.

## Supported Providers

Lucee includes several built-in secret providers:

- **lucee.runtime.secrets.EnvVarSecretProvider**: Reads secrets from environment variables
- **lucee.runtime.security.FileSecretProvider**: Reads secrets from a .json or .env file (more formats following)
- **lucee.runtime.security.AndSecretProvider**: Combines multiple providers into one
- **AWSSecretsManagerProvider**: Connects to AWS Secrets Manager (coming soon)
- **GoogleSecretManagerProvider**: Uses Google Cloud Secret Manager (coming soon)
- **DockerSecretsProvider**: Reads secrets from Docker secrets (coming soon)

## Provider Configuration Options

### EnvVarSecretProvider

| Option | Description | Default | Notes |
|--------|-------------|---------|-------|
| `caseSensitive` | Determines if environment variable names are case-sensitive | `true` | Set to `false` to allow case-insensitive lookups |

### FileSecretProvider

| Option | Description | Default | Notes |
|--------|-------------|---------|-------|
| `type` | File format | `env` | Supported values: `env`, `json` |
| `file` | Path to the secrets file | None (Required) | Can use any Lucee-supported resource path (local, S3, HTTP, etc.) |
| `caseSensitive` | Determines if secret keys are case-sensitive | `true` | Set to `false` to allow case-insensitive lookups |
| `refreshInterval` | How often to check for file changes (in milliseconds) | `60000` (1 minute) | Set to `0` to disable auto-refresh |

### AndSecretProvider

| Option | Description | Default | Notes |
|--------|-------------|---------|-------|
| `providers` | Comma-separated list of provider names to check | None (Required) | Providers are checked in the specified order |

## Using Secrets in Your Application

Secrets are accessed through the `GetSecret()` function, which returns a reference to the secret value rather than the actual value itself.

### Basic Usage

```cfml
// Get a secret from a specific provider
apiKey = GetSecret("API_KEY", "env");

// Use the secret in an API call
cfhttp(url="https://api.example.com", method="GET") {
    cfhttpparam(type="header", name="Authorization", value="Bearer #apiKey#");
}
```

### Using Without Specifying Provider

```cfml
// Get a secret without specifying a provider (checks all providers)
dbPassword = GetSecret("DB_PASSWORD");

// Use the secret in a database connection
dbConnection = {
    host: GetSecret("DB_HOST"),
    username: GetSecret("DB_USER"),
    password: dbPassword
};
```

### Storing References

```cfml
// Store secret references at application startup
application.secrets = {
    apiKey: GetSecret("API_KEY", "env"),
    dbConfig: {
        host: GetSecret("DB_HOST", "vault"),
        username: GetSecret("DB_USER", "vault"),
        password: GetSecret("DB_PASSWORD", "vault")
    }
};

// Use them throughout the application
cfhttp(url="https://api.example.com", method="GET") {
    cfhttpparam(type="header", name="Authorization", value="Bearer #application.secrets.apiKey#");
}
```

## Key Features

### Lazy Resolution

When you call `GetSecret()`, it returns a reference to the secret rather than the actual value. The secret is only resolved to its actual value when it's used in a context that requires a simple value (string, boolean, number, date). This enables several powerful features:

- **Auto-updating secrets**: If a secret changes in the provider, your application automatically uses the updated value without needing to reload the application or reconfigure anything.
- **Enhanced security**: Secret values are not stored in memory until they're actually needed.

### Obfuscation

Secret values are automatically obfuscated when dumped or displayed in debug output, reducing the risk of exposing sensitive information.

```cfml
// This will display an obfuscated value rather than the actual secret
dump(GetSecret("API_KEY"));
```

### Combined Providers

The `AndSecretProvider` allows you to chain multiple providers together, checking each one in order until a secret is found. This enables fallback scenarios and tiered approaches to secret management.

```cfml
// Configure a combined provider
// First checks environment variables, then AWS Secrets Manager
"secretProviders": {
  "combined": {
    "class": "lucee.runtime.security.AndSecretProvider",
    "custom": {
      "providers": "env,aws"
    }
  }
}

// Use the combined provider
apiKey = GetSecret("API_KEY", "combined");
```

## Creating Custom Secret Providers

You can create your own secret provider by implementing the `lucee.runtime.secrets.SecretProvider` interface. This can be done either in Java (compiled into a JAR and loaded via OSGi or Maven) or directly in CFML.

### CFML Component Implementation

```cfml
// MySecretProvider.cfc
component implementsJava="lucee.runtime.secrets.SecretProvider" {

    // Initialize the provider with custom configuration
    function init(struct config) {
        variables.config = config;
        return this;
    }

    // Get a secret by key
    function getSecret(string key) {
        // Implementation to retrieve the secret
        // Return null if the secret doesn't exist

        // Example implementation (database-stored secrets)
        var q = queryExecute(
            "SELECT value FROM app_secrets WHERE key = :key",
            {key: key},
            {datasource: config.datasource}
        );

        if (q.recordCount) {
            return q.value;
        }

        return javaNull();
    }

    // Check if a secret exists
    function hasSecret(string key) {
        // Return true if the secret exists, false otherwise

        // Example implementation
        var q = queryExecute(
            "SELECT COUNT(*) as count FROM app_secrets WHERE key = :key",
            {key: key},
            {datasource: config.datasource}
        );

        return q.count > 0;
    }
}
```

To use this custom provider, configure it in your `.CFConfig.json`:

```json
"secretProviders": {
  "database": {
    "component": "path.to.MySecretProvider",
    "custom": {
      "datasource": "secretsDB"
    }
  }
}
```

## Security Considerations

### Secret Rotation

Most providers support automatic secret rotation. Because secrets are resolved when used rather than when retrieved, your application automatically uses the latest value of a secret without any code changes.

### Secure Storage

Always ensure that your `.env` files and other secret storage locations have appropriate file permissions and are excluded from version control systems.

### Provider-Specific Security

Each provider has its own security considerations. For example:

- AWS Secrets Manager requires proper IAM roles and permissions
- Environment variables should be set securely through the operating system
- File-based secrets need strict file permissions

## Troubleshooting

### Debugging

Lucee logs every use of every key to the `application` log with the log level `trace`, this includes the stacktrace, the key used and the name of the secret provider itself.
When you enable that log level, you will see how and where your secrets get used (not the values themselves).

In addition, Lucee also logs in case it fails to load a secret provider.

### Common Issues

1. **Secret not found**: Ensure the secret exists in the provider and that the key is correct.
2. **Provider configuration**: Verify that the provider is correctly configured and accessible.
3. **Permission issues**: Check that the application has the necessary permissions to access the secrets.
4. **Class not found**: When using external providers, ensure all required dependencies are available.

## Best Practices

1. **Use namespacing for secrets**: Organize secrets with clear naming conventions, such as `DB_USER`, `DB_PASSWORD`, etc.
2. **Store references, not values**: Store references to secrets in application or session scope rather than resolved values.
3. **Implement least privilege**: Only grant access to the specific secrets an application needs.
4. **Monitor usage**: Regularly audit secret access and usage patterns.
5. **Layer providers**: Use the `AndSecretProvider` to implement fallback mechanisms.
6. **Environment segregation**: Use different secret providers for development, staging, and production environments.
7. **Regular rotation**: Rotate secrets regularly and verify that your application handles rotation gracefully.

## Reference

### GetSecret Function

```cfml
GetSecret(key [, name])
```

- **key**: Key to read from the Secret Provider
- **name**: (Optional) Name of the Secret Provider to read from. If not provided, all configured providers are checked in order.

Returns a reference to the secret value that is automatically resolved when used in a context requiring a simple value.

### SecretProvider Interface

```java
package lucee.runtime.secrets;

public interface SecretProvider {
    /**
     * Initialize the provider with the given configuration
     * @param config Provider-specific configuration
     */
    public void init(java.util.Map<String, String> config);
    
    /**
     * Get a secret by key
     * @param key Secret key
     * @return Secret value or null if not found
     */
    public String getSecret(String key);
    
    /**
     * Check if a secret exists
     * @param key Secret key
     * @return true if the secret exists, false otherwise
     */
    public boolean hasSecret(String key);
}
```