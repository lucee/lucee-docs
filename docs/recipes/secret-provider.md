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

**Environment Variables Example:**

Read the secret directly from the enviroment variables.

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

**File Example:**

Read the secrets from a file, format can be json or env.

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

**Combined Providers Example:**

The `AndSecretProvider` allows you to combine multiple providers, checking each one in the order specified until a secret is found.

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

## Supported Providers

Lucee includes several built-in secret providers:

- **EnvVarSecretProvider**: Reads secrets from environment variables
- **FileSecretProvider**: Reads secrets from a .json or .env file (more formats following)
- **AndSecretProvider**: Combines multiple providers into one
- **AWSSecretsManagerProvider**: Connects to AWS Secrets Manager (coming soon)
- **GoogleSecretManagerProvider**: Uses Google Cloud Secret Manager (coming soon)
- **DockerSecretsProvider**: Reads secrets from Docker secrets (coming soon)

Each provider has specific configuration options as seen above.

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

## Security Considerations

### Secret Rotation

Most providers support automatic secret rotation. Because secrets are resolved when used rather than when retrieved, your application automatically uses the latest value of a secret without any code changes.

### Secure Storage

Always ensure that your `.env` files and other secret storage locations have appropriate file permissions and are excluded from version control systems.

### Provider-Specific Security

Each provider has its own security considerations. For example:

- AWS Secrets Manager requires proper IAM roles and permissions
- Environment variables should be set securely through the operating system

## Troubleshooting

### Debugging

Lucee logs every use of every key to the `application` log with the log level `trace`, this includes the stacktrace, the key used and the name of the secret provider itself.
So when yu enable that log level you will see how and where you secrets get used (not set).

In addition Lucee also logs in case it fails to load a secret provider.

### Common Issues

1. **Secret not found**: Ensure the secret exists in the provider and that the key is correct.
2. **Provider configuration**: Verify that the provider is correctly configured and accessible.
3. **Permission issues**: Check that the application has the necessary permissions to access the secrets.

## Best Practices

1. **Use namespacing for secrets**: Organize secrets with clear naming conventions, such as `DB_USER`, `DB_PASSWORD`, etc.
2. **Store references, not values**: Store references to secrets in application or session scope rather than resolved values.
3. **Implement least privilege**: Only grant access to the specific secrets an application needs.
4. **Monitor usage**: Regularly audit secret access and usage patterns.
5. **Layer providers**: Use the `AndSecretProvider` to implement fallback mechanisms.

## Reference

### GetSecret Function

```cfml
GetSecret(key [, name])
```

- **key**: Key to read from the Secret Provider
- **name**: (Optional) Name of the Secret Provider to read from. If not provided, all configured providers are checked in order.

Returns a reference to the secret value that is automatically resolved when used in a context requiring a simple value.