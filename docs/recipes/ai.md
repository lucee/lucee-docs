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
- **Multipart Response Support**: Receive generated images and other content types from AI (currently Gemini, more providers coming soon)
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
aiSession = createAISession(name:'mychatgpt', systemMessage:"Answer as a helpful assistant.");

// Get complete response at once
answer = inquiryAISession(aiSession, "What is the capital of France?");
dump(answer);

// Stream response for real-time output
inquiryAISession(aiSession, "Count from 1 to 100", function(msg) {
    writeOutput(msg);
    cfflush(throwonerror=false);
});
```

**Note for Lucee 6.2 users**: In Lucee 6.2, all functions had the `Lucee` prefix (e.g., `LuceeCreateAISession`, `LuceeInquiryAISession`) to prevent conflicts with existing user-defined functions. Lucee 7 supports both prefixed and non-prefixed versions, so your existing code will continue to work.

### Multipart Content (Images, PDFs, Documents)

New in Lucee 7, you can send images, PDFs, and other documents along with your text prompts:
```javascript
// Create session
aiSession = createAISession(name:'myclaude');

// Send image with question
imageData = fileReadBinary(expandPath("./photo.jpg"));
answer = inquiryAISession(aiSession, [
    "What do you see in this image?",
    imageData
]);
dump(answer);

// Analyze PDF document
pdfData = fileReadBinary(expandPath("./report.pdf"));
answer = inquiryAISession(aiSession, [
    "Summarize the key points from this document",
    pdfData
]);
dump(answer);

// File path auto-detection (Lucee automatically reads the file)
answer = inquiryAISession(aiSession, [
    "Analyze this image",
    "/path/to/image.jpg"  // Lucee detects this is a file path and reads it
]);

