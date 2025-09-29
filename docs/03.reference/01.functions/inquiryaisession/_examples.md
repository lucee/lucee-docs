```lucee
// AI service name, e.g., "test_ai"
aiSession = LuceeCreateAISession("test_ai");
result = LuceeInquiryAISession(aiSession, "What is Lucee?");
writeDump(result);
```