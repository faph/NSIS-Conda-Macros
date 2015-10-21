!include ..\conda.nsh

Name "Test delete application"
OutFile "delete_app.exe"
RequestExecutionLevel user
Page components
Page instfiles

Section "Application files"
  !insertmacro DeleteApp "appdirs"
SectionEnd
