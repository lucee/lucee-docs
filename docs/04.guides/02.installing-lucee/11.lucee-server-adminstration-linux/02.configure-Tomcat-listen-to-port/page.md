---
title: Configure Tomcat to Listen to Port 80
id: configure-tomcat-to-listen-to-port-linux
---

Getting Tomcat to listen directly to port 80 without using the "root" user can be a challenge on Linux systems because port 80 is one of the protected ports - it's a port number that's lower than 1024. This means that you have to take special steps to get Tomcat to listen directly to port 80 if you're running any user other than the root user.

The following documentation will assume that you're running Ubuntu 14.04, but very similar commands can be used if you're not running a Debian/Ubuntu-based OS.

### Notes on the Installer ###

While the Lucee Installer can perform several of the steps needed to configure Tomcat to listen on port 80, it will NOT perform the additional required steps that are covered here. Instead, you will receive an error message in your catalina.out log indicating a "Permission denied" error when the listener attempts to bind to port 80. If you get that error, than you need to take one of the following actions...

### OPTION 1: Configure port forwarding ###

IPTables is a Linux software firewall that can be configured to forward incoming requests received on port 80 to another port. When using the Lucee Installer, the default Tomcat HTTP port is 8888. Before we can configure iptables, however, we need to make sure it's installed. You can do that with the following command:

	 sudo apt-get install iptables

Once iptables is installed (if it wasn't already), we can configure port forwarding like so:

	sudo iptables -t nat -I PREROUTING -p tcp --dport 80 -j REDIRECT --to-port 8888

Specifically, the above command will reroute all TCP port 80 traffic to port 8888, which, if you used the Lucee Installer defaults, should reroute all standard web requests off to Tomcat's 8888 port.

### OPTION 2: Configure Authbind ###

Authbind is a program you can use to allow access to protected ports by specifying users or ports that have access to do so. This method differs from the above port forwarding method because here we will configure Tomcat to actually listen on port 80, rather than have port 80 reroute to port 8888.

To start, configure Tomcat to listen directly on port 80 by modifying the /opt/lucee/tomcat/conf/server.xml file and changing the listener config from this:

```lucee
 <Connector port="8888" protocol="HTTP/1.1"
	connectionTimeout="20000"
   redirectPort="8443" />
```

to this:

```lucee
 <Connector port="80" protocol="HTTP/1.1"
               connectionTimeout="20000"
               redirectPort="8443" />
```

Next we will need to install authbind, the program we need to use to allow Tomcat to bind to port 80. We can install authbind with the following command:

	 sudo apt-get install authbind

Once we have authbind installed, we need to configure port 80 as a port that can be bound using authbind. We can do that with the following commands:

	sudo touch /etc/authbind/byport/80
 	sudo chmod 500 /etc/authbind/byport/80
 	sudo chown [YOUR LUCEE USER] /etc/authbind/byport/80

Notice the [YOUR] in the command above. This needs to be changed to the user that you're running Tomcat as. For example, if I selected to have my Lucee/Tomcat server run as the "lucee" user, the command I would need to use would be as follows:

	sudo chown lucee /etc/authbind/byport/80

Last but not least, we need to configure Tomcat to use "authbind" when we start it up. To do that we edit the /opt/lucee/tomcat/bin/startup.sh file. At the bottom of the file we need to change this:

	exec "$PRGDIR"/"$EXECUTABLE" start "$@"

to this:

	exec authbind --deep "$PRGDIR"/"$EXECUTABLE" start "$@"

Now restart Tomcat:

	/opt/lucee/lucee_ctl restart

Tomcat should now be binding to port 80. You can check to see if the "java" process is listening to port 80 with the following command:

	sudo netstat -ltpn

and your output should look something like this:

	Active Internet connections (only servers)
		Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name
		tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN      1083/sshd
		tcp        0      0 127.0.0.1:631           0.0.0.0:*               LISTEN      22767/cupsd
		tcp        0      0 0.0.0.0:25              0.0.0.0:*               LISTEN      2109/master
		tcp        0      0 127.0.0.1:3306          0.0.0.0:*               LISTEN      1212/mysqld
		tcp        0      0 0.0.0.0:8834            0.0.0.0:*               LISTEN      1951/nessusd
		tcp6       0      0 :::80                   :::*                    LISTEN      30607/java
		tcp6       0      0 :::22                   :::*                    LISTEN      1083/sshd
		tcp6       0      0 :::25                   :::*                    LISTEN      2109/master
		tcp6       0      0 :::8834                 :::*                    LISTEN      1951/nessusd
		tcp6       0      0 127.0.0.1:8005          :::*                    LISTEN      30607/java
		tcp6       0      0 :::8009                 :::*                    LISTEN      30607/java
	jordan@jordan-M61P-S3:/opt/lucee$