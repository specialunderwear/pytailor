Turn a naked apple osx 10.6 machine into a python development machine.
======================================================================

    Copyright (C) 2010 Lars van de Kerkhof
    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.
    
    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
    
    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.

The emphasis is on installing as little cruft on your machine as 
possible. That is why not everything is installed with macports.
Also some packages work better with other apps when they are not
installed from macports (mysql).

Installed packages:
-------------------

from macports:

- macports
- wget
- libjpeg
- python26
- py26-lxml
- python_select

from 'official' dmg:

- mysql
- git

from pypi:

- pip
- virtualenv
- virtualenvwrapper
- mysql-python
- PIL

And it sets up your .profile.
