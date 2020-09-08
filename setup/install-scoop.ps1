
Set-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem' -Name 'LongPathsEnabled' -Value 1
Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')
scoop bucket add extras
scoop bucket add java
scoop bucket add nirsoft-alternative https://github.com/MCOfficer/scoop-nirsoft.git
scoop bucket add wsl https://git.irs.sh/KNOXDEV/wsl
scoop bucket add php
scoop bucket add alias-additions https://github.com/snaphat/alias-additions.git
scoop bucket add nirsoft 'https://github.com/Ash258/Scoop-NirSoft.git'
scoop install alias-additions
scoop install 7zip
scoop install innounp
scoop install wixtoolset

taskkill /F /IM explorer.exe 
explorer.exe 

