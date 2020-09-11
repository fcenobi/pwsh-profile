Set-ExecutionPolicy RemoteSigned -Scope LocalMachine -Force

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


if(!(Test-Path -Path $profile  )){New-Item -path $profile -type file -force}
if(!(Test-Path -Path $profile.AllUsersAllHosts  )){New-Item -path $profile.AllUsersAllHosts -type file -force}
if(!(Test-Path -Path $profile.AllUsersCurrentHost  )){New-Item -path $profile.AllUsersCurrentHost -type file -force}
if(!(Test-Path -Path $profile.CurrentUserAllHosts  )){New-Item -path $profile.CurrentUserAllHosts -type file -force}
if(!(Test-Path -Path $profile.CurrentUserCurrentHost )){New-Item -path $profile.CurrentUserCurrentHost -type file -force}



# Create a file named "winget.txt" in the same directory as this script.
# Write exact names for packages on each line.
# Ex: filename: winget.txt
# Microsoft.Edge
# Google.Chrome

Write-Host "Checking winget..."

Try{
	# Check if winget is already installed
	$er = (invoke-expression "winget -v") 2>&1
	if ($lastexitcode) {throw $er}
	Write-Host "winget is already installed."
}
Catch{
	# winget is not installed. Install it from the Github release
	Write-Host "winget is not found, installing it right now."
	
	$repo = "microsoft/winget-cli"
	$releases = "https://api.github.com/repos/$repo/releases"
	
	Write-Host "Determining latest release"
	$json = Invoke-WebRequest $releases
	$tag = ($json | ConvertFrom-Json)[0].tag_name
	$file = ($json | ConvertFrom-Json)[0].assets[0].name
	
	$download = "https://github.com/$repo/releases/download/$tag/$file"
	$output = $PSScriptRoot + "\winget-latest.appxbundle"
	Write-Host "Dowloading latest release"
	Invoke-WebRequest -Uri $download -OutFile $output
	
	Write-Host "Installing the package"
	Add-AppxPackage -Path $output
}
Finally {
# Start installing the packages with winget
winget install	7zip.7zip
winget install	Microsoft.PowerShell
winget install	GitHub.cli
winget install	AdoptOpenJDK.OpenJDK
winget install	Git.Git
winget install	Notepad++.Notepad++
winget install	Microsoft.dotNetFramework
winget install	Microsoft.dotnet
winget install	Yarn.Yarn
winget install	Google.Chrome
winget install	OpenJS.Nodejs
winget install	Nodist.Nodist
winget install	MRidgers.Clink
winget install	FarManager.FarManager
winget install	Microsoft.PowerToys
winget install	Microsoft.WindowsTerminal
winget install	Python.Python
winget install	PuTTY.PuTTY
winget install	WinSCP.WinSCP
winget install	dbeaver.dbeaver

	
	
	
#	Get-Content .\winget.txt | ForEach-Object {
#		iex ("winget install -e " + $_)
	}
}

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

 Set-PSRepository -InstallationPolicy Trusted -Name PSGALLERY

install-Module -Name posh-cargo           -Scope AllUsers -AllowClobber -Force -AcceptLicense -ErrorAction Continue
install-Module -Name PSReadLine           -Scope AllUsers -AllowClobber -Force -AcceptLicense -ErrorAction Continue
install-Module -Name posh-dotnet          -Scope AllUsers -AllowClobber -Force -AcceptLicense -ErrorAction Continue
install-Module -Name posh-cargo           -Scope AllUsers -AllowClobber -Force -AcceptLicense -ErrorAction Continue
install-Module -Name PSReadLine           -Scope AllUsers -AllowClobber -Force -AcceptLicense -ErrorAction Continue
install-Module -Name posh-dotnet          -Scope AllUsers -AllowClobber -Force -AcceptLicense -ErrorAction Continue
install-Module -Name posh-git             -Scope AllUsers -AllowClobber -Force -AcceptLicense -ErrorAction Continue
install-Module -Name npm-completion       -Scope AllUsers -AllowClobber -Force -AcceptLicense -ErrorAction Continue
install-Module -Name yarn-completion      -Scope AllUsers -AllowClobber -Force -AcceptLicense -ErrorAction Continue
install-Module -Name scoop-completion -Scope AllUsers -AllowClobber -Force -AcceptLicense -ErrorAction Continue
install-module -name admintoolbox -Scope AllUsers -AllowClobber -Force -AcceptLicense -ErrorAction Continue
import-Module -Name scoop-completion           -Global -FORCE -ErrorAction Continue
import-Module -Name posh-cargo           -Global -FORCE -ErrorAction Continue
import-Module -Name PSReadLine           -Global -FORCE -ErrorAction Continue
import-Module -Name posh-dotnet          -Global -FORCE -ErrorAction Continue
import-Module -Name posh-cargo           -Global -FORCE -ErrorAction Continue 
import-Module -Name PSReadLine           -Global -FORCE -ErrorAction Continue
import-Module -Name posh-dotnet          -Global -FORCE -ErrorAction Continue
import-Module -Name posh-git             -Global -FORCE -ErrorAction Continue
import-Module -Name npm-completion       -Global -FORCE -ErrorAction Continue
import-Module -Name yarn-completion      -Global -FORCE -ErrorAction Continue
import-module -name admintoolbox       -Global -FORCE -ErrorAction Continue

Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
 



