!include MUI2.nsh
!include ..\conda.nsh

Name "IPython Console"
OutFile "ipython.exe"
RequestExecutionLevel user

!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_LANGUAGE "English"

Section "Conda" section_conda
  !insertmacro InstallOrUpdateConda
SectionEnd

Section "IPython Application files" section_app
  !insertmacro InstallOrUpdateApp "ipython-qtconsole" ""
SectionEnd

Section "Start Menu shortcut"
  DetailPrint "Creating Windows Start Menu shortcuts."

  Push "ipython-qtconsole"
  Call EnvName
  Pop $0  # environment name

  SetOutPath "$PROFILE"
  CreateShortcut "$SMPROGRAMS\IPython Console.lnk" \
    "${ENVS}\$0\pythonw.exe" \
    "${ENVS}\$0\Scripts\jupyter-qtconsole-script.py" \
    "${ENVS}\$0\Menu\IPython.ico" \
    0 "" "" "IPython Console (4.0.1)"
SectionEnd
