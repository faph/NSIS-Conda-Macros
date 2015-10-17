!include ..\conda.nsh

Name "Test create shortcut"
OutFile "create_shortcut.exe"
RequestExecutionLevel user
Page components
Page instfiles

Section "Shortcuts"
  !insertmacro CreateShortcut "Test Python GUI" \
    "testpackage" PY_GUI "Scripts\test-script.py" "app.ico"

  !insertmacro CreateShortcut "Test Python Console" \
    "testpackage" PY_CONSOLE "Scripts\test-script.py" "app.ico"

  !insertmacro CreateShortcut "Test Command" \
    "testpackage" "notepad" "c:\Windows\System32\drivers\etc\hosts" "app.ico"
SectionEnd
