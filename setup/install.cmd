Powershell.exe -Command "& {Start-Process Powershell.exe -ArgumentList 'ExecutionPolicy unrestrict -File regmod.ps1' -Verb RunAs}"
Powershell.exe -Command "& {Start-Process Powershell.exe -ArgumentList 'ExecutionPolicy unrestrict -File install-pwsh.ps1 -Verb RunAs}"
pwsh.exe -Command "& {Start-Process Powershell.exe -ArgumentList 'ExecutionPolicy unrestrict -File install-winget.ps1 -Verb RunAs}"
pwsh.exe -Command "& {Start-Process Powershell.exe -ArgumentList 'ExecutionPolicy unrestrict -File  install-wingetpkg.ps1 -Verb RunAs}"
pwsh.exe -Command "& {Start-Process Powershell.exe -ArgumentList 'ExecutionPolicy unrestrict -File  install-psmod-choco.ps1 -Verb RunAs}"


