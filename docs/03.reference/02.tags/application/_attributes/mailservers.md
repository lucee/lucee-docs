Array of structs that defines the mailserver configuration.

Each struct configures one mailserver.

Struct keys used for smtp configuration are:

- **host (string):** host name of smtp server (you can use `host` or `server` as the key; `smtp` is also supported since Lucee **Lucee 6.2.2.50-SNAPSHOT**)
- **port (numeric):** port number of smtp server
- **username (string):** smtp username
- **password (string):** smtp userpassword
- **ssl (boolean):** enable secure connections via SSL.
- **tls (boolean):** enables Transport Layer Security.
- **lifeTimespan (timespan):** overall timeout for the connections established to the mail server.
- **idleTimespan (timespan):** idle timeout for the connections established to the mail server.

```cfc
// Example configuration in Application.cfc
this.mailservers = [
  {
    // You can use any of these keys for the host: 'host', 'server', or 'smtp'
    host: 'smtp.some-email-domain.com',
    // server: 'smtp.some-email-domain.com',
    // smtp: 'smtp.some-email-domain.com', // since Lucee 6.2.2.50-SNAPSHOT
    port: 587,
    username: 'mymailaccount@some-email-domain.com',
    password: 'encrypted:8f7eb9...342',
    ssl: false,
    tls: true,
    lifeTimespan: createTimeSpan(0,0,1,0),
    idleTimespan: createTimeSpan(0,0,0,10)
  }
];
```
