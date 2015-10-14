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

  SetOutPath "$PROFILE"
  CreateShortcut "$SMPROGRAMS\IPython Console.lnk" \
    "${ENVS}\_app_own_environment_ipython-qtconsole\pythonw.exe" \
    "${ENVS}\_app_own_environment_ipython-qtconsole\Scripts\jupyter-qtconsole-script.py" \
    "${ENVS}\_app_own_environment_ipython-qtconsole\Menu\IPython.ico" \
    0 "" "" "IPython Console (4.0.1)"
SectionEnd
