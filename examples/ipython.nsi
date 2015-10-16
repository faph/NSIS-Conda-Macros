!include MUI2.nsh
!include ..\conda.nsh

Name "IPython Console"
OutFile "ipython.exe"
RequestExecutionLevel user

!insertmacro MUI_PAGE_WELCOME
!define MUI_COMPONENTSPAGE_NODESC
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_LANGUAGE "English"


Section "Conda package manager"
  !insertmacro InstallOrUpdateConda
SectionEnd


Section "IPython Application files"
  !insertmacro InstallOrUpdateApp "ipython-qtconsole" ""
SectionEnd


Section "Start Menu shortcut"
  !insertmacro CreateShortcut "ipython-qtconsole" "IPython Console" \
    PY_GUI "Scripts\jupyter-qtconsole-script.py" "IPython.ico"
SectionEnd
