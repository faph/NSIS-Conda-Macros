NSIS macros to install conda packages
=====================================

Fact: the [conda package manager](http://conda.pydata.org/miniconda.html) is
the best Python package and environment manager there is.

Fact: [NSIS](http://sourceforge.net/projects/nsis/) is the best Windows
application installer there is.

Combine the best of both worlds and distribute your conda package as a
single-file installer. End-users don't need to install anaconda or miniconda
first, they don't need to configure conda channels, nothing!


Tell me what to do!
-------------------

In your NSIS installer source file do something like this:

```nsis
!include conda.nsh

Section "Conda package manager"
  !insertmacro InstallOrUpdateConda
SectionEnd

Section "Application files"
  !insertmacro InstallOrUpdateApp "yourapp=1.0.0" \
    "-c https://anaconda.org/yourchannel"
SectionEnd

```

Application versions can be specified as per conda conventions, for example:

- `yourapp` (latest version available in channel)
- `yourapp=1.0.0`
- `yourapp=1.0.0=py34_0`


I don’t trust this, tell me what’s going on
------------------------------------------

Behind the scenes, the macros do the usual stuff:

1. Download Miniconda (the Python 3, win-64 version) from
   https://repo.continuum.io/miniconda/
2. Do a silent install using the default installer options for the current
   user. That means Python will be registered and `PATH` variables set only if
   it’s the first installed Python on the system. Miniconda will be installed
   into `%LOCALAPPDATA%\Continuum\Miniconda3`.
3. If Miniconda was previously installed, it will skip steps 1 and 2 do a
   simple `conda update conda`.
4. A conda environment is created in the python prefix
   `%LOCALAPPDATA%\Continuum\Miniconda3\envs\_app_own_environment_{package}`
   and the package is directly installed into this using the package spec and
   supplied channel.
5. If the prefix already exist the package is directly installed into it. This
   is suitable for updating a package.


Our legal team is asking ...
----------------------------

Distributed under the [MIT licence](LICENSE).

That means if this breaks your python installation, destroys your conda
environments, wipes your harddrive, etc., you have been warned.
