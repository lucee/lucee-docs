Array of structs that defines the mailserver configuration. Each struct configures one mailserver.

- **host** (string): host name of smtp server
- **port** (numeric): port number of smtp server 587
- **username** (string): smtp username
- **password** (string): smtp userpassword 
- **ssl** (boolean): enable secure connections via SSL
- **tls** (boolean): enables Transport Layer Security.
- **lifeTimespan** (timespan): overall timeout for the connections established to the mail server.
- **idleTimespan** (timespan): idle timeout for the connections established to the mail server

```
// e.g. of configuration in Application.cfc
this.mailservers =[ {
	  host: 'smtp.some-email-domain.com'
	, port: 587
	, username: 'mymailaccount@some-email-domain.com'
	, password:  'encrypted:8f7eb9...342'
	, ssl: false
	, tls: true
	, lifeTimespan: createTimeSpan(0,0,1,0)
	, idleTimespan: createTimeSpan(0,0,0,10)
}];
```