// Multiple files
answer = inquiryAISession(aiSession, [
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
myAISession = createAISession(
    name: 'mychatgpt',
    systemMessage: "You are a helpful coding assistant.",
    temperature: 0.7,
    limit: 100  // Maximum conversation history size
);

// First question
inquiryAISession(myAISession, "What is a closure in JavaScript?");

// Follow-up question (AI remembers previous context)
inquiryAISession(myAISession, "Can you show me an example?");

// Another follow-up
inquiryAISession(myAISession, "How would that work in CFML?");
```

### Multipart Responses (Images, Files)

**New in Lucee 7** - AI can now generate images and other content types in response to your queries. Currently supported with **Gemini** (requires beta API and specific models), with other providers coming soon.

#### Configuration for Image Generation

To use image generation with Gemini, you must enable the beta API and use a compatible model:

```json
"gemini": {
  "class": "lucee.runtime.ai.google.GeminiEngine",
  "custom": {
    "message": "Keep all answers concise and accurate",
    "model": "gemini-2.5-flash-image",
    "timeout": 120000,
    "apikey": "${GEMINI_API_KEY}",
    "beta": "true"
  }
}
```

**Important Notes:**
- Set `"beta": "true"` to use the beta API endpoint (v1beta)
- Use a model that supports image generation (e.g., `gemini-2.5-flash-image`, `gemini-2.5-flash-image-preview`)
- Alternatively, you can specify the beta URL directly: `"url": "https://generativelanguage.googleapis.com/v1beta/"`
- The v1 API does not yet support image generation models

#### Using Multipart Responses

When an AI generates multipart content (text + images, multiple images, etc.), `inquiryAISession()` returns an **array** where each element represents a content part:

```javascript
aiSession = createAISession(name: 'mygemini');

// Request image generation along with text explanation
response = inquiryAISession(aiSession, [
    "Draw a developer with glasses wearing a t-shirt with this logo on it in comic noir art style and explain the image you created",
    fileReadBinary(expandPath("./logo.png"))
]);

// Handle multipart response
if (isArray(response)) {
    loop array=response item="part" {
        // Text content
        if (part.contenttype == "text/plain") {
            writeOutput("<p>#part.content#</p>");
        }
        // Image content
        else if (left(part.contenttype, 6) == "image/") {
            img = imageRead(part.content);
            writeDump(img);
            // Or save to file: fileWrite("./generated.png", part.content);
        }
        // Other content types
        else {
            writeDump(part);
        }
    }
}
else {
    // Simple text response (backward compatible)
    writeOutput(response);
}
```

#### Response Structure

Each part in the multipart response array contains:

| Property | Type | Description | Example |
|----------|------|-------------|---------|
| **contenttype** | string | MIME type of the content | `"text/plain"`, `"image/png"`, `"image/jpeg"` |
| **type** | string | Content category | `"text"` or `"binary"` |
| **content** | string or binary | The actual content | Text string or Java byte array |

#### String Conversion

The multipart response array has special string conversion behavior for convenience:

```javascript
response = inquiryAISession(aiSession, "Create an image and describe it");

// Array acts as string - concatenates all text/plain parts
echo(response);  // Outputs only text portions
writeOutput(toString(response));  // Same as above

// Still works as array for detailed handling
if (isArray(response)) {
    writeOutput("Response contains #arrayLen(response)# parts");
}
```

**Note**: This string conversion is unique to multipart AI responses - regular Lucee arrays cannot be used this way.

#### Provider Support for Multipart Responses

- **Gemini (Google)**: ✅ Full support for multipart responses
- **Claude (Anthropic)**: 🔄 Coming soon
- **ChatGPT (OpenAI)**: 🔄 Coming soon
- **Ollama**: 🔄 Coming soon

### Session Serialization

Save and restore conversation state across requests. See [AI Session Serialization](https://github.com/lucee/lucee-docs/blob/master/docs/recipes/ai-serialisation.md) for details.
```javascript
// Serialize session
serializedData = serializeAISession(myAISession);
fileWrite("session.json", serializedData);

// Load session later
restoredAISession = loadAISession('mychatgpt', fileRead("session.json"));

// Continue conversation
inquiryAISession(restoredAISession, "Can you remind me what we were discussing?");
```

### Streaming Responses

Stream responses in real-time for better user experience:
```javascript
aiSession = createAISession(name:'mygemini');

inquiryAISession(aiSession, "Write a short story about AI", function(chunk) {
    writeOutput(chunk);
    cfflush(throwonerror=false);
});
```

### Temperature Control

Control randomness/creativity of responses (0.0 = deterministic, 1.0 = creative):
```javascript
// More deterministic responses (good for factual questions)
conservativeAISession = createAISession(
    name: 'mychatgpt',
    temperature: 0.2
);

// More creative responses (good for brainstorming)
creativeAISession = createAISession(
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
answer = inquiryAISession(aiSession, augmentedQuery);
```

## Available Functions

Lucee 7 provides the following AI functions (all available with or without the `Lucee` prefix):

### Core Functions

- **`createAISession()`** / `LuceeCreateAISession()` - Create a new AI session
  - Arguments: `name`, `systemMessage`, `temperature`, `limit`, `connectTimeout`, `socketTimeout`
  
- **`inquiryAISession()`** / `LuceeInquiryAISession()` - Send a query to an AI session
  - Arguments: `session`, `question` (string or array for multipart), `listener` (optional callback)
  - Returns: String (simple text) or Array (multipart response with text/images/files)
  
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
   - Multipart responses (generated images and files from AI)
   - Session serialization for persistent conversations
   - RAG with Lucene integration

Example migration:
```javascript
// Lucee 6.2 (still works in Lucee 7)
aiSession = LuceeCreateAISession(name:'mychatgpt');
answer = LuceeInquiryAISession(aiSession, "Hello");

// Lucee 7 (cleaner syntax)
aiSession = createAISession(name:'mychatgpt');
answer = inquiryAISession(aiSession, "Hello");

// Lucee 7 (new multipart request support)
answer = inquiryAISession(aiSession, [
    "Analyze this image",
    fileReadBinary("./photo.jpg")
]);

// Lucee 7 (new multipart response support - Gemini with beta API)
response = inquiryAISession(aiSession, "Create a logo and describe it");
if (isArray(response)) {
    // Handle both text and generated images
    loop array=response item="part" {
        if (part.contenttype == "text/plain") {
            echo(part.content);
        }
        else if (left(part.contenttype, 6) == "image/") {
            fileWrite("./generated.png", part.content);
        }
    }
}
```

## Examples

### Chatbot
```javascript
aiSession = createAISession(
    name: 'mychatgpt',
    systemMessage: "You are a helpful customer service assistant."
);

form action="" method="post" {
    textarea name="question" placeholder="Ask a question...";
    button type="submit" { writeOutput("Send"); }
}

if (structKeyExists(form, "question")) {
    answer = inquiryAISession(aiSession, form.question);
    writeOutput("<div class='answer'>#answer#</div>");
}
```

### Image Analysis
```javascript
aiSession = createAISession(name:'myclaude');

// Upload form
if (structKeyExists(form, "image")) {
    answer = inquiryAISession(aiSession, [
        "Describe what you see in this image in detail",
        form.image
    ]);
    dump(answer);
}
```

### Image Generation with Description
```javascript
aiSession = createAISession(name: 'mygemini');

// Request AI to generate an image
response = inquiryAISession(aiSession, 
    "Create a logo for a coffee shop called 'Binary Beans' that combines coffee and coding themes"
);

if (isArray(response)) {
    loop array=response item="part" {
        if (part.contenttype == "text/plain") {
            writeOutput("<div class='description'>#part.content#</div>");
        }
        else if (left(part.contenttype, 6) == "image/") {
            // Save generated image
            imageFile = expandPath("./generated_logo.png");
            fileWrite(imageFile, part.content);
            writeOutput("<img src='generated_logo.png' alt='Generated Logo'>");
        }
    }
}
else {
    writeOutput(response);
}
```

### Process Input and Generate Visual Output
```javascript
aiSession = createAISession(name: 'mygemini');

// Analyze user's image and create a new variation
userImage = fileReadBinary(expandPath("./user_photo.jpg"));

response = inquiryAISession(aiSession, [
    "Analyze the style of this image and create a similar one with a mountain landscape theme",
    userImage
]);

// Extract and save generated images
if (isArray(response)) {
    imageCount = 0;
    loop array=response item="part" {
        if (left(part.contenttype, 6) == "image/") {
            imageCount++;
            fileWrite("./result_#imageCount#.png", part.content);
        }
    }
    
    // Output text explanation
    writeOutput(toString(response));  // Auto-extracts text parts
}
```

### Document Summarization
```javascript
aiSession = createAISession(name:'myclaude');

// Process PDF report
pdfPath = expandPath("./reports/Q4-2024.pdf");
summary = inquiryAISession(aiSession, [
    "Provide a brief summary of the key findings and recommendations from this report",
    pdfPath  // Lucee automatically reads the file
]);

writeOutput("<h2>Executive Summary</h2>");
writeOutput("<p>#summary#</p>");
```

### Code Review Assistant
```javascript
aiSession = createAISession(
    name: 'mychatgpt',
    systemMessage: "You are an expert CFML developer. Review code for best practices, security, and performance."
);

code = fileRead(expandPath("./mycomponent.cfc"));

review = inquiryAISession(aiSession, 
    "Review this CFML code and suggest improvements:\n\n#code#"
);

dump(review);
```

### Knowledge Base Assistant with RAG
```javascript
// Create session
aiSession = createAISession(name:'myclaude');

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
answer = inquiryAISession(aiSession, augmentedQuery);
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

- **Multipart Response Support**: Expanding support to Claude, ChatGPT, and Ollama
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