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


!macro InstallApp package channel
  DetailPrint "Downloading and installing application files ..."
  ExecDos::exec /DETAILED '"${CONDA}" create -y -q \
    -p "${ENVS}\_app_own_environment_${package}" \
    -c ${channel} ${package}' "" ""
  !insertmacro _FinishMessage $0 "Application files installation"
!macroend


!macro UpdateApp package channel
  DetailPrint "Downloading and installing application update ..."
  ExecDos::exec /DETAILED '"${CONDA}" install -y -q \
    -p "${ENVS}\_app_own_environment_${package}" \
    -c ${channel} ${package}' "" ""
  !insertmacro _FinishMessage $0 "Application update"
!macroend


!macro InstallOrUpdateApp package channel
  IfFileExists "${ENVS}\_app_own_environment_${package}\*.*" update_conda_app install_conda_app

  install_conda_app:
    !insertmacro InstallApp ${package} ${channel}
    Goto install_or_update_conda_app_end

  update_conda_app:
    !insertmacro UpdateApp ${package} ${channel}

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
