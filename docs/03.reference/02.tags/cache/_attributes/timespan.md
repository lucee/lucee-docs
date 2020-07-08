The interval until the item is flushed from the cache.

A decimal number of days, for example:

- .25, for one-fourth day (6 hours)
- 1, for one day
- 1.5, for one and one half days

A return value from the CreateTimeSpan function, for example, "#CreateTimeSpan(0,6,0,0)#".

The default action is to flush the item when it is idle for the time specified by the idleTime attribute, or cfcache action="flush" executes.