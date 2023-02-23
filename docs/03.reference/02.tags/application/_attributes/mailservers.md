Array of structs that defines the mailserver configuration. Each struct configures one mailserver. Struct keys used for smtp configuration are:
            - host (string): host name of smtp server
            - port (numeric): port number of smtp server
            - username (string): smtp username
            - password (string): smtp userpassword 
            - ssl (boolean): enable secure connections via SSL.
            - tls (boolean): enables Transport Layer Security.
            - lifeTimespan (timespan): overall timeout for the connections established to the mail server.
            - idleTimespan (timespan): idle timeout for the connections established to the mail server.