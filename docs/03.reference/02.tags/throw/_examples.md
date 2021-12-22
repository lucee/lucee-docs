### Tag example

```lucee+trycf
<cftry>
    <cfthrow message="test exception">
    <cfcatch name="test" type="any">
        <cfdump var="#cfcatch#">
    </cfcatch>
</cftry>
```

### Script example

```luceescript+trycf
 try {
        throw message="test exception"; //CF9+
    } catch (any e) {
        echo("#cfcatch#");
    }
```