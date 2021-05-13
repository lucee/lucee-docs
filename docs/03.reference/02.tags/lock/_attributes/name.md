Specifies the name of the lock.

Only one request can execute inside a cflock tag with a given name. Therefore, providing the name attribute allows for synchronizing access to resources from 	different parts of an application. Lock names are global to a server. They are shared between applications and user sessions, but not across clustered servers.

This attribute is mutually exclusive with the scope attribute. Therefore, do not specify the scope attribute and the name attribute in a tag. The value of name cannot be an empty string.
