---
title: rediscommandlowpriority
id: function-rediscommandlowpriority
related:
categories:
    - cache
    - redis
---

This function works the same way as RedisCommand with only one difference. In case the connection pool is down to one free connection. The thread will wait for at least one connection more get free. So this command will not use the last connection available.