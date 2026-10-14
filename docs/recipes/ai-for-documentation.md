<!--
{
  "title": "AI Integration for Documentation (Experimental)",
  "id": "ai-documentation-setup",
  "since": "6.2",
  "categories": [ "ai" ],
  "description": "Guide to configuring AI / LLM for use in Lucee's Documentation tab.",
  "keywords": [
    "AI",
    "LLM",
    "documentation",
    "configuration",
    "Monitor",
    "experimental",
    "admin settings",
    "AI engines",
    "OpenAI",
    "Gemini",
    "Ollama"
  ],
  "related": [
    "ai-augmentation-lucene",
    "ai"
  ]
}
-->

# AI in Documentation (Experimental)

Lucee 6.2 introduces experimental support for AI / LLM (Large Language Model) driven assistance in the Documentation tab of Lucee’s Monitor, aiming to provide intelligent guidance by connecting to various AI engines. 

This feature will see further refinement in Lucee 7. 

For an overview of Lucee's AI capabilities, see the [general AI documentation](https://github.com/lucee/lucee-docs/blob/master/docs/recipes/ai.md).

## Configuration for AI in Monitor/Documentation

To enable AI in the Documentation tab of the Monitor, set up a compatible AI connection in the Lucee Administrator or via the `.CFConfig.json` file. 

Configurations for OpenAI (ChatGPT), Google Gemini, or local services like Ollama are possible.

### Example Configuration

Below are example configurations to enable AI functionality in the Documentation tab, important here is the `default` setting.

**OpenAI (ChatGPT) Configuration Example:**

```json
"ai": {
  "docChatGPT": {
    "class": "lucee.runtime.ai.openai.OpenAIEngine",
    "custom": {
      "message": "Provide concise, accurate answers",
      "secretKey": "${CHATGPT_SECRET_KEY}",
      "model": "gpt-4",
      "type": "openai",
      "timeout": 2000
    },
    "default": "documentation"
  }
}
```