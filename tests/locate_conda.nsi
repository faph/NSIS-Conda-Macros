Name "Locate application"
OutFile "locate_conda.exe"
RequestExecutionLevel user
Page components
Page instfiles

!include ..\conda.nsh


Section Search
  Call _SearchRootEnv
  Pop $0
  DetailPrint "Root env: $0"
SectionEnd
