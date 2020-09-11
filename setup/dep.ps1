Set-ExecutionPolicy RemoteSigned -Scope LocalMachine -Force
if(!(Test-Path -Path $profile  )){New-Item -path $profile -type file -force}
if(!(Test-Path -Path $profile.AllUsersAllHosts  )){New-Item -path $profile.AllUsersAllHosts -type file -force}
if(!(Test-Path -Path $profile.AllUsersCurrentHost  )){New-Item -path $profile.AllUsersCurrentHost -type file -force}
if(!(Test-Path -Path $profile.CurrentUserAllHosts  )){New-Item -path $profile.CurrentUserAllHosts -type file -force}
if(!(Test-Path -Path $profile.CurrentUserCurrentHost )){New-Item -path $profile.CurrentUserCurrentHost -type file -force}

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

choco feature enable -n allowGlobalConfirmation
