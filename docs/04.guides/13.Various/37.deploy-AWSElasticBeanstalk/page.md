---
title: Deploy AWSElasticBeanstalk
id: deploy-awsElasticBeanStakk
---

### Running Lucee on Amazon's Elastic Beanstalk ###

With the release of Amazon's AWS Elastic Beanstalk service, it has never been easier to run Lucee in the cloud. Amazon BeanStalk is a way to deploy Java Applications (which is what Lucee is essentially) as war files into existing Tomcat containers that AWS manages for you. It also allows for easy scaling and balancing. If you want to just get Lucee running you can do that by reading getting started documentation hosted here: http://docs.amazonwebservices.com/elasticbeanstalk/latest/gsg/ and using the Lucee WAR to upload.

This tutorial will take you through setting up an environment that you can develop and deploy a sample application up to Beanstalk, rather than just a single WAR file.

1) Required software

Before we get running, let's go and get all the things we need to build both a local environment and deploy to Beanstalk:

* Eclipse IDE for Java EE Developers http://www.eclipse.org/downloads/packages/eclipse-ide-java-ee-developers/heliossr1
* Apache Tomcat 6.0 (this is what is deployed in Beanstalk so might as well have a local copy) http://tomcat.apache.org/download-60.cgi
* AWS Toolkit for Eclipse use the following Eclipse update site: http://aws.amazon.com/eclipse/
* CFEclipse (if you are going to be editing CFML you might as well get it)use the following update site: http://www.cfeclipse.org/update/
* Lucee Server as a WAR: just download the all OS WAR version from : https://download.lucee.org/

1) Sign up and Credentials

So that you can use Beanstalk you should obviously sign up for it! Head over to http://aws.amazon.com/elasticbeanstalk/ and then you can sign up for an account, once you have been accepted (takes a few seconds really) you should also get your Account info. Sometimes this is misleading so head to your AWS Account page at http://aws.amazon.com/account/: and you will be able to click on "Security Credentials" and make a note of your Access Key ID and Secret Access Key.

3) Install the plugins for Eclipse

Once you get Eclipse running, you need to install the plugins, if you have not used Eclipse before it's very simple, click on Help -> Install New Software... and add http://aws.amazon.com/eclipse/ to "Work With" field

Select the whole of the AWS Tookkit for Eclipse, and accept the license and follow the prompts until it restarts Eclipse. Follow the same procedure to install CFEclipse.

4) Creating the project

Now that we have Eclipse all ready to go with the plugins, we can create a new project in Eclipse and select the AWS ->AWA Java WEB Project.

When you click next, you will need to give your project a name, so for example "lucee_demo" and enter your AWS Access Key ID and Secret Access Key, we can just select a Basic Java Web Application, since we are going to replace a lot of it with our own Lucee WAR.

Click Finish.

4) Running the application locally

Now that we have the basic project setup, we need to run it locally. Right click on the project and select Run As -> Run On Server

Hit Next >

Now we define the local server that we are going to be using, select Tomcat V6.0 and using the Browse... button point it to your local Tomcat installation directory


Press Finish and the local server should be created. and started, you should get a window in Eclipse like the one below:

Now that we have this running fine, click on the Servers tab (shown above) and stop the server. Double click on the server and you will get a Server configuration screen.

Under "Server Options" tick the checkbox that says "Server modules without publishing" and save the page.


Now we are going to deploy Lucee into our WebContent folder. To do this you first need to rename the "lucee-3.2.1.000.war" file to "lucee-3.2.1.000.zip" file and unzip it, this should give you a folder called "lucee-3.2.1.000" open the folder and select all the contents (including the WEB-INF) folder and copy them to the WebContent folder in your project.
Start the server again and if is all working you should get the lucee startup page!


You can now do any configuration you need to such as adding a server and web password (under http://localhost:8080/lucee_demo/lucee/admin/web.cfm). Once you have done this, make sure (and click refresh on the WEB-INF folder) that under WebContent/WEB-INF/lucee/ you have a lucee-web.xml file This is the Lucee settings file that saves the passwords and it's important that it's deployed with the project, so that DSN's and other settings can be deployed with your project. (thanks to Dough Hughes for spotting this)

5) Deploy to BeanStalk


Now that we have Lucee running locally, we can deploy it to BeanStalk. Right click on your lucee_demo project and select "Run As" -> Run on Server:

Select to "Manually define a new server" and select the "AWS Elastic Beanstalk for Tomcat 6" from under the Amazon Web Services Folder.

Click Next > and then select to Create a new application named "luceedeploy" and give the name of your new Environment as "luceedemo" make sure you have no spaces or strange characters as they are not allowed by Beanstalk and you will only find out a while later. Once you have done this click "Finish"

After a while it will set up the environment and ask you for the Version Label for this deployment, leave it as is and click "OK"

The process of deploying can take some time so you will see a long progress bar that will take a few minutes as it uploads your application to Amazon S3.

Once the process is complete, you can double click on the server marked "luceedeploy at AWS Elastic Beanstalk" and you will get a summary page with the URL of your deployment. Click on that and you should get the lucee startup page!

That's it. Have fun deploying Lucee to the Elastic Beanstalk!