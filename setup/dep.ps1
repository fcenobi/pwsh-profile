
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

Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

choco feature enable -n allowGlobalConfirmation
