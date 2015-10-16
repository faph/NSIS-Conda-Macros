!include ..\conda.nsh

Name "Test delete shortcut"
OutFile "delete_shortcut.exe"
RequestExecutionLevel user
Page components
Page instfiles

Section "Delete Shortcuts"
  !insertmacro DeleteShortcut "Test Python GUI"
  !insertmacro DeleteShortcut "Test Python Console"
  !insertmacro DeleteShortcut "Test Command"
SectionEnd
