If there is no accessible data member (property, element of the this scope) inside a component, Lucee searches for available matching &quot;getters&quot; or &quot;setters&quot; for the requested property.

The following example should clarify this behaviour.

&quot;somevar = myComponent.properyName&quot;.

If &quot;myComponent&quot; has no accessible data member named &quot;propertyName&quot;,

Lucee searches for a function member (method) named &quot;getPropertyName&quot;.