<!--
{
  "title": "AI Augmentation with Lucene",
  "id": "ai-augmentation-lucene",
  "since": "7.0",
  "categories": ["ai", "search"],
  "description": "Documentation for augmenting AI queries using Lucene search in Lucee",
  "keywords": [
    "AI",
    "LLM",
    "RAG",
    "Search",
    "Augmentation",
    "Lucene",
    "Retrieval"
  ]
}
-->

# AI Augmentation with Lucene

Lucee's AI capabilities can be enhanced with Retrieval-Augmented Generation (RAG) using the Lucene extension. 
This powerful combination allows AI models to reference your indexed content when responding to queries, creating more accurate and contextually relevant answers.

## Overview

The Lucene extension enables you to create searchable collections of content that can be used to augment AI queries with relevant context. 
This approach improves AI responses by providing domain-specific information from your data sources, whether they're local documentation, databases, external APIs, or other resources.

## Requirements

- Lucee 7.0 or higher
- Lucene Extension version 3.0 or higher (Maven-based version)
- Configured AI endpoint (see [AI Documentation](https://github.com/lucee/lucee-docs/blob/master/docs/recipes/ai.md))

## How It Works

1. A collection is created to store searchable content
2. Content is indexed from various sources (databases, files, web content, APIs, etc.)
3. When a query is sent to an AI, it's first used to search the collection for relevant information
4. The search results, including content chunks from matches, are added as context to the original query
5. The augmented query is sent to the AI endpoint, enabling more informed responses

## Implementation

Here's how to implement AI augmentation with Lucene in your Lucee application:

### Step 1: Create a Collection

Create a searchable collection to store your indexed content:

```javascript
// Define collection name
collectionName = "my_knowledge_base";

// Create if needed
collection action="list" name="local.collections";
var hasColl=false;
loop query=collections {
    if(collections.name==collectionName) {
        hasColl=true;
        break;
    }
}
if(!hasColl) {
    // Define collection directory
    var collDirectory=expandPath("{lucee-config-dir}/collections/knowledge");
    if(!directoryExists(collDirectory)) {
        directoryCreate(collDirectory,true);
    }
    // Create collection
    collection action="Create" collection=collectionName path=collDirectory;
}
```

### Step 2: Index Your Content

You can index content from virtually any source you can access in CFML:

```javascript
// Example 1: Index content from a database
function indexDatabaseContent() {
    // Query your data source
    var qryContent = queryExecute("
        SELECT 
            id AS url,
            title,
            description AS summary,
            content,
            categories AS keywords
        FROM knowledge_articles
        WHERE is_active = 1
    ");
    
    // Index the content
    index action="update" 
        type="custom"
        collection=collectionName 
        key="url"
        title="title"
        body="content,summary"
        custom1="keywords"
        query="qryContent";
}

// Example 2: Index content from files
function indexFileContent() {
    // Get list of files
    var files = directoryList(expandPath("./resources/docs"), true, "path", "*.md");
    
    // Create query object to hold file contents
    var qryFiles = queryNew("url,title,body,keywords");
    
    // Process each file
    for(var filePath in files) {
        var content = fileRead(filePath);
        var title = listLast(filePath, "/\");
        
        // Extract metadata from file content if applicable
        // This is just an example - adapt to your file format
        var keywords = "";
        if(content contains "Keywords:") {
            keywords = reMatch("Keywords:(.+?)[\r\n]", content);
            if(arrayLen(keywords)) {
                keywords = trim(replace(keywords[1], "Keywords:", ""));
            }
        }
        
        // Add to query
        queryAddRow(qryFiles);
        querySetCell(qryFiles, "url", filePath);
        querySetCell(qryFiles, "title", title);
        querySetCell(qryFiles, "body", content);
        querySetCell(qryFiles, "keywords", keywords);
    }
    
    // Index the files
    index action="update" 
        type="custom"
        collection=collectionName 
        key="url"
        title="title"
        body="body"
        custom1="keywords"
        query="qryFiles";
}

// Example 3: Index web content
function indexWebContent() {
    // Define URLs to index
    var urls = [
        "https://example.com/api/docs",
        "https://example.com/api/reference",
        "https://example.com/api/tutorials"
    ];
    
    // Create query object
    var qryWeb = queryNew("url,title,body,keywords");
    
    // Process each URL
    for(var url in urls) {
        var httpService = new http();
        httpService.setURL(url);
        var result = httpService.send().getPrefix();
        
        if(result.status_code == 200) {
            // Extract title and content (simplified example)
            var title = reMatchNoCase("<title>(.+?)</title>", result.fileContent);
            title = arrayLen(title) ? replaceNoCase(title[1], "<title>", "") : url;
            title = replaceNoCase(title, "</title>", "");
            
            // Strip HTML for indexing body
            var body = reReplaceNoCase(result.fileContent, "<[^>]*>", " ", "ALL");
            
            // Add to query
            queryAddRow(qryWeb);
            querySetCell(qryWeb, "url", url);
            querySetCell(qryWeb, "title", title);
            querySetCell(qryWeb, "body", body);
            querySetCell(qryWeb, "keywords", "api,documentation,web");
        }
    }
    
    // Index the web content
    if(qryWeb.recordCount) {
        index action="update" 
            type="custom"
            collection=collectionName 
            key="url"
            title="title"
            body="body"
            custom1="keywords"
            query="qryWeb";
    }
}
```

### Step 3: Augment AI Queries

Use the indexed content to augment AI queries with the enhanced content chunks feature in Lucene Extension 3.0:

```javascript
function augmentQuery(userQuery) {
    // Escape special characters to ensure proper search
    var criteria = rereplace(userQuery, "([+\-&|!(){}\[\]\^""~*?:\\\/])", "\\1", "ALL");
    
    // Perform search with content chunks using the new contextpassages feature
    search 
        contextpassages=5               // Number of passages to retrieve
        contextHighlightBegin="<mark>"  // Highlighting for matched terms 
        contextHighlightEnd="</mark>"
        contextBytes=4000               // Total bytes of context to retrieve
        contextpassageLength=800        // Length of each passage
        name="local.searchResults"
        collection=collectionName 
        criteria=criteria
        suggestions="always"
        maxrows=5;                      // Limit number of results

    // Format the augmented query
    var augmentedQuery = "User Query: #userQuery#";
    var contextData = [];
    
    // Process search results
    loop query=searchResults {
        // Access context passages
        var contextInfo = searchResults.context;
        var passages = contextInfo.passages;
        
        // Prepare source information
        var sourceInfo = {
            "title": searchResults.title,
            "summary": searchResults.summary,
            "score": searchResults.score,
            "passages": []
        };
        
        // Process each passage in the result
        loop query=passages {
            arrayAppend(sourceInfo.passages, {
                "score": passages.score,
                "content": passages.original
            });
        }
        
        // Add this source to our context data
        arrayAppend(contextData, sourceInfo);
    }
    
    // Only add context if we found relevant information
    if(arrayLen(contextData)) {
        augmentedQuery &= "
Context Information: #serializeJSON(contextData)#";
    }
    
    return augmentedQuery;
}
```

## Usage with AI Functions

You can integrate the augmentation functionality directly with Lucee's AI functions:

```javascript
// Create an AI session
aiSession = LuceeCreateAISession(name:"myclaude");

// User query
userQuery = "How do I optimize database queries in my application?";

// Augment the query with relevant context from indexed content
augmentedQuery = augmentQuery(userQuery);

// Send to AI with augmented context
response = LuceeInquiryAISession(aiSession, augmentedQuery);

// Display the response
echo(response);
```

## Benefits of AI Augmentation

- **Enhanced Relevance**: AI responses are informed by your specific content
- **Reduced Hallucinations**: Grounds responses in factual information from your data
- **Domain Knowledge**: AI can provide answers specific to your organization or industry
- **Content Currency**: Responses reflect your latest data, not just the AI's training cutoff
- **Customizable Context**: Index exactly what matters for your specific use case
- **Efficiency**: Better initial responses reduce the need for follow-up queries
- **Privacy**: Sensitive information stays within your system as context

## Advanced Features

### Content Chunk Optimization

The Lucene Extension 3.0 in Lucee 7 provides enhanced content chunking capabilities that allow for better context extraction:

```javascript
search 
    contextpassages=5               // Number of distinct passages to extract
    contextHighlightBegin="<mark>"  // Optional highlighting for matched terms
    contextHighlightEnd="</mark>" 
    contextBytes=5000               // Total context bytes across all passages
    contextpassageLength=1000       // Length of each individual passage
    name="local.searchResults"
    collection=collectionName 
    criteria=criteria;
```

These parameters let you fine-tune how much context is provided to the AI:

- `contextpassages`: Controls how many separate text segments are returned
- `contextBytes`: Sets the maximum total size of all context returned
- `contextpassageLength`: Controls the maximum size of each individual passage

### Content Source Flexibility

You can index virtually any content that you can access in CFML:

- Database records from any datasource
- Local files in any format (parse as needed)
- Web content from APIs or scraped pages
- Application logs or metrics
- User-generated content
- PDF, Word, or other document formats (with appropriate text extraction)
- External knowledge bases or documentation

## Security Considerations

- The augmentation process includes indexed content in queries sent to AI providers
- Use local AI endpoints (like Ollama) for sensitive data scenarios
- Implement data filtering to avoid exposing confidential information
- Consider encrypting sensitive indexed content and implementing decryption at query time
- Add audit logging for all AI interactions

## Performance Optimization

For best performance with the new Lucene Extension 3.0:

- Index strategically - focus on high-value content
- Use appropriate text segmentation for your domain
- Fine-tune search parameters like `maxrows` and `contextpassages`
- Implement caching for frequent queries
- Schedule index maintenance during low-traffic periods
- Monitor performance metrics to optimize configuration

## Examples of Use Cases

- **Customer Support**: Augment AI with product documentation, FAQs, and support history
- **Development Assistance**: Index code repositories, API docs, and coding standards
- **Knowledge Management**: Connect AI to your company's internal knowledge base
- **Training**: Create AI tutors with domain-specific knowledge from your course materials
- **Research Assistant**: Index research papers and data to enable AI analysis in your field
- **Data Analysis**: Combine AI with indexed analysis of your business metrics