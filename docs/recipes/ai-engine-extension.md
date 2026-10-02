<!--
{
  "title": "Creating an Extension that Provides an AI Engine",
  "id": "ai-engine-extension",
  "since": "7.0",
  "categories": ["ai", "extensions", "java"],
  "description": "How to implement the AI interfaces from the Lucee loader in your own Java engine, package it as an extension and use it with createAISession()",
  "keywords": [
    "AI",
    "LLM",
    "AIEngine",
    "AISession",
    "extension",
    "loader",
    "OSGi",
    "Maven",
    "lex",
    "custom AI provider",
    "virtual file system"
  ],
  "related": [
    "ai",
    "loader-api-changes-7",
    "virtual-file-system",
    "maven-based-extensions",
    "extension-installation",
    "extension-utilities",
    "ai-session-serialization"
  ]
}
-->

# Creating an Extension that Provides an AI Engine

Lucee's AI functions (`createAISession()`, `inquiryAISession()`, ...) do not talk to a provider directly. They work against a set of public interfaces, and every AI connection you configure points to a Java class that implements them. Lucee ships a few implementations, and an extension can provide more.

This recipe shows how to write such an engine, package it as an extension and use it from CFML. For configuring and using the built-in engines, see [[ai]].

## Like Virtual File Systems

AI was designed to be extended the same way as Lucee's [[virtual-file-system]]:

