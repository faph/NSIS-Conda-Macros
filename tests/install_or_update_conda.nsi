!include ..\conda.nsh

Name "Test install or update Conda"
OutFile "install_or_update_conda.exe"
RequestExecutionLevel user
Page components
Page instfiles

Section "Conda" section_conda
  !insertmacro InstallOrUpdateConda
SectionEnd
