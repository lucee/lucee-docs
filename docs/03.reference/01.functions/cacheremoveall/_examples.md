```lucee
<cfset cacheremoveall_obj = structnew()>
<cfset cacheremoveall_obj.name = 'man'>
<cfset cachePut('cacheremoveall_obj',cacheremoveall_obj,createTimespan(0,0,0,30),createTimespan(0,0,0,30),'region_cachename')>
<cfset cacheRemoveAll('cacheremoveall_obj')>
```
