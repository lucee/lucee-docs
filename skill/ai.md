# Lucee skill: AI

AI sessions and engines, RAG, MCP, AI serialisation, using Lucee docs with AI assistants.

Fetch a recipe with `https://docs.lucee.org/recipes/<id>.md`. "Since" is the first Lucee version with the feature.

| ID | Title | Description | Since | Keywords |
|----|-------|-------------|-------|----------|
| `ai` | AI | AI integration for working with Large Language Models in Lucee | 6.2 | AI, LLM, ChatGPT, Gemini, Claude, Ollama, Groq, OpenRouter |
| `ai-augmentation` | AI Augmentation with Lucene | Documentation for augmenting AI queries using Lucene search in Lucee | 7.0 | AI, LLM, RAG, Search, Augmentation, Lucene, Retrieval |
| `ai-page-context` | AI Context from Page Content | Capture rendered page HTML with a custom tag and use it as context for an AI session | 7.0 | AI, LLM, custom tag, context, system message, generatedContent, SerializeAISession, LoadAISession |
| `ai-for-documentation` | AI in Documentation (Experimental) | Guide to configuring AI / LLM for use in Lucee's Documentation tab. | 6.2 | AI, LLM, documentation, configuration, Monitor, experimental, admin settings, AI engines |
| `ai-serialisation` | AI Session Serialization | Documentation for serializing and deserializing AI sessions in Lucee | 6.0 | AI, LLM, Serialization, Session, Persistence |
| `ai-engine-extension` | Creating an Extension that Provides an AI Engine | How to implement the AI interfaces from the Lucee loader in your own Java engine, package it as an extension and use it with createAISession() | 7.0 | AI, LLM, AIEngine, AISession, extension, loader, OSGi, Maven |
| `lucee-skill` | Lucee Skill for AI Assistants | What the Lucee skill file is, how it helps AI assistants answer CFML questions accurately, and how to configure it with Cursor, Claude, OpenAI, and Gemini | 7.0 | skill, lucee.skill, AI, Claude, OpenAI, Gemini, Cursor, documentation |
| `mcp` | Model Context Protocol (MCP) | Guide to MCP in Lucee: what it is, how to configure AI connections, and the three MCP servers Lucee provides | 8.0 | MCP, Model Context Protocol, AI, Claude, OpenAI, Gemini, tools, passthrough |
| `scheduler-quartz-ai-job` | Run AI Sessions in the Cloud, 24/7, Doing Your Work | Add Quartz jobs to a Lucee server by asking an AI coding assistant in plain language, watch them with a job listener (duration, failures, AI token usage), and connect them to outside services with MCP or plain HTTP | 7.0 | scheduler, quartz, AI, AI connection, vibe coding, MCP, listener, token usage |
