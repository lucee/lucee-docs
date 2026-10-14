Since Lucee 5.4.2 and 6.0, XML parsing is secure by default — DOCTYPE declarations and external entities are blocked to prevent XXE attacks.

You can pass a struct of `xmlFeatures` as the `validator` argument to override the security settings for a single parse call, or set `this.xmlFeatures` in `Application.cfc` for application-wide configuration.

See the [[xml-security-xmlfeatures]] recipe for full details and examples.
