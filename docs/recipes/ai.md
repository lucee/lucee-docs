<!--
{
  "title": "AI",
  "id": "ai",
  "since": "6.2",
  "categories": ["ai"],
  "description": "AI integration for working with Large Language Models in Lucee",
  "keywords": [
    "AI",
    "LLM",
    "ChatGPT",
    "Gemini",
    "Claude",
    "Ollama",
    "RAG",
    "Multipart"
  ]
}
-->

# AI

Lucee 7 includes full support for AI integration, allowing you to interact with various Large Language Models (LLMs) directly from your CFML code. This functionality was first introduced as experimental in Lucee 6.2 and has been refined and stabilized for the Lucee 7 release.

## What's New in Lucee 7

- **Multipart Content Support**: Send images, PDFs, and other documents along with text prompts
- **Simplified Function Names**: Functions are available without the `Lucee` prefix (though the prefix is still supported as an alias for backward compatibility)
- **Stable API**: The AI functionality is no longer experimental and is ready for production use
- **Enhanced File Handling**: Automatic detection and handling of file paths in multipart requests
- **Session Serialization**: Save and restore conversation state across requests
- **RAG Support**: Retrieval-Augmented Generation with Lucene integration

## Configuration

AI connections in Lucee can be configured similarly to datasources or caches, either in the Lucee Administrator or directly in `.CFConfig.json`.

### OpenAI (ChatGPT)
```json
"ai": {
  "mychatgpt": {
    "class": "lucee.runtime.ai.openai.OpenAIEngine",
    "custom": {
      "message": "Keep all answers as short as possible",
      "secretKey": "${CHATGPT_SECRET_KEY}",
      "model": "gpt-4o",
      "type": "openai",
      "timeout": 5000
    },
    "default": "exception"
  }
}
```

### Google Gemini
```json
"ai": {
  "mygemini": {
    "class": "lucee.runtime.ai.google.GeminiEngine",
    "custom": {
      "message": "Keep all answers concise and accurate",
      "model": "gemini-1.5-flash",
      "timeout": 5000,
      "apikey": "${GEMINI_API_KEY}"
    }
  }
}
```

### Claude (Anthropic)
```json
"ai": {
  "myclaude": {
    "class": "lucee.runtime.ai.anthropic.ClaudeEngine",
    "custom": {
      "message": "Provide helpful and accurate responses",
      "model": "claude-3-5-sonnet-20241022",
      "timeout": 5000,
      "apikey": "${CLAUDE_API_KEY}"
    }
  }
}
```

### Ollama (Local)
```json
"ai": {
  "mygemma": {
    "class": "lucee.runtime.ai.openai.OpenAIEngine",
    "custom": {
      "message": "Keep all answers as short as possible",
      "model": "gemma2",
      "type": "ollama",
      "timeout": 5000
    }
  }
}
```

### Custom OpenAI-Compatible Endpoints

The `OpenAIEngine` can connect to any service using the OpenAI REST interface:
```json
"ai": {
  "custom": {
    "class": "lucee.runtime.ai.openai.OpenAIEngine",
    "custom": {
      "message": "Keep all answers short",
      "model": "custom-model",
      "url": "https://your-api.example.com/v1/",
      "secretKey": "${YOUR_API_KEY}",
      "timeout": 5000
    }
  }
}
```

### Default Types

The `default` setting determines how the AI connection is used automatically:

- `"exception"`: Used for exception analysis in error screens
- `"documentation"`: Used in the Monitor's Documentation tab
- `null` or omitted: Only available for direct function calls

## Basic Usage

### Simple Text Interaction
```javascript
// Create a session with a specific AI endpoint
session = createAISession(name:'mychatgpt', systemMessage:"Answer as a helpful assistant.");

// Get complete response at once
answer = inquiryAISession(session, "What is the capital of France?");
dump(answer);

// Stream response for real-time output
inquiryAISession(session, "Count from 1 to 100", function(msg) {
    writeOutput(msg);
    cfflush(throwonerror=false);
});
```

**Note for Lucee 6.2 users**: In Lucee 6.2, all functions had the `Lucee` prefix (e.g., `LuceeCreateAISession`, `LuceeInquiryAISession`) to prevent conflicts with existing user-defined functions. Lucee 7 supports both prefixed and non-prefixed versions, so your existing code will continue to work.

### Multipart Content (Images, PDFs, Documents)

New in Lucee 7, you can send images, PDFs, and other documents along with your text prompts:
```javascript
// Create session
session = createAISession(name:'myclaude');

// Send image with question
imageData = fileReadBinary(expandPath("./photo.jpg"));
answer = inquiryAISession(session, [
    "What do you see in this image?",
    imageData
]);
dump(answer);

// Analyze PDF document
pdfData = fileReadBinary(expandPath("./report.pdf"));
answer = inquiryAISession(session, [
    "Summarize the key points from this document",
    pdfData
]);
dump(answer);

// File path auto-detection (Lucee automatically reads the file)
answer = inquiryAISession(session, [
    "Analyze this image",
    "/path/to/image.jpg"  // Lucee detects this is a file path and reads it
]);

// Multiple files
answer = inquiryAISession(session, [
    "Compare these two images",
    fileReadBinary("./image1.jpg"),
    fileReadBinary("./image2.jpg")
]);
```

