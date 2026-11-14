# Lucee skill: Examples & technical specs

Runnable Docker examples and technical specs (AST, hooks, JSR-223, monitors, LuCLI).

## Examples

Runnable examples, fetched from the lucee-docs GitHub repository.

| Title | ID | URL |
|-------|----|-----|
| Docker Example | `docker` | `https://raw.githubusercontent.com/lucee/lucee-docs/master/examples/docker/readme.md` |
| Lucee AST Demo | `docker/ast` | `https://raw.githubusercontent.com/lucee/lucee-docs/master/examples/docker/ast/readme.md` |
| Lucee Couchbase Cache Demo | `docker/couchbase` | `https://raw.githubusercontent.com/lucee/lucee-docs/master/examples/docker/couchbase/readme.md` |
| Lucee Docker Setup | `docker/with-config` | `https://raw.githubusercontent.com/lucee/lucee-docs/master/examples/docker/with-config/readme.md` |
| Lucee Docker Setup with Custom Extensions | `docker/wip` | `https://raw.githubusercontent.com/lucee/lucee-docs/master/examples/docker/wip/readme.md` |
| Lucee Docker Setup with Custom Extensions | `docker/with-extension` | `https://raw.githubusercontent.com/lucee/lucee-docs/master/examples/docker/with-extension/readme.md` |
| Lucee Docker Setup with Custom Extensions | `docker/with-patch` | `https://raw.githubusercontent.com/lucee/lucee-docs/master/examples/docker/with-patch/readme.md` |
| Lucee MCP Server — Docker Example | `docker/mcp` | `https://raw.githubusercontent.com/lucee/lucee-docs/master/examples/docker/mcp/readme.md` |
| Lucee Quartz + AI Connection — Docker Example | `docker/quartz-ai` | `https://raw.githubusercontent.com/lucee/lucee-docs/master/examples/docker/quartz-ai/readme.md` |
| Lucee S3 Virtual File System — LocalStack Example | `docker/s3-localstack` | `https://raw.githubusercontent.com/lucee/lucee-docs/master/examples/docker/s3-localstack/readme.md` |
| Lucee S3 Virtual File System — MinIO Example | `docker/s3-minio` | `https://raw.githubusercontent.com/lucee/lucee-docs/master/examples/docker/s3-minio/readme.md` |
| Lucee S3 Virtual File System — MiniStack Example | `docker/s3-ministack` | `https://raw.githubusercontent.com/lucee/lucee-docs/master/examples/docker/s3-ministack/readme.md` |
| Lucee Secret Provider - Docker Example | `docker/secret-provider` | `https://raw.githubusercontent.com/lucee/lucee-docs/master/examples/docker/secret-provider/readme.md` |
| Simple Lucee Docker Setup | `docker/basic` | `https://raw.githubusercontent.com/lucee/lucee-docs/master/examples/docker/basic/readme.md` |

## Technical specs

Implementation details, class names and API signatures.

| Topic | URL |
|-------|-----|
| AI — `createAISession`, `inquiryAISession`, multipart, RAG, MCP passthrough | `https://raw.githubusercontent.com/lucee/lucee-docs/master/docs/recipes/ai.md` |
| AST/Parser — `astFromPath`, `astFromString`, node types, ESTree | `https://raw.githubusercontent.com/lucee/lucee-docs/master/docs/technical-specs/ast.yaml` |
| Startup Hooks — `.CFConfig.json`, class loading, lifecycle, OSGi/Maven | `https://raw.githubusercontent.com/lucee/lucee-docs/master/docs/technical-specs/hooks.yaml` |
| JSR-223 — `ScriptEngineFactory`, engine names, MIME types, CLI, Ant | `https://raw.githubusercontent.com/lucee/lucee-docs/master/docs/technical-specs/java-scripting.yaml` |
| Monitors — action/request/interval, `ActionMonitorCollector`, `getMonitorData()` | `https://raw.githubusercontent.com/lucee/lucee-docs/master/docs/technical-specs/monitors.yaml` |
| Maven extensions — migrating an extension from OSGi bundles to Maven | `https://raw.githubusercontent.com/lucee/lucee-docs/master/docs/technical-specs/maven-extension-migration.yaml` |
| LuCLI — CLI tool, `lucee.json`, server lifecycle, modules, secrets, deps | `https://raw.githubusercontent.com/lucee/lucee-docs/master/docs/technical-specs/lucli-spec.md` |
