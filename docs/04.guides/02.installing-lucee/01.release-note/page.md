---
title: Release Notes
id: installation-release
visible: false
---

### Lucee 4.2.1.008 pl0 ###

Lucee 4.2.1.008 pl0 was released October 14, 2014

* [UPDATE] All: Tomcat has been updated to 7.0.56 (jordan)
* [UPDATE] All: The JRE has been upgraded to version 1.7.0_67 (jordan)

### Lucee 4.2.1.000 pl2 ###

Lucee 4.2.1.000 pl2 was released July 9, 2014

* [FIX] All: Corrected an issue that caused CFDocument to fail with a "class not found" error. (jordan)

### Lucee 4.2.1.000 pl1 ###

Lucee 4.2.1.000 pl1 was released June 25, 2014

* [UPDATE] All: Tomcat has bee updated to 7.0.54 (jordan)
* [UPDATE] All: The JRE has been upgraded to version 1.7.0_60 (jordan)
* [UPDATE] Windows: The BonCode Connector has been upgraded to 1.0.19 (bilal)
* [FIX] Windows: Corrected an issue that would cause the Lucee Tomcat service java environment to not get set properly during installs on some 64-bit systems. (jordan)
* [FIX] Windows: Re-added the ability for the installer to auto-detect if IIS is installed or not and set "install IIS connector" to be unchecked by default if IIS is not detected. [Issue 56](https://github.com/utdream/CFML-Installers/issues/56) (jordan)

### Lucee 4.2.1.000 pl0 ###

Lucee 4.2.1.000 pl0 was released May 21, 2014

* [UPDATE] All: Tomcat has been updated to 7.0.53 (jordan)
* [UPDATE] All: The JRE has been upgraded to version 1.7.0_55 (jordan)

### Lucee 4.1.1.009 pl0 ###

Lucee 4.1.1.009 pl0 was released October 22, 2013

* [NEW] All: The Lucee class file 'lucee-inst.jar' has been made default for improved memory management. Issue 50 (jordan)
* [UPDATE] All: Lucee has been upgraded to version 4.1.1.009 (jordan)
* [UPDATE] All: The JRE has been upgraded to version 1.7.0_45 (jordan)
* [UPDATE] All: Tomcat has been updated to 7.0.42 (jordan)
* [UPDATE] All: Translations have been updated thanks to the Lucee Translation Team! (translation team)
* [UPDATE] 64-bit: 64-bit installs are now using the Oracle "server" JRE releases. (jordan)
* [FIX] All: Documentation links on "Welcome to the Lucee World" page have been updated to use the updated wiki links. (jordan)

### Lucee 4.1.0.011 pl0 ###

Lucee 4.1.0.011 pl0 was never released as a production release.

* [UPDATE] All: Lucee has been upgraded to version 4.1.0.011 (jordan)
* [UPDATE] All: The JRE has been upgraded to version 1.7.0_25 (jordan)
* [UPDATE] All: Tomcat has been upgraded to 7.0.41 (jordan)
* [UPDATE] All: 32-bit JRE on 64-bit OS is no longer supported. [Issue 52](https://github.com/utdream/CFML-Installers/issues/52) (jordan)
* [UPDATE] All: Removed Tomcat Admin Username prompt as it's no longer needed. [Issue 40](https://github.com/utdream/CFML-Installers/issues/40) (jordan)
* [UPDATE] Windows: BonCode Connector has been upgraded to 1.0.16 (bilal)
* [UPDATE] Windows: Default Windows service name for lucee changed from "Apache Tomcat Lucee" to "Lucee Server" to be more clear. [Issue 54](https://github.com/utdream/CFML-Installers/issues/54) (jordan)
* [FIX] All: Fixed encoding error during read of tomcat-users.xml file during tomcat boot [Issue 51](https://github.com/utdream/CFML-Installers/issues/51) (jordan)
* [FIX] All: Removed unused JRE folders after successful install [Issue 47](https://github.com/utdream/CFML-Installers/issues/47) (jordan)
* [SECURITY] All: JSP Support has been removed to remove it as an attack vector [Issue 53](https://github.com/utdream/CFML-Installers/issues/53) (jordan)
* [SECURITY] All: Tomcat Webapps have been removed so they are not a possible attack vector [Issue 55](https://github.com/utdream/CFML-Installers/issues/55) (jordan).

### Lucee 4.0.4.001 pl2 ###

Lucee 4.0.4.001 pl2 was released May 21st, 2013

[FIX] Linux: Implemented fix for "Error in math expression" error: [Issue 48](https://github.com/utdream/CFML-Installers/issues/48) (jordan)

### Lucee 4.0.4.001 pl1 ###

Lucee 4.0.4.001 pl1 was released April 3rd, 2013

[UPDATE] All: Lucee servlet definitions have been updated to be more uniform [Issue 45](https://github.com/utdream/CFML-Installers/issues/45) (jordan)

## Lucee 4.0.4.001 pl0 ##

Lucee 4.0.4.001 pl0 was released March 14th, 2013

* [UPDATE] All: Lucee has been upgraded to version 4.0.4.001 (jordan)
* [UPDATE] All: The JRE has been upgraded to version 1.7.0_17 (jordan)
* [FIX] ALL: Language Selection should now display alphabetically [Issue 42](https://github.com/utdream/CFML-Installers/issues/42) (jordan)
* [FIX] Linux: Run level 2 is now included in service_config.sh [Issue 43](https://github.com/utdream/CFML-Installers/issues/43) (jordan)

### Lucee 4.0.3.006 pl0 ###

Lucee 4.0.3.006 pl0 was released February 22, 2013

* [UPDATE] All: Lucee has been upgraded to version 4.0.3.006 (jordan)
* [UPDATE] All: The JRE has been upgraded to version 1.7.0_15 (jordan)
* [UPDATE] All: Updated Tomcat from version 7.0.33 to version 7.0.37 (jordan)
* [UPDATE] All: Updated mod_cfml Tomcat Valve to version 1.0.14 (jordan)
* [UPDATE] Windows: BonCode Connector has been updated to version 1.0.14 (bilal)

### Lucee 4.0.2.002 pl1 ###

Lucee 4.0.2.002 pl1 was released December 5, 2012

* [FIX] Linux: The "Start at boot" option now works as intended using a new script in the "sys" folder named "service_config.sh". This script can be used to add or remove the "start at boot" functioanlity on RHEL or Debian-based systems such as CentOS and Ubuntu. (jordan)

* [FIX] Windows: Lucee will now install properly into directories containing spaces in them, such as "Program Files". (jordan)


### Lucee 4.0.2.002 pl0 ###

Lucee 4.0.2.002 pl0 was released November 28, 2012

* [UPDATE] All: Lucee has been upgraded to version 4.0.2.002 (jordan)
* [UPDATE] All: The JRE has been upgraded to version 1.7.0_09 (jordan)
* [UPDATE] All: Updated Tomcat from version 7.0.27 to version 7.0.33 (jordan)
* [UPDATE] Windows: BonCode Connector has been updated to version 1.0.12 (bilal)
* [NEW] All: Graphics and images have been upgraded for Lucee 4 (jordan,mark,integral)
* [NEW] All: Installer prompt for Tomcat User/Password now merged and hidden for better security (jordan)
* [NEW] All: Installer now allows all Internet-facing ports to be configured at installation (jordan)
* [NEW] Linux: mod_jk has been replaced with mod_proxy (jordan)

### Lucee 3.3.4.003 pl0 ###

Lucee Lucee 3.3.4.003 pl0 was released June 14, 2012

* [UPDATE] All: Lucee has been upgraded from 3.3.3.001 to 3.3.4.003 (jordan)

### Lucee 3.3.3.001 pl1 ###

Lucee 3.3.3.001 pl1 was released June 13, 2012 1

* [UPDATE] Linux: Amazon Linux is now officially supported by the Lucee Linux Installers. (jordan)
* [FIX] Linux: mod_cfml install script now defaults to YUM-based install method when it encounters an unknown OS. (jordan)
* [FIX] Linux: mod_cfml install script now fails gracefully when it cannot install mod_perl to an unknown OS. (jordan)
* [FIX] Linux: mod_cfml install script no longer contains unused CPAN references. (jordan)
* [FIX] Linux: mod_cfml install script feedback should now be easier to read; better layout logic. (jordan)
Only the Linux installers were updated so there is no "pl1" release for Windows.

### Lucee 3.3.3.001 pl0 ###

Lucee 3.3.3.001 pl0 was released June 4, 2012

* [FIX] Linux: mod_cfml install script will now fail gracefully instead of throwing an error during an upgrade. (jordan)
* [UPDATE] Windows: The BonCode Connector has been upgraded from version 1.0.4 to 1.0.5 (bilal, jordan)
* [UPDATE] All: Lucee has been upgraded from 3.3.2.002 to 3.3.3.000 (jordan)
* [UPDATE] All: Updated Tomcat from version 7.0.26 to version 7.0.27 (jordan)
* [UPDATE] All: Updated JRE from version 1.6.0_31 to version 1.6.0_32 - bugfix release (jordan)

### Lucee 3.3.2.002 pl0 ###

Lucee 3.3.2.002 pl0 was not "officially" released due to changes in Lucee core.

* [NEW] All: mod_cfml has been added to all installations by default to reduce system administration requirements.1 (jordan)
* [NEW] Windows: The isapi_redirect.dll connector has been replaced with the BonCode Connector for IIS installs.2 (bilal, jordan)
* [UPDATE] All: Lucee has been upgraded from 3.3.1.000 to 3.3.2.002 (jordan)
* [UPDATE] All: Updated Tomcat from version 7.0.22 to version 7.0.26 (jordan)
* [UPDATE] All: Updated JRE from version 1.6.0_29 to version 1.6.0_31 - security release (jordan)

Details of mod_cfml are at [modcfml.org](http://www.modcfml.org/).
Details of the BonCode Connector are at [tomcatiis.riaforge.org](http://tomcatiis.riaforge.org/).

### Lucee 3.3.1.000 pl1 ###

Lucee 3.3.1.000 pl1 was released on Oct 19th, 2011

* [NEW] All: A New FusionReactor Product Feature has been added to the slideshow (jordan,FusionReactor)
* [FIX] All: 6-character Tomcat/Lucee passwords are now properly accepted. [Issue 27](https://github.com/utdream/CFML-Installers/issues/27) (jordan)
* [FIX] All: Using a non-default Tomcat port should no longer cause a post error in the installer. [Issue 28](https://github.com/utdream/CFML-Installers/issues/28) (jordan)
* [FIX] All: A port test has been added to the Lucee Administrators password setting process to allow for a firewall. [Issue 30](https://github.com/utdream/CFML-Installers/issues/30) (jordan)
* [FIX] All: The "webapps" directory is no longer obliterated in a Tomcat upgrade. The "webapps" directory content is now preserved. 1 [Issue 35](https://github.com/utdream/CFML-Installers/issues/35) (jordan)
* [FIX] All: Confusing and unnecessary tomcat port prompt has been removed during an upgrade. (jordan)
* [FIX] Windows: The Tomcat/Lucee service will now properly autostart on Windows 2003 systems. [Issue 31](https://github.com/utdream/CFML-Installers/issues/31) (jordan)
* [UPDATE] All: Updated Tomcat from version 7.0.21 to version 7.0.22 - bug-fix release (jordan)
* [UPDATE] All: Updated JRE from version 1.6.0_26 to version 1.6.0_29 - security release (jordan)
* [UPDATE] All: Japanese Translation is now correct and current. (tomoaki,jordan)

It is recommended that you delete the previous "manager" and "docs" directories in order to avoid confusing these directories with directories that are used by Tomcat 7. The new "Manager" and "docs" directories have been renamed to "tomcat-manager" and "tomcat-docs" respectively. You should not require the older directories unless you've customized them.

### Lucee 3.3.1.000 pl0 ###

Lucee 3.3.1.000 pl0 was released on Oct 3rd, 2011

* [NEW] All: The installer now offers the ability to upgrade previous installs with the software stack contained within the installer release. [Issue 10](https://github.com/viviotech/CFML-Installers/issues/10) (jordan)
* [NEW] All: A New Spanish Translation is now available thanks to Maggie Patino
* [FIX] All: The Lucee Tomcat config has been updated for better compatibility with the Lucee servlet [Issue 24](https://github.com/utdream/CFML-Installers/issues/24) (jordan)
* [FIX] All: The Lucee Server Admin and Web Admin now have their passwords set at install. [Issue 8](https://github.com/utdream/CFML-Installers/issues/8) (jordan)
* [FIX] All: Tomcat contexts have been renamed slightly to help them not interfere with sites that may be hosted on the system * [Issue 20](https://github.com/utdream/CFML-Installers/issues/20) (jordan)
* [UPDATE] All: HTTPOnly cookies are now implemented by default for improved security [Issue 23](https://github.com/utdream/CFML-Installers/issues/23) (jordan)
* [UPDATE] All: SES URL Mappings have been added by default for improved usability [Issue 21](https://github.com/utdream/CFML-Installers/issues/21) (jordan)
* [UPDATE] All: The "Welcome to the Lucee World" page has been updated to include installer-specific getting-started help links. (jordan)
* [UPDATE] All: The installer now features an information slide show that plays during the install process. (jordan,daniel)
* [UPDATE] All: Lucee has been upgraded to 3.3 (jordan)
* [UPDATE] All: FusionReactor has been temporarily disabled from this release as we prep for FusionReactor 4 (jordan)
* [UPDATE] All: Updated Tomcat from version 6 to version 7.0.21 (jordan)
* [UPDATE] All: Updated JRE from 1.6.0_24 to 1.6.0_26 for security updates (jordan)
* [UPDATE] All: Translations have been updated to support the "upgrade" features (Translation Team)

The VHost Copier is designed to take care of the hassle of modifying Tomcat and related configs each time you need to add a new site to your server. Instead of having to modify the Tomcat server.xml and issue a Tomcat restart, the VHost Copier will update the necessary Tomcat config files, as well as add the new host using Tomcat's Host Manager application - no need for a Tomcat restart! Using the VHost Copier, you won't even need to think about configuring Tomcat. It happens automatically! Note While originally intended for this release, the VHost Copier has been delayed in order to allow for more complete and thorough testing.

The release of the VHost Copier has been delayed until further testing can be done. Thanks for your patience!

### Lucee 3.2.2.000 pl0 ###

Lucee 3.2.2.000 pl0 was released on March 11, 2011.

* [NEW] Windows: Added exclusions for PHP and ASP files from connector so they're not accidently passed to Tomcat. [Issue 9](https://github.com/viviotech/CFML-Installers/issues#issue/9) (jordan)
* [NEW] Windows: Added default config for Flex 2 Gateways - enabled by default. [Issue 3](https://github.com/viviotech/CFML-Installers/issues#issue/3) (jordan)
* [FIX] Linux: Fixed unescapped variable in chance_user.sh script that effected the lucee_ctl scripts [Issue 2](https://github.com/viviotech/CFML-Installers/issues/closed#issue/2) (jordan)
* [UPDATE] All: Updated Lucee from 3.2.1.000 to 3.2.2.000 (jordan, bilal)
* [UPDATE] All: Updated Tomcat (including webapps) from 6.0.29 to 6.0.32 (jordan)

### Lucee 3.2.1.000 pl0 ###

Lucee 3.2.1.000 pl0 was released on December 25, 2010.

* [NEW] All: Added Lucee Welcome page to Tomcat ROOT webapp. (jordan)
* [NEW] Linux: Added auto-detection for Ubuntu directories. (bilal)
* [FIX] Windows: Fixed resurfaced IIS6 compatibility modules causing incorrect identification of IIS7 installations (jordan)
* [UPDATE] All: Updated Lucee from 3.1.2.001 to 3.2.1.000 (jordan)
* [UPDATE] All: Updated Tomcat from version 6.0.26 to 6.0.29 (jordan)
* [UPDATE] All: Prompt after install now directs to Lucee welcome page (jordan)
* [UPDATE] Linux: Replaced the JDK with a smaller JVM. Linux installers are now smaller then 100MB each (jordan)
* [UPDATE] Linux: Updated JVM from version 1.6.0_14 to 1.6.0_23 (jordan)
* [UPDATE] Windows: Removed Tomcat config change that made IIS webroot the tomcat webroot. This is to support the new welcome page (jordan)

### Lucee 3.1.2.001 pl1 ###

The Lucee 3.1.2.001 pl1 release contains MANY new features and improvements.

- Beta released June 11, 2010
- Officially released Oct 13, 2010

* [NEW] All OS's: The option to install a trial edition of FusionReactor is now available. (jordan)
* [NEW] All OS's: In-Use Port Detection has been added and improved in for Tomcat and FusionReactor. (bilal,jordan)
* [NEW] All OS's: Multi-Language is now supported (bilal)
* [NEW] All OS's: The final screen of the installer now prompts you if you'd like to open up the Lucee Administrator. (bilal)
* [NEW] Windows: IIS6 on W2K3 is now supported (jordan)
* [NEW] Windows: IIS7/IIS6 now set "index.cfm" as a default document option (jordan)
* [NEW] Windows: 64-bit Support is now included in the Windows Installer (jordan,bilal)
* [NEW] Windows: The Installer now performs a check for required IIS modules before offering to be installed on IIS and displays a warning if required modules are not installed. (jordan)
* [NEW] Windows: A Notice has been included for WinXP installs stating that it's not officially supported. (bilal)
* [NEW] Linux: The option to select the Tomcat system user is now available. This makes it so folks who are uncomfortable running as root can easily select a different user to run under. (jordan)
* [NEW] Linux: A "change_user.sh" script is now available in the "sys" folder if you ever want to change the system user that Tomcat runs as. This script will detect existing users and create users or groups as needed. It will also rewrite the control scripts, so it *should* be compatible with all older versions of Lucee installed with previous versions of the installer. (jordan)
* [BUGFIX] Windows: IIS7 on Windows 7 is now fully supported (jordan)
* [BUGFIX] Windows: 32-bit Installer will now auto-detect 64-bit machines and will install the 64-bit connector when being installed on a 64-bit version of Windows. This is true for both IIS6 and IIS7. This avoids the "LoadLibraryEx" failure in IIS if a 32-bit connector has been installed on a 64-bit version of IIS. (jordan)
* [UPDATE] Windows: The Tomcat connector has been upgraded from version 1.2.28 to 1.2.30 (jordan)
* [UPDATE] All OS's: The Tomcat Engine has been upgraded from version 6.0.20 to 6.0.26 (jordan)
* [UPDATE] All OS's: Some source code in the Java JDK has been removed in order to reduce the size of the installers by approximately 20 MB. The installers now hover around the 100MB range. More rarely-used aspects of the JDK that ships with the installer may be removed at a later date in order to reduce the download size even more. (jordan)
* [Update] Windows: The JDK has been replaced with a simple JVM for Windows installs. The JDK was more then most folks needed, and switching to the simple JVM allowed for a smaller installer. (bilal)
* [BETA] OSX: A new OSX build is now available for BETA testing. (bilal)
The Following Translations are now available:
* Dutch (Thanks to: Paul Klinkenberg)
* German (Thanks to: Bilal Soylu)
* Italian (Thanks to: Salvatore Fusto)
* Portuguese (Brazilian) (Thanks to: Ronan Lucio)

### Lucee 3.1.2.001 pl0 ###

The Lucee 3.1.2.001 pl0 release is a maintenance and bug fix release on 12/30/2009.

* [FIX] LINUX: Added System Bit-Type check when a 64-bit OS is detected to address the issue of improper bit type detection on 64-bit platforms running 32-bit VM's.
* [FIX] LINUX: Greatly enhanced the "lucee_ctl" control script to identify hung java processes and kill them if needed.
* [UPDATE] LINUX: Added two new lucee_ctl options: "forcequit" and "status".
* [UPDATE] Added example directive to Tomcat's server.xml file to exemplify how to easily map domain.com and www.domain.com to the same directory.

### Lucee 3.1.1.000 pl0 ###

The Lucee 3.1.1.000 pl0 installer was released to the "lucee-dev" mailing list on 10/12/2009 by Jordan Michaels. The major revision for the release was the new Install Platform generously provided by BitRock Software. Jordan was able to use the !BitRock Install Builder program to create the installers. The new install platform provided the ability to support Windows Installers in addition to Linux Installers, and made the process of maintaining those installers manageable. The following announcement was posted:

	Hey Folks,

	Vivio is proud to announce the immediate availability of Graphic
	Installers for both Windows and Linux. The graphic installers for
	Windows are completely new, so they will be the focus of my attention in
	this post. Those of you who are familiar with the console installers
	Vivio previously released, just know that the GUI installers available
	for Linux work in both GUI-mode and in Text-mode, so Linux has just been
	given more user-friendliness there.

	Downloads are available here:

	http://lucee.viviotech.net/

	Each installer contains everything necessary to get up and running right
	away, including Sun's JDK 1.6, Tomcat 6, and the latest production
	edition of Lucee. Download sizes range between 120-130 MB.

	The installers will also install the mod_jk connector if you select it.
	For Linux, Apache 1.3, 2.0, and 2.2 are all supported. For Windows, only
	IIS7 is supported. IIS6 users will need to install the connector
	manually. IIS7 is available by default on the following Windows OS's:
	Windows 7, Windows Vista, and Windows Server 2008.

	The Installer will auto-detect IIS7. If you have IIS7 installed, the
	Lucee Installer will prompt you if you want the IIS7 connector installed
	as well. If you don't have IIS7 installed, you will not be prompted.

	I've received several requests for IIS6 support, so it may be added in
	the future. If you feel IIS6 would help you get others interested in
	using or continuing to use CFML, please add your voice and let me know.

	For Windows users, after the install is finished, you'll find links to
	the Lucee Administrator, as well as Lucee-Tomcat Service controls in
	your start menu. For convenience, the server.xml file (which needs to be
	modified each time you add a new site to your server) has also been
	linked to in the start menu. Just edit the file, restart Lucee-Tomcat,
	and your new domain will be all set.

	Please let me know if you have any questions or run into any problems.

	I've tested the Windows installer on Windows Vista, Windows 7, and
	Windows Server 2008. I've tested the Linux installers on CentOS 5 and
	Ubuntu Jaunty.

### Lucee 3.1.1 ###

The Lucee 3.1.1 installer was released to the "lucee" mailing list on 8/21/2009 by Jordan Michaels. It existed only as a Linux installer, as it was just a BASH shell script at the time. The following message was posted:


	Vivio's Linux Installer for Lucee has been updated. Downloads are
	available at the following URL:

	http://[NO LONGER ACTIVE]/

	Change Log:

	- [UPDATE] Uses latest version of Lucee 3.1.1
	- [UPDATE] Contains latest version of mod_jk (1.2.28)
	- [FIX] Fixed an error that would occasionally install the 32-bit mod_jk
	connector on a 64-bit system
	- [Fix] Fixed an issue where the installer would fail if run from the
	"opt" directory and Lucee was installed to the default of /opt/lucee.

	This installer is recommended for use with fresh installs.

	If you are using a previous version of the installer, you can update
	your installation by using the Lucee Administrator Upgrade feature.

	If you encounter any problems with the upgrade (I haven't tested), you
	may also upgrade by downloading the lucee-3.1.1.000-jars.tar.gz file,
	extracting it, and dropping the new Lucee jar files into the "[lucee
	install]/lib/" folder. Don't forget to restart with the "lucee_ctl"
	control script.

	Please let me know if you run into any issues with these installers or
	how they function once installed.

	Have fun!

### Lucee 3.1 BETA ###

The BETA version of the Lucee 3.1 installer was released to the "lucee-dev" mailing list on 7/2/2009 by Jordan Michaels. It existed only as a Linux installer, as it was just a BASH shell script at the time. The following message was posted:

	Hi Folks,

	Okay, I've got two versions set up and ready for testing at the following URL's:

	32-bit (122 MB):
	http://[NO LONGER ACTIVE]/downloader.cfm/id/77/file/lucee-3.1-BETA-linux32-pl0-beta.sh

	64-bit (116 MB):
	http://[NO LONGER ACTIVE]/downloader.cfm/id/78/file/lucee-3.1-BETA-linux64-pl0-beta.sh

	These are meant to be run for the console, since most server OS's don't use a windowed system in order to
	free up resources. Just open up a console and run the following

	Usage in CentOS/RHEL:
	# chmod 744 lucee-3.1-BETA-linux32-pl0-beta.sh
	# ./lucee-3.1-BETA-linux32-pl0-beta.sh

	Usage on Ubuntu:
	> chmod 744 lucee-3.1-BETA-linux32-pl0-beta.sh
	> sudo ./lucee-3.1-BETA-linux32-pl0-beta.sh

	Then just answer the questions it presents to you while you install. 90% of the documentation I wrote for
	this project on the OpenBD wiki also applies to the Lucee version, so it's nice that it's already mostly
	documented there:

	http://wiki.openbluedragon.org/wiki/index.php/OpenBD_Installer

	Once you've got it installed, you can start and stop Tomcat/Lucee with the "lucee_ctl" script. If you opt
	to have Lucee start at system boot, there will be two copies:

	/opt/lucee/lucee_ctl
	/etc/init.d/lucee_ctl (optional during install)

	Either of these can be used to start and stop the server:
	/opt/lucee/lucee_ctl start
	or
	/opt/lucee/lucee_ctl stop
	or
	/opt/lucee/lucee_ctl restart

	The administration URL's will be as follows:
	Admin:
	http://[SERVER IP ADDRESS]/lucee-context/admin/server.cfm
	ROOT WebApp:
	http://[SERVER IP ADDRESS]/lucee-context/admin/web.cfm

	Things to look for while testing:

	- Anything unusual happen during the install process? Even if you're not sure if it's unusual or not, let
	me know about it.
	- Anything not clear about the install process? How can I make it more clear?
	- Anything not work for this install that works for another installation method? This is usually the result
	of a default configuration error that needs to be corrected.

	IMPORTANT: If you're using a proper domain name, you will need to configure Tomcat's server.xml file for
	that domain. The server.xml file has been commented to help make it easier. Just copy and paste the example,
	and change the two values appropriately.

	This installer has been configured to work through Apache to make it more compatible with control panels and
	the like. It also installs the Apache connector (a process that usually requires compiling, etc), so
	hopefully that piece is a lot easier then normal.

	I look forward to any feedback you have to offer!
