!include LogicLib.nsh

!define CONDA_URL https://repo.continuum.io/miniconda/Miniconda3-latest-Windows-x86_64.exe
var ROOT_ENV  # Conda root environment
var ENVS      # Path to all environments
var CONDA     # Conda executable


!macro InstallConda
  Call SetRootEnv

  # Downloading miniconda
  SetOutPath "$TEMP\conda_installer"
  DetailPrint "Downloading Conda ..."
  NSISdl::download /TIMEOUT=1800000 ${CONDA_URL} conda_setup.exe
  !insertmacro _FinishMessage "Conda download"

  # Installing miniconda
  DetailPrint "Running Conda installer ..."
  ExecDos::exec /DETAILED '"$TEMP\conda_installer\conda_setup.exe" /S /D=$ROOT_ENV"' "" ""
  !insertmacro _FinishMessage "Conda installation"

  # Clean up
  SetOutPath "$TEMP"
  RMDir /r "$TEMP\conda_installer"

!macroend


!macro UpdateConda
  Call SetRootEnv

  DetailPrint "Updating Conda ..."
  ExecDos::exec /DETAILED '"$CONDA" update -y -q conda' "" ""
  !insertmacro _FinishMessage "Conda update"
!macroend


!macro InstallOrUpdateConda
  Call SetRootEnv

  ${If} ${FileExists} "$ROOT_ENV\Scripts\conda.exe"
    !insertmacro UpdateConda
  ${Else}
    !insertmacro InstallConda
  ${EndIf}
!macroend


!macro InstallApp package args
  Call SetRootEnv

  DetailPrint "Downloading and installing application files ..."
  Push ${package}
  Call Prefix
  Pop $0
  ExecDos::exec /DETAILED '"$CONDA" create -y -q ${args} -p "$0" ${package}' "" ""
  !insertmacro _FinishMessage "Application files installation"
!macroend


!macro UpdateApp package args
  Call SetRootEnv

  DetailPrint "Downloading and installing application update ..."
  Push ${package}
  Call Prefix
  Pop $0
  ExecDos::exec /DETAILED '"$CONDA" install -y -q ${args} -p "$0" ${package}' "" ""
  !insertmacro _FinishMessage "Application update"
!macroend


!macro InstallOrUpdateApp package args
  Call SetRootEnv

  Push ${package}
  Call Prefix
  Pop $0

  ${If} ${FileExists} "$0"
    !insertmacro UpdateApp ${package} "${args}"
  ${Else}
    !insertmacro InstallApp ${package} "${args}"
  ${EndIf}
!macroend


!macro DeleteApp package
  Call SetRootEnv

  DetailPrint "Deleting application files ..."

  Push ${package}
  Call Prefix
  Pop $0
  ExecDos::exec /DETAILED '"$CONDA" remove -y -q -p "$0" --all --offline' "" ""
!macroend


!macro CreateShortcut title package cmd args ico
  DetailPrint "Creating Windows Start Menu shortcut ..."

  Push ${package}
  Call Prefix
  Pop $0  # Prefix

  # Copy icon into PREFIX\Menu
  SetOutPath "$0\Menu"
  File ${ico}

  Push $R1
  Push $R2
  ${Select} ${cmd}
    ${Case} "PY_CONSOLE"
      StrCpy $R1 "$0\python.exe"
      StrCpy $R2 "$0\${args}"
    ${Case} "PY_GUI"
      StrCpy $R1 "$0\pythonw.exe"
      StrCpy $R2 "$0\${args}"
    ${CaseElse}
      StrCpy $R1 "$0\${cmd}"
      StrCpy $R2 "${args}"
  ${EndSelect}

  SetOutPath "$PROFILE"  # Shortcut working dir
  CreateShortcut "$SMPROGRAMS\${title}.lnk" "$R1" "$R2" "$0\Menu\${ico}" 0 "" "" "Open ${title}"

  Pop $R1
  Pop $R2
!macroend


!macro DeleteShortcut title
  DetailPrint "Deleting Windows Start Menu shortcut ..."
  Delete "$SMPROGRAMS\${title}.lnk"
!macroend


!macro _FinishMessage action
  Pop $R0
  ${If} $R0 = 0
    DetailPrint "${action} successfully completed."
  ${Else}
    MessageBox MB_OK|MB_ICONEXCLAMATION "${action} could not be completed."
    DetailPrint "${action} could not be completed (exit code $R0)."
    Abort
  ${EndIf}
!macroend


Function EnvName
  Pop $0  # Package spec, e.g. appdirs=1.4.0=py33_0
  StrCpy $1 0
  loop:
      IntOp $1 $1 + 1
      StrCpy $2 $0 1 $1
      StrCmp $2 '=' found
      StrCmp $2 '' stop loop
  found:
      IntOp $1 $1 + 0
  stop:
  StrCpy $2 $0 $1
  Push "_app_own_environment_$2"
FunctionEnd


Function Prefix
  # Assumes package spec on stack
  Call EnvName
  Pop $0  # Env name
  Push "$ENVS\$0"
FunctionEnd


Function SetRootEnv
  # List of paths to search
  nsArray::SetList paths \
    "$LOCALAPPDATA\Continuum\Miniconda3" \
    "$PROFILE\Miniconda3" \
    "$LOCALAPPDATA\Continuum\Miniconda" \
    "$PROFILE\Miniconda" /end

  nsArray::Get paths 0
  Pop $ROOT_ENV  # first item as default

  ${DoUntil} ${Errors}
    nsArray::Iterate paths
    Pop $0  # key
    ${If} ${FileExists} "$1\Scripts\conda.exe"
      Pop $ROOT_ENV  # value
      ${ExitDo}
    ${EndIf}
  ${Loop}

  StrCpy $ENVS  "$ROOT_ENV\envs"
  StrCpy $CONDA "$ROOT_ENV\Scripts\conda"
FunctionEnd
