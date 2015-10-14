!include ..\conda.nsh

Name "Test install or update application"
OutFile "install_or_update_app.exe"
RequestExecutionLevel user
Page components
Page instfiles

Section "Application files" section_app
  !insertmacro InstallOrUpdateApp "appdirs=1.4.0=py33_0" "-c https://conda.anaconda.org/faph"
SectionEnd
