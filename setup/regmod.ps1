Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" "DisableStartupSound" 1
Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI\BootAnimation" "DisableStartupSound" 1
powercfg /hibernate off
if (!(Test-Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer")) {New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Type Folder | Out-Null}
if (!(Test-Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\CabinetState")) {New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\CabinetState" -Type Folder | Out-Null}
if (!(Test-Path "HKLM:\Software\Policies\Microsoft\Windows\Windows Search")) {New-Item -Path "HKLM:\Software\Policies\Microsoft\Windows\Windows Search" -Type Folder | Out-Null}
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "Hidden" 1
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "HideFileExt" 0
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\CabinetState" "FullPath" 1
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" "DisableThumbnailsOnNetworkFolders" 1
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "TaskbarSmallIcons" 1
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "StoreAppsOnTaskbar" 0
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" "BingSearchEnabled" 0 # For Windows 10
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" "ConfirmFileDelete" 0
if (!(Test-Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\Narrator.exe")) {New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\Narrator.exe" -Type Folder | Out-Null}
Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\Narrator.exe" "Debugger" "%1"
Set-ItemProperty "HKCU:\Software\Microsoft\Internet Explorer\Main" "Start Page" "about:blank"
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Internet Explorer\Main" "Check_Associations" "no"
