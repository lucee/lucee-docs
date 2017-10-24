```luceescript+trycf
plain = "&lt;";
plain_bad = "%26lt; %26lt; %2526lt%253B %2526lt%253B %2526lt%253B";

dump(Canonicalize(plain,true,true));

// checking for malicious string
try {
   dump(Canonicalize(plain_bad,true,true).LogMessage);
} catch (Any e) {
   dump(var = e.LogMessage, label = "exception message");
}
```
