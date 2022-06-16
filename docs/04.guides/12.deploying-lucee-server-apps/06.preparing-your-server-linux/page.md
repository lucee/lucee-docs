---
title: Preparing your Server - Linux
id: preparing-your-server-linux
---

The following guide is written with examples based on RHEL/CentOS, but these examples and guidelines can and should be applied to your specific Operating System. Due to it's popularity, some Debian/Ubuntu examples are also provided.

### Start with a "Blank Slate" ###

It is recommended that your begin by installing a fresh copy of your Linux OS on to your server. The fresh copy of the Operating System will ensure that there are no lingering abnormalities in the system you'll be installing your Lucee stack on to.

It is also recommended that you perform a "minimal" install of your OS, as it will mean that only the bare minimum will be installed initially. Anything that you need to add you can add manually. This also means that you won't have any superfluous programs running or even available on the server itself, and again it will minimize the initial attack vectors available on your server.

### Start With a Very Minimal and Restrictive Firewall ###

During most Linux installation processes, the installer will prompt you if you want to configure any initial firewall rules. It is recommended that you both enable the firewall, and only allow the most basic firewall exceptions, such as SSH access (port 22), HTTP access (port 80), and HTTPS access (443). Again, this will minimize the attack vectors that an attacker could exploit.

Once the initial minimal firewall is configured by the installation process, you should only add rules as absolutely necessary and if you can, add incoming IP Address restrictions on them so that only connections coming from approved ranges will be able to connect. For example, the following rule (added by editing the /etc/sysconfig/iptables file which was created by the install process on CentOS 6) would restrict who can connect to your SSH port to only a specific Class-C range of IP Addresses:

	-A RH-Firewall-1-INPUT -m state --state NEW -m tcp -p tcp --dport 22 -s 192.168.254.0/24 -j ACCEPT

Note the line above, the "dport" or "Destination Port" is port 22, which is the default SSH port. Next, note the IP range we used as an example here, which is 192.168.254.0 – a very common internal network range. Please adjust the allowed IP ranges as necessary for your network.

Once you've added or edited the line for the SSH port 22, don't forget to restart the iptables firewall with the following command (Again, using CentOS 6 as an example):

	# /etc/init.d/iptables restart

### Install All Available Patches ###

It is important to install all available patches as soon as possible on your new system. You can patch the system manually with the following commands if you're using CentOS:

	# yum -y upgrade yum
	# yum -y upgrade

or, on Ubuntu

	$ sudo apt-get -y update
	$ sudo apt-get -y dist-upgrade

As long as your system has access to the Internet and is able to download files from public repositories, YUM or apt-get will go download all the latest patches that are available for your system.

The first command for CentOS updates the YUM program itself. The next line tells YUM to grab all other available updates. Because YUM itself was just updated, it should have the most recent patching information available to it.

### Configure Automatic OS Patching ###

Now that the system is all patched up, we need to configure a process that will run those same updates on a regular basis. I would recommend nightly for the most up-to-date patching. Also, if you run nightly, chances are good that the patch download will be quick and small every time.

To do this in CentOS, we first need to create a shell script using the text editor of our choice. Let's call it "yumupdate.sh". Now, we need to add the following commands to it:

	#!/bin/bash
	/usr/bin/yum -y upgrade yum
	/usr/bin/yum -y upgrade

Once you've added those lines, save the file and place it in either of the following directories:

	/etc/cron.daily/yumupdate.sh

or

	/etc/cron.weekly/yumupdate.sh

Just to be clear, files placed in cron.daily will be run every day, and files placed in cron.weekly will be run each week. The exact time that each are executed is controlled by the /etc/crontab file, which you can also customize as needed.

Instructions for configuring automatic updates for Ubuntu (16.04 LTS) can be found here:

[https://help.ubuntu.com/16.04/serverguide/automatic-updates.html](https://help.ubuntu.com/16.04/serverguide/automatic-updates.html)

### Install fontconfig on headless servers ###

The Lucee Image Extension requires `fontconfig` to be installed, as fonts aren't always installed by default on headless servers.

	apt install fontconfig

### Install Minimal Apache Modules ###

As Apache (or whatever web server you will be using) will most likely be your most prominent and most important public-facing server, it is a good idea to keep it as simple as possible to keep attack vectors at a minimum. Don't install modules that you're not sure you'll use, such as PHP, user-directory support, or CGI-BIN support. If you are not absolutely sure you will need it, don't install it.

### Hide the Apache Version Number ###

You can tell Apache to hide it's version number by modifying the "ServerTokens" attribute in the main Apache configuration file (httpd.conf in RHEL/CentOS or apache2.conf in Debian/Ubuntu):

ServerTokens Prod

Setting this attribute to simply "Prod" will cause apache to only report "Apache", and not include the version number or installed modules such as PHP or Perl. The attacker will simply have to guess - which increases your chance of detecting intrusion attempts.

### Additional Suggestions ###

* Run SSH on a non-standard port (instead of default port 22 where it's easy to find)

* Leave SELinux enabled and create rules to allow Lucee to function through it. SELinux is complex, so if needed security consulting firms that specialize in secure CF deployments can be contracted to assist with this process.
