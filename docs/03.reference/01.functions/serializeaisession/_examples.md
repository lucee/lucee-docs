```lucee
// AI service name, e.g., 'test_ai'
aiSession = createAISession(name: 'test_ai', systemMessage: "Answer as Slim Shady.");
writeDump(serializeAISession(aiSession));
```