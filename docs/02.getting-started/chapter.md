---
title: Getting Started
---

# Getting Started

It is easy to get started with Lucee using Ortus Solutions CommandBox. CommandBox comes with an embedded Lucee server.

1. Download CommandBox - [Windows](http://commandbox) / [Mac](http://commandbox) / [Linux](http://commandbox)
2. Install CommandBox
3. Go to a terminal (Mac / Linux) or command prompt (Windows)
4. Navigate to a directory in which you want to keep your applications files
5. Type "box start" to start the embedded Lucee server within CommandBox.
6. The Lucee server will then start, on a random port and open in your default browser and show a file list of the directory in which you started it.
7. Open your favourite text editor and create a file called index.cfm containing the following and save it to the same directory:

    ```
    <cfset testVar = "Hello World">
    <h1><cfoutput>#testVar#</cfoutput></h1>
    ```

8. Refresh the browser window and your browser should display the index page you just created and display "Hello World".