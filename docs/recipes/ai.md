<!--
{
  "title": "AI (experimental)",
  "id": "ai",
  "description": "",
  "keywords": [
    "AI",
    "LLM"
  ]
}
-->

# AI (Experimental)

Lucee 6.2 includes experimental support for AI integration, which will be finalized with the release of Lucee 7. This documentation is subject to change, reflecting Lucee's aim to remain adaptable to future advancements. Feedback is welcome to help tailor functionality to users' needs.

## Configuration

In Lucee 6.2, AI connections can be configured similarly to datasources or caches, either in the Lucee Administrator or directly in `.CFConfig.json`. Here are sample configurations:

**OpenAI (ChatGPT) Example:**
```json
"ai": {
  "mychatgpt": {
    "class": "lucee.runtime.ai.openai.OpenAIEngine",
    "custom": {
      "message": "Keep all answers as short as possible and in the style of Bob Marley",
      "secretKey": "${CHATGPT_SECRET_KEY}",
      "model": "gpt-4o-mini",
      "type": "openai",
      "timeout": 2000
    },
    "default": "exception"
  }
}
```

**Google Gemini Example:**
```json
"ai": {
  "mygemini": {
    "class": "lucee.runtime.ai.google.GeminiEngine",
    "custom": {
      "message": "Keep all answers as short as possible and in the style of Slim Shady",
      "model": "gemini-1.5-flash",
      "timeout": 2000,
      "apikey": "${GEMINI_API_KEY}"
    }
  }
}
```

**Ollama (Local) Example:**
```json
"ai": {
  "gemma2": {
    "class": "lucee.runtime.ai.openai.OpenAIEngine",
    "custom": {
      "message": "Keep all answers as short as possible",
      "model": "gemma2",
      "type": "ollama",
      "timeout": 1000
    }
  }
}
```

In these examples, ChatGPT from OpenAI, Gemini from Google, and Ollama for local use are set up. The `OpenAIEngine` allows configuration for `openai` or `ollama` types and can also connect to any service using the OpenAI REST interface by specifying a URL:

**OpenAI REST Interface Example:**
```json
"ai": {
  "lucy": {
    "class": "lucee.runtime.ai.openai.OpenAIEngine",
    "custom": {
      "message": "Keep all answers short and in the style of Lucy Miller",
      "model": "lucy",
      "url": "https://ai.lucee.org/v1/",
      "timeout": 1000
    }
  }
}
```

Currently, driver creation is internal, but Lucee 7 will expand support for creating or using extensions with additional drivers.

## Security

Security is a top priority when integrating AI into Lucee. Since AI is already widely used, our goal is to improve security by offering more formalized interfaces for AI interaction.

### Local AI

Lucee supports local AI hosting, which means you can run AI engines without external data transmission.

### Data Redaction (Work in Progress)

Future releases will further refine data redaction, filtering out sensitive data such as hardcoded usernames and passwords before sending it to an AI engine.

### Logging

Lucee logs all AI interactions to `ai.log`, or to `application.log` if `ai.log` is unavailable, enabling review of transmitted information.

## Integration

AI in Lucee can be used either directly through tags and functions or indirectly by linking it to certain functionalities, like error handling or monitoring.

### Direct Integration

You can interact with AI directly via Lucee functions and tags. 
At the moment, these functions use the prefix `Lucee` to avoid conflicts with existing functions in your code. With Lucee 7, we plan to remove the prefix (but still support it as an alias).

**Direct Interaction Example:**
```javascript
// start a session with a specic AI endpoint
slim = LuceeCreateAISession(name:'gemma2', systemMessage:"Answer as Slim Shady.");

// Complete response at once
dump(LuceeInquiryAISession(slim, "Who was the most influential person in your life?"));

// Stream response
dump(LuceeInquiryAISession(slim, "Count from 1 to 100", function(msg) {
    dump(msg);
    cfflush(throwonerror=false);
}));
```

This does not cover all available functionality; refer to the AI documentation tab in Lucee for the complete list of functions and tags.

### Exception Handling

AI is already integration in Lucee in the exception template. 
When the exception template (orange screen) is displayed and you have defined an AI connection with the default type "exception", that AI engine will be used to analyze the exception. 
Lucee provides the AI with information about the exception, allowing it to offer insights and suggestions for resolving the issue. 
This feature is still a work in progress, and we are working to improve the quality of the AI responses by refining the input.

### Monitor Documentation Tab

In the Monitor's Documentation tab, AI can answer questions about Lucee based on retrieval-augmented generation (RAG) with available documentation and links to related documents. 
This feature is also in development for enhanced input quality (read more about Monitor Documentation here https://github.com/lucee/lucee-docs/blob/master/docs/recipes/monitoring-debugging.md).

## Future Development

AI integration in Lucee is actively being developed, with plans to expand functionality and add new features. Your input is encouraged.

### Retrieval-Augmented Generation (RAG)

We are working on RAG support directly in CFML, allowing local data indexing for AI interactions.

### Fine-Tuning

We are adding more functionality to allow fine-tuning of AI connections for improved results.

### Data Redaction

We are also working on support for advanced data redaction, which will not only be available with AI but as a standalone feature that can be used in other scenarios.
