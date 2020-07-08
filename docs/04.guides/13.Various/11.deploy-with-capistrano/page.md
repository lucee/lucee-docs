---
title: Deploy with capistrano
id: deploy-with-capistrano
---

[Capistrano](http://www.capistranorb.com/) is a tool from the ruby world normally used to deploy Ruby on Rails applications.

We use this tool to deploy cfml projects to our server farm (4 linux servers for now).

Capistrano connects by ssh to the servers and update the code from the source code system (git, svn...). Each time we deploy, capistrano creates a new directory and move a link named "current" to this new checkout. This default behaviour doesn't work with tomcat, because you can't change the docBase without a restart (this include a link to a directory that is our case), so we point the docBase in the tomcat to a "production" directory and we rsync each time we do a deploy.

## Installation ##

You need to install ruby and the bundler gem.

In the root dir of your project create a Gemfile file with the content:

```lucee
source 'http://rubygems.org'

gem 'capistrano'
gem 'railsless-deploy'
```

In the command line:

```lucee
bundle
```

This will install the required libs and capistrano itself. It will create another file Gemfile.lock.

Execute in the root project directory:

```lucee
capify .
```

This command with create a Capfile file. Add the files Capfile, Gemfile and Gemfile.lock to your source control system.

## Configuration ##

**Capistrano** Create the file **config/deploy.rb** with the content:

```lucee
set :application, "Myproject"
set :repository, "ssh://myuser@mygitserver.com/path/to/git"
default_run_options[:pty] = true
set :scm, :git
set :branch, "master"
set :deploy_via, :remote_cache
set :copy_exclude, ['.git', 'config', 'Gemfile', 'Gemfile.lock']

set :deploy_to, "/var/www/myproject/"

set :keep_releases, 3
set :git_shallow_clone, 1
set :use_sudo, false

desc "Run tasks in production environment"
task :production do
        # Prompt to make really sure we want to deploy into production
  puts "\n\e[0;31m   ######################################################################"
  puts "   #\n   #       Are you REALLY sure you want to deploy to production?"
  puts "   #\n   #               Enter y/N + enter to continue\n   #"
  puts "   ######################################################################\e[0m\n"
  proceed = STDIN.gets[0..0] rescue nil
  exit unless proceed == 'y' || proceed == 'Y'

  set :copy_exclude, ['.git', 'config', 'Gemfile', 'Gemfile.lock', 'lib', 'mxunit', 'test']
  
  role :app, "deploy@prod_ip1", "deploy@prod_ip2", "deploy@prod_ip3", "deploy@prod_ip4"
end

desc "Run tasks in development"
task :devel do
	role :app, "deploy@devel_ip1", "deploy@devel_ip2"
end

namespace :deploy do
   task :default do
     update_code
     symlink
     rsync_production
   end

   task :rsync_production do
     run "rsync -a --delete #{release_path}/ /var/www/myproject/production/"
     cleanup
   end
end
```

### Remote server ###

We need to setup the remote servers. Create the directory /var/www/myproject/ and the user deploy that must have write access to this directory. Also we must install git in the servers.

```lucee
mkdir -p /var/www/myproject/production
useradd deploy
chown -R deploy /var/www/myproject/
```

### Tomcat ###

We need to point the docBase in server.xml to the production directory:

```lucee
<Host name="www.myproject.com" appBase="webapps">
   <Context path="" docBase="/var/www/myproject/production" />
</Host>
```

### Setup ###

In our dev machine we can check that the servers have the required dependencies with:

```lucee
cap production check
```

If is all OK, then tell capistrano to setup the remote servers:

```lucee
cap production setup
```

It will prompt about if we are sure to deploy in production system, press y and it will ask the deploy password in the servers (must be the same in all servers). Also will prompt for the password of the git user.

Same goes for our development machines just replace production with devel

Now we can deploy our project to the production with the command:

```lucee
cap production deploy
```

If all goes well we can see in /var/www/myproject/production/ all our codebase.

### Side notes ###

* The production server must have access to the git server. Remember that we connect to ssh to the production server and from there we update the code

* [You can setup ssh to not ask the password with ssh](http://www.debian-administration.org/articles/152)

* The WEB-INF directory could be problematic: we can create a directory in **/var/www/myproject/shared/WEB-INF** with write permission to tomcat user:

```lucee
mkdir  /var/www/myproject/shared/WEB-INF
chown tomcat7 /var/www/myproject/shared/WEB-INF
```

and symlink this directory in the production directory:

```lucee
ln -s /var/www/myproject/shared/WEB-INF/ /var/www/myproject/production/
```

* We can deploy other branch, just modify the line in **config/deploy.rb**:

```lucee
set :branch, "master"
```