#### Supported File Types by Provider (end 2025)

**Claude (Anthropic)**:
- Images: JPEG, PNG, GIF, WebP
- Documents: PDF

**ChatGPT (OpenAI)**:
- Images: JPEG, PNG, GIF, WebP
- Documents: Support varies by model

**Gemini (Google)**:
- Images: JPEG, PNG, WebP
- Documents: PDF

**Note**: File support varies by AI provider and model. Check your provider's documentation for the most current information.

## Advanced Features

### Session Management

Sessions maintain conversation history, allowing for contextual follow-up questions:
```javascript
mySession = createAISession(
    name: 'mychatgpt',
    systemMessage: "You are a helpful coding assistant.",
    temperature: 0.7,
    limit: 100  // Maximum conversation history size
);

// First question
inquiryAISession(mySession, "What is a closure in JavaScript?");

// Follow-up question (AI remembers previous context)
inquiryAISession(mySession, "Can you show me an example?");

// Another follow-up
inquiryAISession(mySession, "How would that work in CFML?");
```

### Session Serialization

Save and restore conversation state across requests. See [AI Session Serialization](https://github.com/lucee/lucee-docs/blob/master/docs/recipes/ai-serialisation.md) for details.
```javascript
// Serialize session
serializedData = serializeAISession(mySession);
fileWrite("session.json", serializedData);

// Load session later
restoredSession = loadAISession('mychatgpt', fileRead("session.json"));

// Continue conversation
inquiryAISession(restoredSession, "Can you remind me what we were discussing?");
```

### Streaming Responses

Stream responses in real-time for better user experience:
```javascript
session = createAISession(name:'mygemini');

inquiryAISession(session, "Write a short story about AI", function(chunk) {
    writeOutput(chunk);
    cfflush(throwonerror=false);
});
```

### Temperature Control

Control randomness/creativity of responses (0.0 = deterministic, 1.0 = creative):
```javascript
// More deterministic responses (good for factual questions)
conservativeSession = createAISession(
    name: 'mychatgpt',
    temperature: 0.2
);

// More creative responses (good for brainstorming)
creativeSession = createAISession(
    name: 'mychatgpt',
    temperature: 0.9
);
```

### Retrieval-Augmented Generation (RAG)

Enhance AI responses with your own data using Lucene search integration. See [AI Augmentation with Lucene](https://github.com/lucee/lucee-docs/blob/master/docs/recipes/ai-augmentation.md) for complete details.
```javascript
// Search your indexed content
search 
    contextpassages=5
    contextBytes=4000
    name="searchResults"
    collection="knowledge_base" 
    criteria=userQuery;

// Add search results as context to AI query
augmentedQuery = "Query: #userQuery#\n\nContext: #serializeJSON(searchResults)#";
answer = inquiryAISession(session, augmentedQuery);
```

## Available Functions

Lucee 7 provides the following AI functions (all available with or without the `Lucee` prefix):

### Core Functions

- **`createAISession()`** / `LuceeCreateAISession()` - Create a new AI session
  - Arguments: `name`, `systemMessage`, `temperature`, `limit`, `connectTimeout`, `socketTimeout`
  
- **`inquiryAISession()`** / `LuceeInquiryAISession()` - Send a query to an AI session
  - Arguments: `session`, `question` (string or array for multipart), `listener` (optional callback)
  
- **`getAIMetadata()`** / `LuceeGetAIMetadata()` - Get metadata about an AI connection
  - Arguments: `name`, `refresh` (boolean)

### Serialization Functions

- **`serializeAISession()`** - Serialize an AI session to JSON
  - Arguments: `session`, `maxlength` (optional), `condense` (boolean)
  
- **`loadAISession()`** - Restore an AI session from serialized data
  - Arguments: `name`, `data` (JSON string or struct)

For complete function documentation, refer to the AI functions documentation in the Lucee Administrator.

## Built-in Integration

### Exception Handling

AI is integrated into Lucee's exception template. When an exception occurs and you have defined an AI connection with `"default": "exception"`, the AI engine will automatically analyze the exception and provide insights and suggestions for resolving the issue.
```json
"ai": {
  "mychatgpt": {
    "class": "lucee.runtime.ai.openai.OpenAIEngine",
    "custom": {
      "secretKey": "${CHATGPT_SECRET_KEY}",
      "model": "gpt-4o-mini"
    },
    "default": "exception"
  }
}
```

When an error occurs, the exception screen will include AI-generated analysis and suggestions for fixing the issue.

### Monitor Documentation

In the Lucee Administrator's Monitor Documentation tab, AI can answer questions about Lucee using retrieval-augmented generation (RAG) with the available documentation. Configure with `"default": "documentation"`.

See [AI for Documentation](https://github.com/lucee/lucee-docs/blob/master/docs/recipes/ai-for-documentation.md) for setup details.

## Security Considerations

Security is a top priority when integrating AI into Lucee.

### Local AI

Lucee supports local AI hosting through Ollama and other local providers, allowing you to run AI engines without external data transmission.

### Logging

Lucee logs all AI interactions to `ai.log`, or to `application.log` if `ai.log` is unavailable. This enables you to review what information is being transmitted to AI services.

### Best Practices

- Use environment variables for API keys (never hardcode them)
- Review AI logs regularly
- Consider using local AI for sensitive data
- Be mindful of what data you send to external AI services
- Implement rate limiting in production environments
- Filter sensitive information before sending to AI (data redaction coming in future releases)

## Migration from Lucee 6.2

If you're upgrading from Lucee 6.2 with the experimental AI features:

1. **Function names**: Your existing code using `LuceeCreateAISession`, `LuceeInquiryAISession`, etc. will continue to work. You can optionally remove the `Lucee` prefix for cleaner code.

2. **Configuration**: Your existing `.CFConfig.json` AI configurations will work without changes.

3. **New features**: You can now use:
   - Multipart content (images, PDFs) in your AI queries
   - Session serialization for persistent conversations
   - RAG with Lucene integration

Example migration:
```javascript
// Lucee 6.2 (still works in Lucee 7)
session = LuceeCreateAISession(name:'mychatgpt');
answer = LuceeInquiryAISession(session, "Hello");

// Lucee 7 (cleaner syntax)
session = createAISession(name:'mychatgpt');
answer = inquiryAISession(session, "Hello");

// Lucee 7 (new multipart support)
answer = inquiryAISession(session, [
    "Analyze this image",
    fileReadBinary("./photo.jpg")
]);
```

## Examples

### Chatbot
```javascript
session = createAISession(
    name: 'mychatgpt',
    systemMessage: "You are a helpful customer service assistant."
);

form action="" method="post" {
    textarea name="question" placeholder="Ask a question...";
    button type="submit" { writeOutput("Send"); }
}

if (structKeyExists(form, "question")) {
    answer = inquiryAISession(session, form.question);
    writeOutput("<div class='answer'>#answer#</div>");
}
```

### Image Analysis
```javascript
session = createAISession(name:'myclaude');

// Upload form
if (structKeyExists(form, "image")) {
    answer = inquiryAISession(session, [
        "Describe what you see in this image in detail",
        form.image
    ]);
    dump(answer);
}
```

### Document Summarization
```javascript
session = createAISession(name:'myclaude');

// Process PDF report
pdfPath = expandPath("./reports/Q4-2024.pdf");
summary = inquiryAISession(session, [
    "Provide a brief summary of the key findings and recommendations from this report",
    pdfPath  // Lucee automatically reads the file
]);

writeOutput("<h2>Executive Summary</h2>");
writeOutput("<p>#summary#</p>");
```

### Code Review Assistant
```javascript
session = createAISession(
    name: 'mychatgpt',
    systemMessage: "You are an expert CFML developer. Review code for best practices, security, and performance."
);

code = fileRead(expandPath("./mycomponent.cfc"));

review = inquiryAISession(session, 
    "Review this CFML code and suggest improvements:\n\n#code#"
);

dump(review);
```

### Knowledge Base Assistant with RAG
```javascript
// Create session
session = createAISession(name:'myclaude');

// User question
userQuery = "How do I configure a datasource in Lucee?";

// Search indexed documentation
search 
    contextpassages=5
    contextBytes=4000
    name="searchResults"
    collection="lucee_docs" 
    criteria=userQuery;

// Build augmented query with search results
context = [];
loop query=searchResults {
    arrayAppend(context, {
        "title": searchResults.title,
        "content": searchResults.context.passages.original
    });
}

augmentedQuery = "Question: #userQuery#\n\nRelevant Documentation:\n#serializeJSON(context)#";

// Get AI response with documentation context
answer = inquiryAISession(session, augmentedQuery);
dump(answer);
```

## Related Documentation

- **[AI Augmentation with Lucene](ai-augmentation.md)** - Implement RAG to enhance AI with your own data
- **[AI Session Serialization](ai-serialisation.md)** - Save and restore conversation state
- **[AI for Documentation](ai-for-documentation.md)** - Configure AI in the Monitor Documentation tab
- **[Lucene Extension](lucene-3-extension.md)** - Search and indexing functionality for RAG

## Future Development

AI integration in Lucee continues to be actively developed. We welcome your feedback and feature requests.

### Planned Features

- **Advanced Data Redaction**: Automatic filtering of sensitive data before sending to AI services
- **Additional Providers**: Support for more AI providers and models
- **Enhanced RAG Tools**: More built-in tools for retrieval-augmented generation
- **Fine-Tuning Support**: More functionality for customizing AI behavior

## Getting Help

- **Documentation**: Refer to the AI function documentation in the Lucee Administrator
- **Community**: Ask questions on the [Lucee Dev forum](https://dev.lucee.org)
- **Issues**: Report bugs on the [Lucee GitHub repository](https://github.com/lucee/Lucee/issues)

## See Also

- [Monitoring and Debugging](monitoring-debugging.md)
- [Lucee Administrator](lucee-administrator.md)
- [Extensions](extensions.md)