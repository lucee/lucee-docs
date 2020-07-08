---
title: Starting and Stopping Lucee
id: linux-starting-and-stopping-lucee
---

In a Linux environment, Lucee can be controlled by using the provided "lucee_ctl" script. During a standard install, it is possible for two (2) copies of this file to be created.

One copy of the control script will always be created right in the root wherever you installed Lucee (usually /opt/lucee/ - so the control script would be in /opt/lucee/lucee_ctl by default), and if you opt to have Lucee start at boot time, another will be created in your /etc/init.d/ directory, and used as an init script. Even though there are two copies of the file, there are no difference between the two. You can use whichever copy you prefer to use.

### Permisions ###

In all installations, root-level privileges are required to use the lucee_ctl script. This means you have to either be logged in directly as root, su to root, or sudo to root. This is important because it usually effects how to run the lucee_ctl script.

### On RHEL, CentOS, Fedora, etc ###

To start Lucee (and Tomcat) in a RHEL-based distribution, you can run the following command (logged in as "root"):

	# /opt/lucee/lucee_ctl start

To Stop Lucee:

	# /opt/lucee/lucee_ctl stop

And to Restart Lucee:

	# /opt/lucee/lucee_ctl restart

You can also use the script to check the server's running status:

	# /opt/lucee/lucee_ctl status

Lastly, if for some reason Tomcat/Lucee hangs, get stuck, etc, you can insta-kill it with: 

	# /opt/lucee/lucee_ctl forcequit

### On Ubuntu, Debian, etc ###

	 $ sudo /opt/lucee/lucee_ctl restart

### Using the "service" command ###

If you opted to have Lucee start at boot time, that would have configured the init script to be added to /etc/init.d/. When a script is present there, some distributions, like CentOS, offer the "service" command:

	$ service lucee_ctl restart