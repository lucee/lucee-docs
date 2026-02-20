<!--
{
  "title": "External Agent",
  "id": "external-agent",
  "since": "7.0",
  "categories": ["instrumentation"],
  "description": "Java agent for registering the Instrumentation instance in Lucee",
  "keywords": [
    "agent",
    "instrumentation",
    "java agent",
    "premain",
    "redefine",
    "retransform"
  ]
}
-->

# External Agent

Lucee provides a Java agent (`lucee-external-agent.jar`) that registers a `java.lang.instrument.Instrumentation` instance for use within Lucee. This enables class redefinition and retransformation at runtime.

## Download

Download the agent JAR from GitHub:

[lucee-external-agent.jar](https://github.com/lucee/Lucee/raw/refs/heads/7.0/instrumentation/lucee-external-agent.jar)

## Configuration

Add the agent to your JVM startup arguments using the `-javaagent` flag:

```
-javaagent:/path/to/lucee-external-agent.jar
```

### Servlet Container Examples

**Tomcat** — Add to `CATALINA_OPTS` in `setenv.sh` (Linux/macOS) or `setenv.bat` (Windows):

```bash
export CATALINA_OPTS="$CATALINA_OPTS -javaagent:/opt/lucee/lib/lucee-external-agent.jar"
```

**CommandBox** — Add to your `server.json`:

```json
{
  "jvm": {
    "args": "-javaagent=/opt/lucee/lib/lucee-external-agent.jar"
  }
}
```

### Docker

```dockerfile
ENV CATALINA_OPTS="-javaagent:/opt/lucee/lib/lucee-external-agent.jar"
```

## How It Works

The agent's main class (`lucee.runtime.instrumentation.ExternalAgent`) implements both `premain` and `agentmain` entry points, meaning it can be loaded at JVM startup or attached at runtime. Once loaded, it makes the `Instrumentation` instance available to Lucee, enabling capabilities such as class redefinition and retransformation.

## Agent Capabilities

| Capability | Supported |
|---|---|
| Redefine Classes | ✅ |
| Retransform Classes | ✅ |

## See Also

- [Monitoring and Debugging](monitoring-debugging.md)
- [Lucee Administrator](lucee-administrator.md)