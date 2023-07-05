---
title: Adding New Sites
id: windows-adding-new-sites
---

### Adding Sites to Windows/IIS7 ###

As of Lucee 3.3.2, the Lucee Installers come bundled with the BonCode Connector for IIS and mod_cfml. These two modules together automate the process of configuring Tomcat. Configuring Tomcat manually is still possible, but no longer required.

The purpose of this documentation is to explain the "recommended" way to set up a site with IIS and Tomcat. There are other ways of setting up sites, so if you need to customize your install a bit, you are welcome to do so. The statements made here are only meant as guidelines.

Requirements:

1. It is expected that you already have IIS installed. If not, install it before running the Lucee Windows Installer.
1. It is expected that you ran the Lucee Windows Installer and selected to install the IIS Connector as well. If not, go to C:\lucee\AJP13\Connector_Setup.exe and run it to connect Lucee to IIS.

Create The Site in IIS

Start off by adding your new site to IIS like you normally would. It is recommended that you place your site is an easy-to-identify location such as C:\inetpub\ (The default location for IIS), C:\websites\, C:\sites\, or something equally easy to identify and remember. For the purpose of this example, we'll be using C:\inetpub\.

* Open IIS Manager and in the left-hand menu, open it up to where you see "sites".

* When you add your new site to IIS, create a separate directory for it.

* So that all domains resolve, be sure to add a binding for any subdomains, like "www". Right-click the new site, and select "edit bindings". From there, add bindings as needed.

* Add your files to your site or just add a test "index.cfm" file for now. You can use notepad to edit your new CFM file if do not have an editor installed.

### Add Site to Windows "hosts" File & Preview ###

In order to allow yourself to preview a site before it becomes "live", you can add a site to your "hosts" file. This way, you can see the way your site will look when it is live, and allow you to correct any problems before the world sees it on your new server. The following will guide you through the process of editing your hosts file in order to preview your site.

* You need to run Notepad as the Administrator user. If you're not already running as "Administrator", right-click the "Notepad" icon and select "Run as Administrator".

* Next, we need to open the "hosts" file. In Notepad, hit File -> Open, then navigate to C:\Windows\System32\drivers\etc\, then, so you can see the "hosts" file, select "All Files" from the listing in the bottom-right. You should see the "hosts" file listed, go ahead and open it.

* Next, add your host to it. The format is IP -> tab -> domain name. Additional domains can be separated by commas.

* Save, the file, and open a browser to preview your new domain.