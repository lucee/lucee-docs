```luceescript
// Convert JSON directly to CBOR binary data

json = '{"name":"test","value":42}';
cbor = JsonToCbor( json );
// cbor is binary CBOR data

// Verify the roundtrip
backToJson = CborToJson( cbor );
parsed = deserializeJSON( backToJson );
// parsed.name == "test", parsed.value == 42

// Convert a JSON array
cbor = JsonToCbor( '[1,2,3,"four"]' );

// Encode existing API response data as CBOR for a system that expects it
apiResponse = '{"status":"ok","data":[1,2,3]}';
cborPayload = JsonToCbor( apiResponse );
// Send cborPayload to a CBOR-expecting endpoint
```