| | Virtual file systems | AI engines |
| --- | --- | --- |
| Public interface (loader) | `lucee.commons.io.res.ResourceProvider` | `lucee.runtime.ai.AIEngine` and `lucee.runtime.ai.AISession` |
| Implementations in core | `file`, `ram`, `zip`, `tar`, `http`, ... | `OpenAIEngine` (also Ollama and other OpenAI compatible APIs), `GeminiEngine`, `ClaudeEngine` |
| Implementations in extensions | S3 (`S3ResourceProvider` in the [S3 extension](https://github.com/lucee/extension-s3)) | your engine |

The interfaces are part of the loader (the public API used by extensions) since Lucee **7.0.0.114** ([LDEV-5368](https://luceeserver.atlassian.net/browse/LDEV-5368), see [[loader-api-changes-7]]). In Lucee 6.2 they were still part of core, so an engine provided by an extension needs Lucee 7.0.0.114 or newer.

The engines in core need no library beyond what core already ships: they use the Apache HttpClient that core also uses for `cfhttp`, and Lucee's own JSON handling. There is no AI SDK involved, which keeps them small. An engine in an extension can do the same, or bring whatever library it needs.

One difference to VFS: an extension can register a resource provider in its manifest (`resource:`), but there is **no manifest key for AI engines**. After installing the extension, an AI connection that points to the engine class has to be configured (see [Registering the Engine](#registering-the-engine)).

## The Interfaces

All interfaces are in the package `lucee.runtime.ai` of the loader (`lucee.jar`). They are the same in Lucee 7.0, 7.1 and 8.0.

| Interface | Implement | Purpose |
| --- | --- | --- |
| `AIEngine` | yes | One configured AI connection; creates sessions |
| `AISession` | yes | A conversation with history |
| `Response` | yes | The answer to one inquiry |
| `Request` | yes | The question of one inquiry (kept in the history) |
| `Conversation` | yes | One request/response pair of the history |
| `AIModel` | optional | Models returned by `getModels()` |
| `AISessionMultiParts` | optional | Multipart questions (images, PDFs, ...) passed as an array to `inquiryAISession()` |
| `Part` | optional | One part of a multipart question or answer |
| `AIEmbeddingSession` | optional | `float[] getEmbeddings(String text)` |
| `AIEngineFile` / `AIFile` | optional | File handling (upload, list, delete) |
| `AIResponseListener` | no, Lucee passes it in | Receives streamed chunks |

The classes in core with names like `AIEngineSupport`, `AISessionSupport` or `AIUtil` are internal helpers of the core engines, not part of the public API. Implement the interfaces directly.

`AIEngine`:

```java
public interface AIEngine {
	public static final int DEFAULT_CONNECT_TIMEOUT = -1;
	public static final int DEFAULT_SOCKET_TIMEOUT = -1;

	AIEngine init(ClassDefinition<? extends AIEngine> cd, Struct properties, String name, String _default, String id) throws PageException;
	public String getId();
	public AISession createSession(String initialMessage, Conversation[] history, int limit, double temp, int connectTimeout, int socketTimeout) throws PageException;
	public int getSocketTimeout();
	public int getConnectTimeout();
	public String getLabel();
	public String getModel();
	public List<AIModel> getModels() throws PageException;
	public List<AIModel> getModels(List<AIModel> defaultValue);
	public int getConversationSizeLimit();
	public Double getTemperature();
	public String getDefault();
	public String getName();
	public ClassDefinition<? extends AIEngine> getClassDefinition();
	public Struct getProperties();
}
```

`AISession`, `Response`, `Request` and `Conversation`:

```java
public interface AISession {
	public Response inquiry(String message) throws PageException;
	public Response inquiry(String message, AIResponseListener listener) throws PageException;
	public String getSystemMessage();
	public Conversation[] getHistory();
	public String getId();
	public AIEngine getEngine();
	public int getConversationSizeLimit();
	public Double getTemperature();
	public int getSocketTimeout();
	public int getConnectTimeout();
	public void release() throws PageException;
}

public interface Response {
	public long getTotalTokenUsed();
	public String getAnswer();
	public List<Part> getAnswers();
	public boolean isMultiPart();
}

public interface Request {
	public String getQuestion();
	public List<Part> getQuestions();
	public boolean isMultiPart();
}

public interface Conversation {
	public Request getRequest();
	public Response getResponse();
}
```

How Lucee calls these:

- `init()` gets the `custom` struct of the AI connection as `properties` (it can be `null` if the connection has none), the connection name, the `default` setting (for example `"exception"`) and an id.
- `createSession()` is called by `createAISession()` and `loadAISession()`. As with the core engines, treat an empty `initialMessage` as "use the configured system message", `limit` and `temp` values of `0` or less as "use the engine setting", and timeouts below `0` as "use the engine setting". `history` is set when a session is restored with `loadAISession()`.
- `inquiryAISession()` with a string calls `inquiry(String)`, or `inquiry(String, AIResponseListener)` when a listener function is passed. Call `listener.listen(String part, int chunkIndex, boolean isComplete)` for every chunk you receive.
- `inquiryAISession()` with an array needs a session that implements `AISessionMultiParts`; otherwise the call fails.
- `getAnswers()` must not return `null`. For a text answer, return an empty list and Lucee uses `getAnswer()`.
- `getModels()` is used by `AIGetMetaData(name, true)` and the Administrator. Return an empty list if the provider has no model list.

## A Minimal Engine

The following engine connects to any endpoint with an OpenAI compatible `chat/completions` API (for example a local Ollama). It uses only the JDK (`java.net.http.HttpClient`) and the loader API (`CFMLEngineFactory`, `Cast`, `Creation`), so the extension needs no other library. It doesn't do streaming, multipart content or model lists, so it can stay short.

`SimpleChatEngine.java`:

```java
package com.example.ai;

import java.util.ArrayList;
import java.util.List;

import lucee.loader.engine.CFMLEngineFactory;
import lucee.runtime.ai.AIEngine;
import lucee.runtime.ai.AIModel;
import lucee.runtime.ai.AISession;
import lucee.runtime.ai.Conversation;
import lucee.runtime.db.ClassDefinition;
import lucee.runtime.exp.PageException;
import lucee.runtime.type.Struct;
import lucee.runtime.util.Cast;
import lucee.runtime.util.Creation;

/**
 * Minimal AI engine for an OpenAI compatible "chat/completions" endpoint.
 */
public class SimpleChatEngine implements AIEngine {

	private ClassDefinition<? extends AIEngine> cd;
	private Struct properties;
	private String name, _default, id;

	String url, apiKey, model, systemMessage;
	private int connectTimeout, socketTimeout, conversationSizeLimit;
	private Double temperature;

	@Override
	public AIEngine init(ClassDefinition<? extends AIEngine> cd, Struct properties, String name, String _default, String id) throws PageException {
		Cast cast = CFMLEngineFactory.getInstance().getCastUtil();
		Creation c = CFMLEngineFactory.getInstance().getCreationUtil();
		if (properties == null) properties = c.createStruct();
		this.cd = cd;
		this.properties = properties;
		this.name = name;
		this._default = _default;
		this.id = id;

		// the "custom" struct of the "ai" entry, empty values (for example from the Administrator) mean "not set"
		url = str(cast, c, properties, "url", "http://localhost:11434/v1/");
		if (!url.endsWith("/")) url += "/";
		apiKey = str(cast, c, properties, "apikey", null);
		model = str(cast, c, properties, "model", null);
		systemMessage = str(cast, c, properties, "message", null);
		connectTimeout = cast.toIntValue(properties.get(c.createKey("connectTimeout"), null), 3000);
		socketTimeout = cast.toIntValue(properties.get(c.createKey("socketTimeout"), null), 60000);
		conversationSizeLimit = cast.toIntValue(properties.get(c.createKey("conversationSizeLimit"), null), 50);
		String t = str(cast, c, properties, "temperature", null);
		temperature = t == null ? null : cast.toDouble(t, null);
		return this;
	}

	private static String str(Cast cast, Creation c, Struct properties, String key, String defaultValue) {
		String value = cast.toString(properties.get(c.createKey(key), null), null);
		return value == null || value.trim().isEmpty() ? defaultValue : value.trim();
	}

	@Override
	public AISession createSession(String initialMessage, Conversation[] history, int limit, double temp, int connectTimeout, int socketTimeout) throws PageException {
		// same conventions as the core engines: empty message, limit <= 0, temp <= 0 and timeouts < 0 mean "use the engine setting"
		String sysMsg = initialMessage == null || initialMessage.trim().isEmpty() ? systemMessage : initialMessage.trim();
		return new SimpleChatSession(this, sysMsg, history, limit > 0 ? limit : conversationSizeLimit, temp > 0 ? Double.valueOf(temp) : temperature,
				connectTimeout >= 0 ? connectTimeout : this.connectTimeout, socketTimeout >= 0 ? socketTimeout : this.socketTimeout);
	}

	@Override
	public List<AIModel> getModels() throws PageException {
		return new ArrayList<>(); // optional, never return null
	}

	@Override
	public List<AIModel> getModels(List<AIModel> defaultValue) {
		try {
			return getModels();
		}
		catch (PageException e) {
			return defaultValue;
		}
	}

	@Override public String getId() { return id; }
	@Override public String getLabel() { return "Simple Chat"; }
	@Override public String getModel() { return model; }
	@Override public int getConnectTimeout() { return connectTimeout; }
	@Override public int getSocketTimeout() { return socketTimeout; }
	@Override public int getConversationSizeLimit() { return conversationSizeLimit; }
	@Override public Double getTemperature() { return temperature; }
	@Override public String getDefault() { return _default; }
	@Override public String getName() { return name; }
	@Override public ClassDefinition<? extends AIEngine> getClassDefinition() { return cd; }
	@Override public Struct getProperties() { return properties; }
}
```

`SimpleChatSession.java`:

```java
package com.example.ai;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.UUID;

import lucee.loader.engine.CFMLEngine;
import lucee.loader.engine.CFMLEngineFactory;
import lucee.runtime.ai.AIEngine;
import lucee.runtime.ai.AIResponseListener;
import lucee.runtime.ai.AISession;
import lucee.runtime.ai.Conversation;
import lucee.runtime.ai.Part;
import lucee.runtime.ai.Request;
import lucee.runtime.ai.Response;
import lucee.runtime.exp.PageException;
import lucee.runtime.type.Array;
import lucee.runtime.type.Struct;
import lucee.runtime.util.Cast;
import lucee.runtime.util.Creation;

public class SimpleChatSession implements AISession {

	private final SimpleChatEngine engine;
	private final String systemMessage;
	private final List<Conversation> history = new ArrayList<>();
	private final int limit, connectTimeout, socketTimeout;
	private final Double temperature;
	private final String id = UUID.randomUUID().toString();

	SimpleChatSession(SimpleChatEngine engine, String systemMessage, Conversation[] history, int limit, Double temperature, int connectTimeout, int socketTimeout) {
		this.engine = engine;
		this.systemMessage = systemMessage;
		if (history != null) this.history.addAll(Arrays.asList(history));
		this.limit = limit;
		this.temperature = temperature;
		this.connectTimeout = connectTimeout;
		this.socketTimeout = socketTimeout;
	}

	@Override
	public Response inquiry(String message) throws PageException {
		return inquiry(message, null);
	}

	@Override
	public Response inquiry(String message, AIResponseListener listener) throws PageException {
		CFMLEngine eng = CFMLEngineFactory.getInstance();
		Cast cast = eng.getCastUtil();
		Creation c = eng.getCreationUtil();
		try {
			// {"model":"...","messages":[{"role":"system","content":"..."},{"role":"user","content":"..."}]}
			Array messages = c.createArray();
			if (systemMessage != null && !systemMessage.isEmpty()) messages.append(message(c, "system", systemMessage));
			for (Conversation conv: history) {
				messages.append(message(c, "user", conv.getRequest().getQuestion()));
				messages.append(message(c, "assistant", conv.getResponse().getAnswer()));
			}
			messages.append(message(c, "user", message));
			Struct body = c.createStruct();
			if (engine.model != null) body.set(c.createKey("model"), engine.model);
			if (temperature != null) body.set(c.createKey("temperature"), temperature);
			body.set(c.createKey("messages"), messages);

			HttpRequest.Builder req = HttpRequest.newBuilder(URI.create(engine.url + "chat/completions"))
					.header("Content-Type", "application/json")
					.POST(HttpRequest.BodyPublishers.ofString(cast.fromStructToJsonString(body)));
			if (socketTimeout > 0) req.timeout(Duration.ofMillis(socketTimeout));
			if (engine.apiKey != null) req.header("Authorization", "Bearer " + engine.apiKey);
			HttpClient.Builder client = HttpClient.newBuilder();
			if (connectTimeout > 0) client.connectTimeout(Duration.ofMillis(connectTimeout));

			HttpResponse<String> rsp = client.build().send(req.build(), HttpResponse.BodyHandlers.ofString());
			if (rsp.statusCode() != 200) {
				throw eng.getExceptionUtil().createApplicationException("AI request failed with status [" + rsp.statusCode() + "]", rsp.body());
			}

			// {"choices":[{"message":{"content":"..."}}],"usage":{"total_tokens":123}}
			Struct data = cast.fromJsonStringToStruct(rsp.body());
			Struct first = cast.toStruct(cast.toArray(data.get(c.createKey("choices"))).getE(1));
			String answer = cast.toString(cast.toStruct(first.get(c.createKey("message"))).get(c.createKey("content")));
			Struct usage = cast.toStruct(data.get(c.createKey("usage"), null), null);
			long tokens = usage == null ? 0 : cast.toLongValue(usage.get(c.createKey("total_tokens"), null), 0);

			// no streaming in this example: the whole answer is passed to the listener as one chunk
			if (listener != null) listener.listen(answer, 0, true);

			SimpleResponse response = new SimpleResponse(answer, tokens);
			history.add(new SimpleConversation(new SimpleRequest(message), response));
			while (limit > 0 && history.size() > limit) history.remove(0);
			return response;
		}
		catch (PageException pe) {
			throw pe;
		}
		catch (Exception e) {
			throw cast.toPageException(e);
		}
	}

	private static Struct message(Creation c, String role, String content) throws PageException {
		Struct sct = c.createStruct();
		sct.set(c.createKey("role"), role);
		sct.set(c.createKey("content"), content);
		return sct;
	}

	@Override public String getSystemMessage() { return systemMessage; }
	@Override public Conversation[] getHistory() { return history.toArray(new Conversation[0]); }
	@Override public String getId() { return id; }
	@Override public AIEngine getEngine() { return engine; }
	@Override public int getConversationSizeLimit() { return limit; }
	@Override public Double getTemperature() { return temperature; }
	@Override public int getSocketTimeout() { return socketTimeout; }
	@Override public int getConnectTimeout() { return connectTimeout; }
	@Override public void release() throws PageException {}

	static class SimpleRequest implements Request {
		private final String question;
		SimpleRequest(String question) { this.question = question; }
		@Override public String getQuestion() { return question; }
		@Override public List<Part> getQuestions() { return new ArrayList<>(); }
		@Override public boolean isMultiPart() { return false; }
	}

	static class SimpleResponse implements Response {
		private final String answer;
		private final long tokens;
		SimpleResponse(String answer, long tokens) { this.answer = answer; this.tokens = tokens; }
		@Override public String getAnswer() { return answer; }
		@Override public List<Part> getAnswers() { return new ArrayList<>(); } // never null, Lucee then uses getAnswer()
		@Override public boolean isMultiPart() { return false; }
		@Override public long getTotalTokenUsed() { return tokens; }
	}

	static class SimpleConversation implements Conversation {
		private final Request request;
		private final Response response;
		SimpleConversation(Request request, Response response) { this.request = request; this.response = response; }
		@Override public Request getRequest() { return request; }
		@Override public Response getResponse() { return response; }
	}
}
```

Compile it against the Lucee jar (`lucee.jar` or `org.lucee:lucee` as a `provided` dependency, plus the Jakarta JSP API, which `PageException` extends). Java 11 is enough for `java.net.http`.

## Packaging as an Extension

An extension is a `.lex` file (a ZIP archive) with an extension manifest in `META-INF/MANIFEST.MF`. The engine classes can be shipped as an OSGi bundle or, since Lucee 7, as a Maven artifact. See [[maven-based-extensions]] for the build setup.

### OSGi Bundle

The jar needs OSGi headers in its own manifest:

```
Manifest-Version: 1.0
Bundle-ManifestVersion: 2
Bundle-SymbolicName: com.example.ai.simplechat
Bundle-Version: 1.0.0.0
Bundle-Name: Simple Chat AI Engine
Export-Package: com.example.ai
```

Put it in the `jars/` folder of the extension (the optional `context/` folder for an Administrator driver is described [below](#where-the-driver-goes)):

```
simple-chat-ai-1.0.0.0.lex
├── META-INF/
│   └── MANIFEST.MF
└── jars/
    └── com.example.ai.simplechat-1.0.0.0.jar
```

`META-INF/MANIFEST.MF` of the extension:

```
Manifest-Version: 1.0
id: "B7A3D2C1-5E4F-4A6B-9C8D7E6F5A4B3C2D"
version: "1.0.0.0"
name: "Simple Chat AI Engine"
description: "AI engine for OpenAI compatible endpoints"
lucee-core-version: "7.0.0.114"
release-type: server
```

Use your own UUID for `id`.

### Maven

With `start-bundles: false`, the jar is a plain jar (no OSGi headers) stored in the `maven/` folder in Maven repository layout:

```
simple-chat-ai-1.0.0.0.lex
├── META-INF/
│   └── MANIFEST.MF
└── maven/
    └── com/example/simple-chat-ai/1.0.0.0/
        ├── simple-chat-ai-1.0.0.0.jar
        └── simple-chat-ai-1.0.0.0.pom
```

```
Manifest-Version: 1.0
id: "C8B4E3D2-6F5A-4B7C-AD9E8F7A6B5C4D3E"
version: "1.0.0.0"
name: "Simple Chat AI Engine"
description: "AI engine for OpenAI compatible endpoints"
lucee-core-version: "7.0.0.114"
release-type: server
start-bundles: false
```

Install the extension like any other, see [[extension-installation]].

## Registering the Engine

Installing the extension only makes the classes available. Unlike `resource:`, `cache:` or `jdbc:`, there is no manifest key that registers an AI engine, so an AI connection that points to the class has to be added to `.CFConfig.json`, or created in the Administrator if the extension provides a driver (see [Providing an Administrator Form](#providing-an-administrator-form)). The class is located with the usual class definition keys:

| Key | Alternatives | Meaning |
| --- | --- | --- |
| `class` | `classname`, `class-name` | Fully qualified class name of the `AIEngine` implementation |
| `bundleName` | `bundle-name` | `Bundle-SymbolicName` of the OSGi bundle |
| `bundleVersion` | `bundle-version` | `Bundle-Version` of the OSGi bundle |
| `maven` | | Maven coordinates (`groupId:artifactId:version`), used instead of `bundleName`/`bundleVersion` |

The settings for the engine go into `custom` (`properties` and `arguments` are accepted as well); this struct is passed to `init()`. `default` works as for the built-in engines (see [[ai]]).

OSGi bundle:

```json
"ai": {
  "mychat": {
    "class": "com.example.ai.SimpleChatEngine",
    "bundleName": "com.example.ai.simplechat",
    "bundleVersion": "1.0.0.0",
    "custom": {
      "url": "http://localhost:11434/v1/",
      "model": "gemma2",
      "message": "Keep all answers as short as possible"
    }
  }
}
```

Maven artifact:

```json
"ai": {
  "mychat": {
    "class": "com.example.ai.SimpleChatEngine",
    "maven": "com.example:simple-chat-ai:1.0.0.0",
    "custom": {
      "url": "https://api.example.com/v1/",
      "apikey": "${MY_AI_API_KEY}",
      "model": "my-model"
    }
  }
}
```

The same struct can also be defined per application with `this.ai` in `Application.cfc`.

## Providing an Administrator Form

The Administrator (Services > AI) offers a form for each engine it has an **admin driver** for. A driver is just a small component that describes the engine and the fields of its form. Each of the three built-in engines has one, and an extension can add its own by copying a CFC into the AI driver folder of the server context. The user then gets the same kind of form for your engine as for the built-in ones. A driver is optional; without one, the engine is configured in `.CFConfig.json` only.

### The Built-in Drivers

The drivers are in the Lucee source in `core/src/main/java/resource/context/admin/aidriver/` (links to the 7.1 branch):

| File | Purpose |
| --- | --- |
| [`AI.cfc`](https://github.com/lucee/Lucee/blob/7.1/core/src/main/java/resource/context/admin/aidriver/AI.cfc) | Base component of all drivers, provides `field()`, `group()` and `getCustomFields()` |
| [`Field.cfc`](https://github.com/lucee/Lucee/blob/7.1/core/src/main/java/resource/context/admin/aidriver/Field.cfc) | One form field |
| [`Group.cfc`](https://github.com/lucee/Lucee/blob/7.1/core/src/main/java/resource/context/admin/aidriver/Group.cfc) | A heading that groups the following fields |
| [`OpenAI.cfc`](https://github.com/lucee/Lucee/blob/7.1/core/src/main/java/resource/context/admin/aidriver/OpenAI.cfc) | Driver for `lucee.runtime.ai.openai.OpenAIEngine` |
| [`Gemini.cfc`](https://github.com/lucee/Lucee/blob/7.1/core/src/main/java/resource/context/admin/aidriver/Gemini.cfc) | Driver for `lucee.runtime.ai.google.GeminiEngine` |
| [`Claude.cfc`](https://github.com/lucee/Lucee/blob/7.1/core/src/main/java/resource/context/admin/aidriver/Claude.cfc) | Driver for `lucee.runtime.ai.anthropic.ClaudeEngine` |

The Administrator page ([`services.ai.cfm`](https://github.com/lucee/Lucee/blob/7.1/core/src/main/cfml/context/admin/services.ai.cfm)) loads every component in the package `lucee-server.admin.aidriver` (except `AI`, `Field` and `Group`) and keys the drivers by the class name returned by `getClass()`. The form itself is rendered by [`services.ai.create.cfm`](https://github.com/lucee/Lucee/blob/7.1/core/src/main/cfml/context/admin/services.ai.create.cfm).

### What a Driver Contains

A driver extends `AI` (the base component in the same folder) and defines its fields in `variables.fields`. Always extend `AI`, as the Administrator calls functions of the base component (in Lucee 8, for example, `getPassthroughShortcuts()`).

| Function | Required | Purpose |
| --- | --- | --- |
| `getClass()` | yes | Class name of the engine, stored as `class` |
| `getLabel()` | yes | Name shown in the list of AI types and connections |
| `getDescription()` | yes | Description shown in the list and on the form |
| `getBundleName()` | for OSGi | `Bundle-SymbolicName` of the bundle, stored as `bundleName` |
| `getBundleVersion()` | for OSGi | `Bundle-Version` of the bundle, stored as `bundleVersion` |
| `getLabelLong()` | no | Longer label for the list of AI types and the form heading |
| `getCustomFields()` | inherited | Returns `variables.fields` |

The built-in drivers don't define `getBundleName()`/`getBundleVersion()` because their engines are part of core. An engine from an extension needs them, otherwise the Administrator can't load the class.

Fields are created with `field(displayName, name, defaultValue, required, description, type, values)`:

- `name` is the key in `custom`, the struct that is passed to `init()` of the engine.
- `type` is one of `text`, `password`, `textarea`, `select`, `radio`, `checkbox` or `time`. Password values are shown obfuscated in the form.
- `values` is a comma separated list of options for `select`, `radio` and `checkbox`.

`group(displayName, description)` adds a heading between fields.

A minimal driver for the engine above, `SimpleChat.cfc`:

```javascript
component extends="AI" {
	variables.fields = [
		field(displayName = "URL",
			name = "url",
			defaultValue = "http://localhost:11434/v1/",
			required = true,
			description = "URL of the OpenAI compatible API, for example [http://localhost:11434/v1/].",
			type = "text"
		)
		,field(displayName = "API Key",
			name = "apikey",
			defaultValue = "",
			required = false,
			description = "Sent as Bearer token, if the endpoint needs one. You can use environment variables like this: ${MY_API_KEY}.",
			type = "password"
		)
		,field(displayName = "Model",
			name = "model",
			defaultValue = "",
			required = false,
			description = "Name of the model, for example [gemma2].",
			type = "text"
		)
		,field(displayName = "System Message",
			name = "message",
			defaultValue = "",
			required = false,
			description = "Initial system message sent to the AI when a session is created.",
			type = "textarea"
		)
	];

	public string function getClass() {
		return "com.example.ai.SimpleChatEngine";
	}

	public string function getBundleName() {
		return "com.example.ai.simplechat";
	}

	public string function getBundleVersion() {
		return "1.0.0.0";
	}

	public string function getLabel() {
		return "Simple Chat";
	}

	public string function getDescription() {
		return "Connect to an endpoint with an OpenAI compatible chat/completions API.";
	}
}
```

### Where the Driver Goes

Put the driver in the `context/admin/aidriver/` folder of the `.lex`:

```
simple-chat-ai-1.0.0.0.lex
├── META-INF/
│   └── MANIFEST.MF
├── context/
│   └── admin/
│       └── aidriver/
│           └── SimpleChat.cfc
└── jars/
    └── com.example.ai.simplechat-1.0.0.0.jar
```

When the extension is installed, Lucee copies the content of `context/` into the server context, so the driver ends up next to the built-in drivers in `lucee-server.admin.aidriver`.

### How the Administrator Writes the Entry

When the user submits the form, the Administrator calls `cfadmin action="updateAIConnection"` with `class` (from `getClass()`), `bundleName` and `bundleVersion` (from the driver, if defined), the selected `default` and a `custom` struct with one entry per field. The connection is written to `.CFConfig.json` like this:

```json
"ai": {
  "mychat": {
    "class": "com.example.ai.SimpleChatEngine",
    "bundleName": "com.example.ai.simplechat",
    "bundleVersion": "1.0.0.0",
    "custom": {
      "url": "http://localhost:11434/v1/",
      "apikey": "",
      "model": "gemma2",
      "message": "Keep all answers as short as possible"
    }
  }
}
```

Before saving, Lucee loads the class and checks that it implements `AIEngine`. Note:

- All values are stored as strings, and a field left empty is stored as an empty string. The example engine therefore treats empty values as "not set".
- The form has no field for `maven`. It only passes `bundleName` and `bundleVersion`, so for an engine that is shipped as a Maven artifact, saving fails because the class can't be found. If you want the Administrator form, ship the engine as an OSGi bundle; a Maven based engine can still be configured in `.CFConfig.json`.
- The AI page only lists connections whose class has a driver. A connection to your engine that was added to `.CFConfig.json` directly doesn't show up there without a driver, but works anyway.

## Using the Engine

From CFML, the connection is used like any other AI connection:

```javascript
if ( AIHas( "mychat" ) ) {
	aiSession = createAISession( name: "mychat", systemMessage: "Answer as a helpful assistant." );
	dump( inquiryAISession( aiSession, "What is the capital of France?" ) );

	// follow-up question, the session keeps the history
	dump( inquiryAISession( aiSession, "And of Switzerland?" ) );

	// with a listener (this example engine delivers the answer as one chunk)
	inquiryAISession( aiSession, "Count from 1 to 10", function( msg ) {
		writeOutput( msg );
	} );

	// save and restore the conversation
	data = serializeAISession( aiSession );
	restored = loadAISession( "mychat", data );

	dump( AIGetMetaData( "mychat", true ) );
}
```

The prefixed names (`LuceeCreateAISession()`, `LuceeInquiryAISession()`, ...) work as well.

Note that `serializeAISession()` currently only stores the system message for sessions of the core engines. For a session of your engine, `loadAISession()` uses the message configured on the connection.

## Related

- [[ai]]: configuration and usage of the built-in AI engines
- [[ai-session-serialization]]: `serializeAISession()` and `loadAISession()`
- [[loader-api-changes-7]]: the AI interfaces in the Lucee 7 loader
- [[virtual-file-system]]: the same pattern for file systems
- [[maven-based-extensions]]: building extensions with Maven
- [[extension-installation]]: installing extensions
- [[extension-utilities]]: other utilities from the loader API (`Cast`, `Creation`, ...)
