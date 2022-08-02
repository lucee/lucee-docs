Specifies the name of the lock.

Only {amount} (see attribute amount) request(s) can execute inside this tag with a given name.

Therefore, providing the name attribute allows for synchronizing access to resources from different parts of an application.

Lock names are global to a server. 

They are shared between applications and user sessions, but not across clustered servers.