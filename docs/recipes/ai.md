
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

Lucee 6.2 comes with experimental support for AI integration, which will be finalized with the release of Lucee 7. Please note that this documentation is subject to change in the future. The goal is to keep the implementation as open as possible to allow easy adaptation to future advancements in this sector.

## Configuration

Lucee 6.2 allows you to create connections to various AI engines just as easily as you would define a datasource or cache. You can configure the connection in the Lucee Administrator or directly in the `.CFConfig.json` file as shown below:

**Example for OpenAI (ChatGPT):**
```json
"mychatgpt": {
    "class": "lucee.runtime.ai.openai.OpenAIEngine",
    "custom": {
      "message": "Keep all answers as short as possible and in the style of Bob Marley",
      "secretKey": "${CHATGPT_SECRET_KEY}",
      "model": "gpt-4o-mini",
      "type": "chatgpt",
      "timeout": 2000
    },
    "default": "exception"
  }
```

**Example for Gemini (Google):**
```json
  "mygemini": {
    "class": "lucee.runtime.ai.google.GeminiEngine",
    "custom": {
      "message": "Keep all answers as short as possible",
      "model": "gemini-1.5-flash",
      "timeout": 2000,
      "apikey": "${GEMINI_API_KEY}"
    }
  }
```

**Example for Ollama (local):**
```json
  "gemma2": {
      "class": "lucee.runtime.ai.openai.OpenAIEngine",
      "custom": {
        "message": "Keep all answers as short as possible",
        "model": "gemma2",
        "type": "ollama",
        "timeout": 1000
      }
    }
```

In these examples, we establish connections to three types of AI engines: ChatGPT from OpenAI, Gemini from Google, and Ollama, which can be run locally. For Ollama, you can use the OpenAI driver since it has the same interface. For credentials, you can use environment variable placeholders, as shown in the examples. 

Currently, the interface for creating drivers is internal to the core, but with Lucee 7, we plan to make it available for external use, allowing you to create or use extensions for additional drivers.

## Security

Security is a top priority when integrating AI into Lucee. Since AI is already widely used, our goal is to improve security by offering more formalized interfaces for AI interaction.

### Local AI

Lucee allows you to use local AI, meaning you can host AI engines yourself for certain tasks or even all tasks, ensuring that no information leaves your environment.

### Data Redaction (Work in Progress)

Lucee enables the filtering of sensitive information from data sent to AI, such as hardcoded usernames, passwords, or any other sensitive data. However, this functionality is still limited and is a work in progress.

### Logging

Lucee logs all data sent to any AI engine in the `ai.log`, so you can review what information has been transmitted.

## Integration

Similar to how caches are supported in Lucee, AI can be used in two ways: directly via tags and functions, or indirectly by linking it to certain Lucee functionalities. Currently, the only indirect integration is within the error template, but we are working on other integrations such as local documentation.

### Direct Integration

You can directly interact with AI using tags and functions. This feature is a work in progress, and we will continue expanding it.

**Example of a Simple AI Interaction:**

At the moment, these functions use the prefix `Lucee` to avoid conflicts with existing functions in your code. With Lucee 7, we plan to remove the prefix while still supporting it as a hidden feature.
```javascript
slim = LuceeCreateAISession(name:'gemma2', systemMessage:"Answer as Slim Shady.");

// Get the entire response at once
dump(LuceeInquiryAISession(slim, "Who was the most influential person in your life?"));

// Stream the response
dump(LuceeInquiryAISession(slim, "Count from 1 to 100", function(msg) {
    dump(msg);
    cfflush(throwonerror=false);
}));
```
This does not cover all available functionality, so refer to the AI documentation tab in Lucee for a complete list of functions and tags.

### Exception Handling

The first AI integration in Lucee is with the exception template. 
When the exception template (orange screen) is displayed and you have defined an AI connection with the default type "exception", that AI engine will be used to analyze the exception. 
Lucee provides the AI with information about the exception, allowing it to offer insights and suggestions for resolving the issue. 
This feature is still a work in progress, and we are working to improve the quality of the AI responses by refining the input.

## Future Development

The current AI integration is still in development, and we are continually working to enhance the existing functionality and introduce new features.

### Retrieval-Augmented Generation (RAG)

We are working on supporting RAG directly in CFML, enabling you to index local data and integrate it into your AI interactions.

### Fine-Tuning

We are adding more functionality to allow fine-tuning of AI connections for improved results.

### Data Redaction

We are also working on support for advanced data redaction, which will not only be available with AI but as a standalone feature that can be used in other scenarios.
