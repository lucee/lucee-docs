---
title: Launching the Installer
id: linux-launching-the-installer
---

The Lucee Installer for Linux will work fine in both a Windowed or Console environment. Generally speaking, you can launch the installer and the installer will auto-detect if you are running in a Graphic environment or a Console environment, and select it's own installation method accordingly.

For Linux machines, please note that double-clicking the installer file may not work for your Desktop. Gnome and KDE may not know how to properly handle the file. Even though the installer can be Graphical, you may be required to launch the installer from the command-line. The following notes should help you accomplish this.

### Installing on CentOS/RHEL ###

The Lucee Installer can be run in both Graphical and Text mode on CentOS and other RHEL-based systems. The following sections describe launching the installer in both Graphical and text-based environments.

### Graphic Install ###

The installer will attempt to run in graphical mode if there is a desktop available. The following set of instructions show how to launch the installer from both the Graphical User Interface (GUI), like Gnome or KDE, or from a command-line that has access to it. If your server environment doesn't run a GUI (most *nix server environments do not), then the installer should auto-detect that and run in text mode.

The following example will demonstrate how to activate the installer using the GUI that's available on CentOS 5 - which is powered by the Gnome desktop environment. **IMPORTANT:** Also, I will be logging in to the server directly as the "root" user. The installer needs "root" permissions in order to do all the things it needs to.

Start by downloading the installer from the [Lucee.org Download Site](https://lucee.org/downloads.html) if you haven't already. In this example, I will download mine to my desktop.

Once downloaded, we need to give the installer "Execute" permissions. To do that, start by right-clicking on the installer and selecting the "Properties" option:

This will open the "properties" window. Next, select the "Permissions" tab, and click the check-box next to "Execute". Then, click the "close" button:

This should give the installer the execute permissions it needs to run like it should:

### Command-Line Install ###

Once you've downloaded the installer and logged in as the root user, you can run the installer with a simple set of commands:]

```lucee
$ cd [download location] 
$ chmod 744 lucee-[version]-linux-installer.bin 
$ sudo ./lucee-[version]-linux-installer.bin
```

If your console has access to your Desktop, the Graphic installer should start up at this point. If the console that you're running this command from does not have access to your Desktop, the installer will default to console, or "text" mode. Text mode is not as hard to use as it may sound. Just like in graphic mode, you will be presented with a series of options, most of which have defaults and you can just hit "enter" as you see fit.

### Forcing Text (Console) Mode ###

If you would like to force a text mode install, you can add the following option when you launch the installer from the command-line:

```lucee
# ./lucee-[version]-linux-installer.bin --mode text
```

### Installing on Ubuntu/Debian ###

#### Graphic Install ####

The installer can be run graphically when launched both from the command-line and from the Ubuntu Gnome Desktop. The following set of instructions should help get the installer running quickly and easily in graphic mode without having to mess with the command-line console.

Start by downloading the installer from the [Lucee.org Download Site](https://lucee.org/downloads.html) if you haven't already.

Next, right click the installer, select properties:

This should open the File Properties Window. Select the "Permissions" tab, and make sure the "Execute" check-boxes are checked:

Now that we know we can execute the installer, let's run it! Right click the file, and select "Open With Other Application":

We're going to open the installer with "gksudo" which is a graphical form of the "sudo" command. This will run the installer with Root Permissions. When the "Open With" window pops up, notice at the bottom there's a "Use a custom command" option, click it, and a text field will pop up. Type in "gksudo" into that text field and hit the "Open" button at the bottom.

**IMPORTANT:** Ubuntu will prompt you for your password here. It needs your password so it can assign root permissions to the installer. Once you provide your login password to Ubuntu, it will launch the installer and you should be off and running!

### Command-Line Install ###

The installer is designed to be executed by the root user. If you are not logged in as the root user, you will need to "su" or "sudo" the script in order for it to function properly.

For a command-line install on Ubuntu, after you've downloaded the Installer (In this example I've downloaded it to my Desktop), you need to run the following set of commands: $ cd [download location] $ chmod 744 lucee-[version]-linux-installer.bin $ sudo ./lucee-[version]-linux-installer.bin

You'll be prompted for your user's password. This is UBUNTU asking for permission to run the script as root - it is not a prompt from the installer. Once you enter your password the installer should continue normally.

**IMPORTANT:** If you have a GUI available, the installer will attempt to launch in graphical mode. If you do NOT have a GUI available, the installer will detect that and launch in text mode. If you encounter a situation where the installer improperly detects a GUI - like maybe a remote desktop session of some sort - then you can force a text mode install on Ubuntu just like you can on CentOS/RHEL-based systems. Check the documentation above for how to do that.
