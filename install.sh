#!/bin/bash

#Check if we need $SUDO
USER=`whoami`
SUDO='sudo'

if [ $USER == 'root' ]; then
	SUDO=''
fi

# Debian based distros
if [ -f "/etc/debian_version" ]; then
        DISTRO='debian'
fi

if [ -f "/etc/lsb-release" ]; then
        DISTRO='debian'
fi

# RPM based distros
if [ -f "/etc/redhat-release" ]; then
        DISTRO='rpm'
fi

if [ -f "/etc/system-release" ]; then
        DISTRO='rpm'
fi

# Install dependencies
if [ "$DISTRO" == 'debian' ]; then
                $SUDO apt-get update
                $SUDO apt-get -f -y install python python-setuptools wget sysstat
fi


if [ "$DISTRO" == 'rpm' ]; then
                $SUDO yum -t -y install python python-devel wget sysstat
fi

$SUDO wget http://code.stats.io/agent/install.php -O /etc/uuid
$SUDO mkdir /usr/src/stats
$SUDO wget http://code.stats.io/agent/agent.tar.gz -O /usr/src/stats/statsagent.tar.gz
cd /usr/src/stats
$SUDO tar zxf /usr/src/stats/statsagent.tar.gz
$SUDO python setup.py install
$SUDO cp stats-agent /etc/init.d
$SUDO chmod +x /etc/init.d/stats-agent
$SUDO /etc/init.d/stats-agent start

# Add the daemons to the startup list
if [ "$DISTRO" == 'debian' ] ; then
        $SUDO update-rc.d stats-agent defaults > /dev/null
fi

if [ "$DISTRO" == 'rpm' ] ; then
        $SUDO chkconfig --add stats-agent > /dev/null
fi

# Add ssh user and key
$SUDO useradd stats
$SUDO mkdir -p  ~stats/.ssh/
$SUDO wget http://code.stats.io/agent/ssh.php -O  ~stats/.ssh/authorized_keys
$SUDO chmod 600 ~stats/.ssh/authorized_keys
$SUDO chmod 700 ~stats/.ssh/
$SUDO chown -R stats:stats ~stats/
$SUDO sh -c "echo '# Automatically added by stats install script for remote access' >> /etc/sudoers"
$SUDO sh -c "echo 'stats ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers"
$SUDO sh -c 'echo "Defaults:stats !requiretty" >> /etc/sudoers'
