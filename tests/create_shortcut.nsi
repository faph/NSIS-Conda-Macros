!include ..\conda.nsh

Name "Test create shortcut"
OutFile "create_shortcut.exe"
RequestExecutionLevel user
Page components
Page instfiles

Section "Shortcuts"
  !insertmacro CreateShortcut "testpackage" "Test Python GUI" \
    PY_GUI "Scripts\test-script.py" "app.ico"

  !insertmacro CreateShortcut "testpackage" "Test Python Console" \
    PY_CONSOLE "Scripts\test-script.py" "app.ico"

  !insertmacro CreateShortcut "testpackage" "Test Command" \
    "notepad" "c:\Windows\System32\drivers\etc\hosts" "app.ico"
SectionEnd
