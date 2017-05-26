---
title: Tutorial Extension_Provider_Part5
id: tutorial-extension-provider-part5
---

### Writing an extension - Part IV - Tips and tricks ###

We have completely built an extension from scratch and created the form to enter the data and validate it with the help of the install.cfc methods. The install method in there finally installs the application. In order to work quite fast when creating an etension there are a couple of things that might help.

1. When you install an extension it will be installed into the following folder: WEB-INF/lucee/extensions/hashvalueoftheprovider/extensionname/version.rep You can convert the existing .rep file into a zip (or associate .rep with a zip program, why this is a good thing, see Tip 3). Then you can have a look at any extension you have installed on your system.
1. When an extension is installed this .rep file is downloaded and the files in there are invoked for every kind of step. Remember that the file gets deleted as soon as you uninstall the application.
1. When you associate the .rep extension with a unzip folder (so that you can enter it) you can edit files directly in there so that you do not need to upload your complete extension to the extension manager and do the install process all over again. Since Lucee uses this .rep if it is available, you can easily exchange the files in there for development.
1. Please note thate if the .rep file is in the corresponding extension folder it will not be downloaded over and over again
1. If the uninstaller throws an error the installation will be removed from the list of the installed applications, but you have to clean up the leftovers yourself. That's why it is always advisable to deeply test the uninstaller. Even though Laura Arguello (author of Mango) said, and I quote here: "Why would someone want to uninstall Mango?"

Now... Have fun building your own extensions!