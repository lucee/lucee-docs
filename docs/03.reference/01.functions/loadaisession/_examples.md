```lucee
//AI service name eg:test_ai
Ai_session = CreateAISession(name:'test_ai', systemMessage:"Answer as Slim Shady.");
result = SerializeAISession(Ai_session);
writeDump(LoadAISession('test_ai', result));

```