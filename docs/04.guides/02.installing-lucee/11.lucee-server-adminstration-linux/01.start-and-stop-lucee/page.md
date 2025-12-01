---
title: Starting and Stopping Lucee on Linux
id: linux-starting-and-stopping-lucee
categories:
- server
related:
- windows-start-stop-lucee
---

In a Linux environment, Lucee can be controlled by using the provided [lucee_ctl](https://github.com/lucee/lucee-installer/blob/master/lucee/linux/sys/lucee_ctl_template) script, which is configured by the installer according to your choices.

The control script is created in the root of your Lucee installation directory (usually `/opt/lucee/lucee_ctl` by default). If you opted to have Lucee start at boot time, the installer will also register this as a system service.

### Permissions ###

Root-level privileges are required to use the `lucee_ctl` script. This means you have to either be logged in directly as root, su to root, or sudo to root.

You can use the bundled Tomcat shell scripts (`startup.sh`, `shutdown.sh` and `catalina.sh`), **but make sure you are running as the correct user**, otherwise it can cause permission problems. It's best to use `lucee_ctl`.

## Using systemd (Modern Linux - Recommended) ##

> **Note:** systemd support was added in Lucee Installer 7.0.1 and 6.2.4. Earlier versions use the legacy SysVinit method.

All modern Linux distributions (RHEL/CentOS 7+, Debian 8+, Ubuntu 15.04+, Arch, Fedora, AlmaLinux, etc.) use **systemd** as their init system. When you install Lucee with `--startatboot true`, the installer automatically creates a systemd service file.

### Starting and Stopping with systemctl ###

```bash
# Start Lucee
sudo systemctl start lucee_ctl

# Stop Lucee
sudo systemctl stop lucee_ctl

# Restart Lucee
sudo systemctl restart lucee_ctl

# Check status
sudo systemctl status lucee_ctl

# View logs
sudo journalctl -u lucee_ctl
```

### Enable/Disable Auto-Start at Boot ###

```bash
# Enable auto-start at boot
sudo systemctl enable lucee_ctl

# Disable auto-start at boot
sudo systemctl disable lucee_ctl
```

### Custom Service Names ###

If you installed Lucee with a custom service name (using `--servicename`), use that name instead:

```bash
sudo systemctl start my_app_ctl
sudo systemctl status my_app_ctl
```

This is useful when running multiple Lucee instances on the same server.

### The systemd Service File ###

The systemd service file is created at `/etc/systemd/system/lucee_ctl.service` (or `/etc/systemd/system/{servicename}_ctl.service` for custom names). You can view it with:

```bash
cat /etc/systemd/system/lucee_ctl.service
```

## Using the lucee_ctl Script Directly ##

You can also control Lucee directly using the `lucee_ctl` script:

```bash
sudo /opt/lucee/lucee_ctl start
sudo /opt/lucee/lucee_ctl stop
sudo /opt/lucee/lucee_ctl restart
sudo /opt/lucee/lucee_ctl status
sudo /opt/lucee/lucee_ctl forcequit
```

> **Warning:** If you have Lucee registered as a systemd service, you should use `systemctl` commands instead of calling `lucee_ctl` directly. Starting or stopping Lucee outside of systemd can cause systemd to lose track of the process, leading to issues like:
>
> - `systemctl status` showing incorrect state
> - `systemctl start` failing because Lucee is already running (but systemd doesn't know)
> - PID file ownership conflicts
>
> If you get into this state, stop Lucee with `sudo /opt/lucee/lucee_ctl stop`, then use `systemctl start lucee_ctl` to let systemd manage it properly.

## Legacy Init Systems (SysVinit) ##

On older Linux systems that don't use systemd, the installer falls back to the legacy SysVinit method, copying the script to `/etc/init.d/`.

### Using the service command ###

```bash
sudo service lucee_ctl start
sudo service lucee_ctl stop
sudo service lucee_ctl restart
```

This method is only used on systems without systemd (e.g., older RHEL 6, Debian 7, etc.).
