```luceescript+trycf
<cfset cache_obj = 'fruits'> 
<cfset cachePut('cache_obj',cache_obj,createTimespan(0,0,0,30),createTimespan(0,0,0,30),'region_cachename')> 
//In above region_cachename is, should be creates a cache from lucee_administrator.
<cfoutput>Cache Exists is <b>#cacheIdExists('cache_obj','test_cache')#</b></cfoutput> 
```