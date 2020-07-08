---
title: Upgrading The JRE
id: linux-upgrade-the-JRE
---

### Upgrading The JRE ###

**IMPORTANT:** Even though the documentation below contains images and text on JRE 6, these exact same methods can be used to upgrade JRE 7. There is no difference in the upgrade process between JRE 6 and JRE 7.

The Java Runtime Environment (JRE) is the environment that your CFML code runs inside of. The Lucee installer ships with a default JRE, but over time this JRE will need to be updated in order to remain stable, secure, and bug free. The following is meant to guide users through the relatively simple process of upgrading the JRE that is running on your Linux Server. Keep in mind that these instructions were written using Ubuntu 64-bit, and may need to be adapted slightly to your own system. For example, if you're running CentOS Linux, you will not need to use "sudo" in front of your commands.

### STEP 1 - Shut Down Lucee/Tomcat ###

It could be problematic to copy over libraries while the server that utilizes them is still running, so we're just going to stop the Lucee/Tomcat server before we proceed with the JRE Upgrade:

	$ sudo /opt/lucee/lucee_ctl stop

### STEP 2 - Download the JRE ###

Go to the JRE download page, which at the time of this writing is here [JRE Download Page](http://www.oracle.com/technetwork/java/javase/downloads/index.html)

If you can't do this on your Linux system (as most Linux servers - with good reason - do not have a GUI), then download the JRE and upload it to your server using a file transfer method of your choice. FTP is a common method or you could use a method like [SCP](http://acs.ucsd.edu/info/scp.shtml).

The JRE download site will offer you the option of a strait "bin" file or a "rpm.bin". The "rpm.bin" file is basically a self-extractor for an RPM file, which we will not need for our purposes. Instead, be sure to download the simple "bin" file, and NOT the "rpm.bin":

### STEP 3 - Extract the JRE ###

The regular "bin" file is also a self-extractor, and will extract the jre to a folder named something similar to "jre1.6.0_23". This is the JRE that we're going to use to replace the JRE in our existing Lucee install. To run the self-extracting bin, we'll need to give it execute permissions. So, once we have the bin file uploaded to the server that has Lucee installed on it, run the following command to give the bin file execute permissions:

	$ chmod 744 jre-6u23-linux-x64.bin 

Now run it, and it will self-extract:

	$ ./jre-6u23-linux-x64.bin 

You will see a long list of files being extracted, something like this:

### STEP 4 - Backup the Existing JRE ###

Just in case something bad happens, it's always a good idea to make a backup. In this case, we're going to backup the existing JRE just in case, for some reason, something bad happens and Lucee cannot run on the newer JRE. To make a backup, simply run the following command. Note: this command assumes that you installed to the default location of /opt/lucee. If you didn't install to the default location, you will need to adjust your paths accordingly:

	$ sudo cp -R /opt/lucee/jdk/ /opt/lucee/jdk.bak 

Again, note that we're assuming you're running on Ubuntu for this documentation. If you're running on another Linux distribution, like Fedora, RHEL, or CentOS, you may not need the "sudo" in front. Please interpolate for your situation.

Again, note that we're assuming you're running on Ubuntu for this documentation. If you're running on another Linux distribution, like Fedora, RHEL, or CentOS, you may not need the "sudo" in front. Please interpolate for your situation.

### STEP 5 - Replace the Existing JRE ###

Now we're going to take the JRE we downloaded and extracted, and replace the running JRE with it. Assuming you're in the same directory where you extracted the JRE, just run the following commands:

Rename the JRE directory to simply "jre", since this is the directory that the current JRE runs under:

$ mv jre1.6.0_23/ jre

Remove the existing JRE with the following command:

	$ sudo rm -rf /opt/lucee/jdk/jre

Now move the "jre" directory to our Lucee install:

	$ sudo mv jre /opt/lucee/jdk/

### STEP 5 - Start and Test ###

We're almost done! Now we need to start up our Lucee instance and test to make sure things are running on the new JRE. To start Lucee, run the following command:

	$ sudo /opt/lucee/lucee_ctl start

Next go to the Tomcat Administrator - usually at http://localhost:8888/manager/html/, and see if the JRE that's running is the new one.