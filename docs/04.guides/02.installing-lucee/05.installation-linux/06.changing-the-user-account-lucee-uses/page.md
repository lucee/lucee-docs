---
title: Changing the User Account Lucee Runs As
id: changing-the-user-account-lucee-runs-as
---

This section is intended to cover the security issues of running Lucee/Tomcat under specific user accounts. It should be noted that when you install ANY piece of software on a server, you are opening your server up to potential security risks. It is important to be aware of what those risks are, and how to manage them. It is also important to note that no matter how hard you try, nothing you can do will ever make anything 100% secure. There will always be SOME security risk. The key is difficulty, and managing those risks appropriately.

### Lucee as Root ###

By default on Linux systems, the Installer will offer to run under the "root" user account. It's very important that you understand that this is a usability suggestion, and not a security suggestion. The idea is that you install the server, then install your application, and work out any user-related issues it may have by running as root. Once you've got your application installed and working properly, it is highly recommended that you change the running user to something other then the "root" user.

### Changing the Lucee User ###

The installer comes packaged with a script that makes it easy to switch the user account that Lucee runs as. Again, this can be a useful tool for problem-solving, making it easy to change the user that Lucee runs as in order to diagnose user or permission-related issues. The syntax for the change_user.sh script is as follows:

	change_user.sh {username} {installdir} {engine} [nobackup]

**username** - Required. States what username Lucee will run under. If a user and group with this name don't exist already, the script will create them both. For example, if you enter "luceeuser" as the username variable, the script will check for the existence of a "luceeuser" username and group. If either don't exist, the script will create a user "luceeuser" and a group "luceeuser". If the user or group already exist, the script will not bother trying to create them. This is handy if you're running as an existing user/group like "apache/apache", for example.

**installdir** - Required. States the root directory that Lucee is installed into. Usually this will be /opt/lucee/, unless you selected something other then the default.

**engine** - Required. States the engine type, valid options are either "lucee" or "openbd". Choose Lucee for this purpose.

**nobackup** - Optional. Recommended. This is a switch. If the script sees you added the word "nobackup" as the third parameter, the script will not perform backups of the control scripts. This is useful if you're using the change_user.sh script frequently and don't want to clutter up your directories with old control scripts.

Example Usage (Debian/Ubuntu/Mint):

	$ sudo /opt/lucee/sys/change_user.sh apache /opt/lucee/ lucee nobackup

Example Usage (RedHat/CentOS):

	# /opt/lucee/sys/change_user.sh apache /opt/lucee/ lucee nobackup

### User Permissions Per Site ###

If you change the Lucee to something other then the ROOT user, you need to configure your sites to allow write access from whatever the Lucee user is. This will allow Lucee/Tomcat to write the WEB-INF files to that directory. If you don't want the Lucee/Tomcat user to have write access to your site directory, you'll need to create the WEB-INF directory yourself and at least provide write access to that WEB-INF directory.

To show how this is done, let's use the "apache" user again, like we did above. If our site directory is /home/admin/[www.sitename.com](http://www.sitename.com/)/, we'll need to create the directory and assign permissions to it so that the "apache" user can write to it. We can do that with this command:

Example Usage (Debian/Ubuntu/Mint):

	$ sudo mkdir /home/admin/www.sitename.com/WEB-INF/
	$ sudo chown apache:apache /home/admin/www.sitename.com/WEB-INF/

Do that for each site you've configured in your tomcat server.xml file. After you've got a WEB-INF directory in every site with permissions adjusted on each of them, don't forget to restart Lucee/Tomcat!

	$ sudo /opt/lucee/lucee_ctl restart