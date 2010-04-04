#! /bin/bash
#
# pytailor.sh
# Turn a naked apple osx 10.6 machine into a python development machine.
#
# Copyright (C) 2010 Lars van de Kerkhof
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# The emphasis is on installing as little cruft on your machine as 
# possible. That is why not everything is installed with macports.
# Also some packages work better with other apps when they are not
# installed from macports (mysql).
#
# Installed packages:
#
# from macports:
# - macports
# - wget
# - libjpeg
# - python26
# - py26-lxml
# - python_select
#
# from 'official' dmg:
# - mysql
# - git
#
# from pypi:
# - pip
# - virtualenv
# - virtualenvwrapper
# - mysql-python
# - PIL
#
# And it sets up your .profile.

# fiddle with this if you need different versions.
MACPORTSVERSION="1.8.2"
GITVERSION="1.7.0.3"
MYSQLVERSION="5.1.45"
MYSQLLOCATION="http://mirror.leaseweb.com/mysql/Downloads/MySQL-5.1/"

if [ ! -d '/Developer' ]; then
    echo "install developer tools first from the osx install dvd."
    exit 1
fi

# create local mount point
mkdir -p mountpoint

echo "installing macports."
curl -C - -O http://distfiles.macports.org/MacPorts/MacPorts-${MACPORTSVERSION}-10.6-SnowLeopard.dmg
hdiutil attach MacPorts-${MACPORTSVERSION}-10.6-SnowLeopard.dmg -mountpoint mountpoint
echo "installing macports into /opt."
sudo installer -pkg mountpoint/MacPorts-${MACPORTSVERSION}.pkg -target LocalSystem
echo "running the post install script."
sudo PACKAGE_PATH=mountpoint/MacPorts-1.8.2.pkg ./mountpoint/MacPorts-1.8.2.pkg/Contents/Resources/postflight
hdiutil detach mountpoint

# install packages
echo "installing wget."
sudo port install wget
echo "installing libjpeg"
sudo port install jpeg
echo "installing python26."
sudo port install python26
echo "installing py26-lxml."
sudo port install py26-lxml
echo "installing python_select and making python26 the default python."
sudo port install python_select
sudo python_select python26

# install working mysql
echo "getting mysql from dev.mysql.com."
wget --no-clobber ${MYSQLLOCATION}/mysql-${MYSQLVERSION}-osx10.6-x86_64.dmg
hdiutil attach mysql-${MYSQLVERSION}-osx10.6-x86_64.dmg -mountpoint mountpoint
echo "installing mysql."
sudo ./mountpoint/mysql-${MYSQLVERSION}-osx10.6-x86_64.pkg/Contents/Resources/preflight
sudo installer -pkg mountpoint/mysql-${MYSQLVERSION}-osx10.6-x86_64.pkg -target LocalSystem
sudo ./mountpoint/mysql-${MYSQLVERSION}-osx10.6-x86_64.pkg/Contents/Resources/postflight
echo "Installing mysql prefpane in system preferences."
open mountpoint/MySQL.prefPane
hdiutil detach mountpoint

# install git without installing new perl
echo "getting git for osx"
wget --no-clobber http://git-osx-installer.googlecode.com/files/git-1.7.0.3-intel-leopard.dmg
hdiutil attach git-${GITVERSION}-intel-leopard.dmg -mountpoint mountpoint
echo "installing git for osx."
sudo installer -pkg mountpoint/git-${GITVERSION}-intel-leopard.pkg -target LocalSystem
sudo ./mountpoint/setup\ git\ PATH\ for\ non-terminal\ programs.sh
hdiutil detach mountpoint

echo "adding python script dir and mysql to PATH in ~/.profile."
echo "
#mysql should be in the path for mysql_config.
export PATH=\"/usr/local/mysql/bin:\$PATH\"

#python scripts should also be in the path.
export PATH=\"/opt/local/Library/Frameworks/Python.framework/Versions/2.6/bin:\$PATH\"
" >> ~/.profile

echo "loading the updated ~/.profile."
source ~/.profile

echo "Python is here:"
echo `which python`
echo "Using this easy_install to install pip."
echo `which easy_install-2.6`
sudo easy_install-2.6 pip
echo "pip is here:"
echo `which pip`

echo "Installing virtualenv and virtualenvwrapper."
sudo pip install virtualenv
sudo pip install virtualenvwrapper
echo "creating virtualenv home in ~/.virtualenvs."
mkdir ~/.virtualenvs
echo "Adding virtualenvwrapper_bashrc to ~/.profile"
echo "
#Virtualenvwrapper is only usefull if it is activated in the profile:
source virtualenvwrapper_bashrc
" >> ~/.profile

echo "installing mysql-python."
sudo pip install mysql-python

echo "installing python imaging library (PIL)."
sudo pip install PIL

echo ""
echo "The end."
