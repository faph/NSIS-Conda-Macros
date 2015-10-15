if not exist "%PREFIX%\Include" mkdir "%PREFIX%\Include"
copy "conda.nsh" "%PREFIX%\Include"
if errorlevel 1 exit 1
