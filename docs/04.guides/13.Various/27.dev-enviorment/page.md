---
title: Setting Up a Dev Environment to Compare Lucee and ACF on OSX
id: setting-dev-environment-osx
menuTitle: Setting up OSX
---

This is a personal account of how one developer managed to install Lucee to test an existing codebase developed in Adobe ColdFusion and got them running side by side on the same set of files. The objective was to be able to easily compare how an application runs in ACF and ColdFusion. Because the technique relies on symlinks, it will only work on an OS where symlinks can be created, so I'm not sure if this is adaptable to Windows.

I already had CF10 installed locally on the dev machine, and have been using the inbuilt web server to develop on. It is installed under Applications/ColdFusion10, and listens on port 8500.

I downloaded the OSX version of Lucee Server with Tomcat 7 from [http://download.lucee.org](http://download.lucee.org) and installed it under /Applications/Lucee/ (Tomcat is essential to replicate this exact procedure, but I assume it should work under Jetty as well).

Then I messed around for awhile while I figured out how to access the web root from the browser. I expected it to be on either 8080 or 8888 from what I could find, but in fact tomcat was installed by default to listen on port 80. So after a time, I found the Lucee welcome page at http://localhost. It might be helpful if the installer itself guided the first time user to this welcome page. Once I was there, a bit of critical information was revealed:

If you want to start running some code in this Lucee instance, simply place it in the website's folder at:

```lucee
/Applications/Lucee/tomcat/webapps/ROOT/
```

Note that the ColdFusion builtin webserver, Tomcat, is listening to port 8500, and Lucee's builtin webserver, also Tomcat, is listening on port 80. It's essential of course that these port settings are different.

Being a bit lazy, the first thing I tried was to create an alias to my "test" ColdFusion application directory under /Applications/Lucee/tomcat/webapps/ROOT/ which is something you can do simply in the Finder. When I browsed to localhost/test/ Lucee complained it couldn't find the directory. Just to make sure, I tried localhost/test/testfile.cfm, same complaint.

A little Google Fu revealed that symlinks and aliases are different, the main factor being that some applications don't recognize aliases, but generally they do recognize symlinks. Here's the reference I found:


So I deleted the alias and opened Terminal. Typed in ln -s , dragged the path to my test directory from Finder into the Terminal window to avoid mistyping it, dragged the path to /Applications/Lucee/tomcat/webapps/ROOT/ behind it and typed test at the end, and hit enter. Here's the whole command:

ln -s /Applications/ColdFusion10/cfusion/wwwroot/test /Applications/Lucee/tomcat/webapps/ROOT/test

A test directory with an alias symbol on top of it immediately appeared under /Applications/Lucee/tomcat/webapps/ROOT/ (Yes!)

Then I went to localhost/test/testFile.cfm and Lucee served it correctly. (Yes!)

Then I opened /Applications/ColdFusion10/cfusion/wwwroot/test/testFile.cfm, made a change and saved it. The change showed up in localhost/test/testFile.cfm when I refreshed the page. (Perfect!) This demonstrated that I could change the file under CF10's wwwroot, check it in CF10 at localhost:8500, and then immediately check it in Lucee at localhost. This is exactly what I want to do to confirm that ongoing development is compatible with Lucee so that I can host this particular app (or any other) under Lucee for my clients going forward.

Now that I had confirmed it worked with my test directory, I ran the following in Terminal:

ln -s /Applications/ColdFusion10/cfusion/wwwroot/pulical /Applications/Lucee/tomcat/webapps/ROOT/pulical

Pulical is the name of the directory which houses the main application I'm working on. The directory with the alias symbol on it immediately appeared under /Applications/Lucee/tomcat/webapps/ROOT/, but I got an error running it under localhost/pulical/ - it's not finding coldspring. Ah, ok, so I created a symlink for the coldspring directory:

ln -s /Applications/ColdFusion10/cfusion/wwwroot/coldspring /Applications/Lucee/tomcat/webapps/ROOT/coldspring

And the login screen loaded. (Yes!) But it didn't look right. The styles were missing (boo ...) Logging in, it became apparent that Lucee was outputting the correct source code, but stylesheets, javascript, and images were not being rendered. Hmmm ...

A little digging on Google and I found this is a problem others have experienced. To test a little further, I copied a directory from another simple project from /Applications/ColdFusion10/cfusion/wwwroot/ to /Applications/Lucee/tomcat/webapps/ROOT/ and sure enough, the source code was correct but css, js and images were not rendered. (Hope ...)

So I followed Igal's instructions here:

[https://groups.google.com/forum/#!topic/railo/DmLUzaCGX_8](https://groups.google.com/forum/#!topic/railo/DmLUzaCGX_8)

and added the following servlet and servlet mappings to /Applications/Lucee/tomcat/webapps/ROOT/WEB-INF/web.xml

FileServlet File Servlet for static files railo.loader.servlet.FileServlet 2 FileServlet *.css FileServlet *.js FileServlet *.jpg FileServlet *.gif FileServlet *.png
... saved web.xml and restarted Lucee using the following commands in Terminal

/Applications/Lucee/tomcat/bin/shutdown.sh sudo /Applications/Lucee/tomcat/bin/startup.sh

(not 100% sure if this is needed but did it anyway).

Then I refreshed the Lucee view of the main application I'm working on at localhost/pulical and everything rendered correctly! (Yes!)

Lessons learned:

* Tomcat's built in web server needs to be configured to render assets, but this is simple to do once you know how.
* Symlinks work well to allow for efficient, side by side testing of ACF and Lucee to ensure compatibility if you are thinking of migrating an app to Lucee.
* After working with this for only a day now, I'm impressed by what it reveals.
