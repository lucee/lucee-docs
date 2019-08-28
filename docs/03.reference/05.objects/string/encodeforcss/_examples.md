
```luceescript+trycf
<cfset colors = 'red'>
<style>
	.color {
		background-color: #colors.encodeForCss()# 
	}
</style>
<div>
	<span class="color">This is encode for css.</span>
</div>
```