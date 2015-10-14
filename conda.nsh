# Requires:
#   - NSISdl
#   - ExecDos


!define CONDA_URL https://repo.continuum.io/miniconda/Miniconda3-latest-Windows-x86_64.exe
!define ROOT_ENV "$LOCALAPPDATA\Continuum\Miniconda3"
!define ENVS "${ROOT_ENV}\envs"
!define CONDA "${ROOT_ENV}\Scripts\conda"


!macro InstallConda

  # Downloading miniconda
  SetOutPath "$TEMP\conda_installer"
  DetailPrint "Downloading Conda ..."
  NSISdl::download /TIMEOUT=1800000 ${CONDA_URL} conda_setup.exe
  !insertmacro _FinishMessage $R0 "Conda download"

  # Installing miniconda
  DetailPrint "Running Conda installer ..."
  ExecDos::exec /DETAILED '"$TEMP\conda_installer\conda_setup.exe" /S /D=${ROOT_ENV}"' "" ""
  !insertmacro _FinishMessage $0 "Conda installation"

  # Clean up
  SetOutPath "$TEMP"
  RMDir /r "$TEMP\conda_installer"

!macroend


!macro UpdateConda
  DetailPrint "Updating Conda ..."
  ExecDos::exec /DETAILED '"${CONDA}" update -y -q conda' "" ""
  !insertmacro _FinishMessage $0 "Conda update"
!macroend


!macro InstallOrUpdateConda
  IfFileExists "${ROOT_ENV}\python.exe" update_conda install_conda

  install_conda:
    !insertmacro InstallConda
    Goto install_or_update_conda_end

  update_conda:
    !insertmacro UpdateConda

  install_or_update_conda_end:
!macroend


!macro InstallApp package args
  DetailPrint "Downloading and installing application files ..."
  Push ${package}
  Call EnvName
  Pop $0
  ExecDos::exec /DETAILED '"${CONDA}" create -y -q ${args} \
    -p "${ENVS}\$0" \
    ${package}' "" ""
  !insertmacro _FinishMessage $0 "Application files installation"
!macroend


!macro UpdateApp package args
  DetailPrint "Downloading and installing application update ..."
  Push ${package}
  Call EnvName
  Pop $0
  ExecDos::exec /DETAILED '"${CONDA}" install -y -q ${args} \
    -p "${ENVS}\$0" \
    ${package}' "" ""
  !insertmacro _FinishMessage $0 "Application update"
!macroend


!macro InstallOrUpdateApp package args
  Push ${package}
  Call EnvName
  Pop $0
  IfFileExists "${ENVS}\$0\*.*" update_conda_app install_conda_app

  install_conda_app:
    !insertmacro InstallApp ${package} "${args}"
    Goto install_or_update_conda_app_end

  update_conda_app:
    !insertmacro UpdateApp ${package} "${args}"

  install_or_update_conda_app_end:
!macroend


!macro _FinishMessage v action
  Pop ${v}
  IntCmp ${v} 0 +4 0 0
    MessageBox MB_OK|MB_ICONEXCLAMATION "${action} could not be completed."
    DetailPrint "${action} could not be completed (exit code ${v})."
    Abort
  DetailPrint "${action} successfully completed."
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
