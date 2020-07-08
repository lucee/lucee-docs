```lucee
<cfset cacheremove_obj = "fruits">
<cfset cachePut('cacheremove_obj',cacheremove_obj,createTimespan(0,0,0,30),createTimespan(0,0,0,30),'region_cachename')>
<cfset cacheremove('cacheremove_obj',true)>
```