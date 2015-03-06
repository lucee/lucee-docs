
			- cache (default): server-side and client-side template caching.
            - flush: refresh cached pages (template caching).
            - clientcache: browser-side caching only. To cache a personalized page, use this option.
            - servercache: server-side caching only. Not recommended.
            - optimal: same as "cache".
            - content: same as cache, but cache only the body of the tag, not the complete template (template caching).
            - put: adds a key value pair to object cache (see function cachePut for more details)
            - get: gets value matching given key from object cache (see function cacheGet for more details)
            