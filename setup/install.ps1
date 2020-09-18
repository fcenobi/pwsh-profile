# ----------------- #
# setup/install.ps1 #
# ----------------- #

# TODO: Check OS type and ensure running on windows
#Set-ExecutionPolicy UNRESTRICTED -Scope LocalMachine -Force
Set-PSRepository -InstallationPolicy Trusted -Name PSGALLERY 

$gitrepoaccount = "fcenobi"
$repo    = "pwsh-profile"
$branch  = "master"
iex "& { $(irm https://aka.ms/install-powershell.ps1) } -UseMSI"
#msiexec.exe /package PowerShell-7.0.1-win-x64.msi /quiet ADD_EXPLORER_CONTEXT_MENU_OPENPOWERSHELL=1 ENABLE_PSREMOTING=1 REGISTER_MANIFEST=1

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
winget install	GitHub.cli
winget install	AdoptOpenJDK.OpenJDK
winget install	Notepad++.Notepad++
winget install	Microsoft.dotNetFramework
winget install	Microsoft.dotnet
winget install	Yarn.Yarn
winget install	Google.Chrome
winget install	OpenJS.Nodejs
winget install	MRidgers.Clink
winget install	FarManager.FarManager
winget install	Microsoft.PowerToys
winget install	Microsoft.WindowsTerminal
winget install	Python.Python
winget install	PuTTY.PuTTY
winget install	WinSCP.WinSCP
winget install	dbeaver.dbeaver

}	
	
	
#	Get-Content .\winget.txt | ForEach-Object {
#		iex ("winget install -e " + $_)
#	}







Set-ExecutionPolicy RemoteSigned -Scope LocalMachine -Force
if(!(Test-Path -Path $profile  )){New-Item -path $profile -type file -force}
if(!(Test-Path -Path $profile.AllUsersAllHosts  )){New-Item -path $profile.AllUsersAllHosts -type file -force}
if(!(Test-Path -Path $profile.AllUsersCurrentHost  )){New-Item -path $profile.AllUsersCurrentHost -type file -force}
if(!(Test-Path -Path $profile.CurrentUserAllHosts  )){New-Item -path $profile.CurrentUserAllHosts -type file -force}
if(!(Test-Path -Path $profile.CurrentUserCurrentHost )){New-Item -path $profile.CurrentUserCurrentHost -type file -force}


$pwshProfileTempDir = Join-Path $env:TEMP "$repo"
if (![System.IO.Directory]::Exists($pwshProfileTempDir)) {[System.IO.Directory]::CreateDirectory($pwshProfileTempDir)}
$sourceFile = Join-Path $pwshProfileTempDir "$repo"
$pwshProfileInstallDir = Join-Path $pwshProfileTempDir "$repo-$branch"

copy-item -path .\env_path.cmd          -Destination (Join-Path (Split-Path -parent $env:ComSpec)   "Env_path.cmd"          )
copy-item -path .\env_pathEXT.cmd       -Destination (Join-Path (Split-Path -parent $env:ComSpec)   "Env_pathEXT.cmd"       )
copy-item -path .\env_psmodulepath.cmd  -Destination (Join-Path (Split-Path -parent $env:ComSpec)   "env_psmodulepath.cmd"  ) 
copy-item -path .\myenv.bat             -Destination (Join-Path (Split-Path -parent $env:ComSpec)   "myenv.bat"             )
copy-item -path .\pathadd.cmd           -Destination (Join-Path (Split-Path -parent $env:ComSpec)   "pathadd.cmd"           )


install-Module -Name posh-cargo           -Scope AllUsers -AllowClobber -Force -AcceptLicense -ErrorAction Continue
install-Module -Name posh-dotnet          -Scope AllUsers -AllowClobber -Force -AcceptLicense -ErrorAction Continue
install-Module -Name posh-cargo           -Scope AllUsers -AllowClobber -Force -AcceptLicense -ErrorAction Continue
install-Module -Name posh-dotnet          -Scope AllUsers -AllowClobber -Force -AcceptLicense -ErrorAction Continue
install-Module -Name posh-git             -Scope AllUsers -AllowClobber -Force -AcceptLicense -ErrorAction Continue
install-Module -Name npm-completion       	-Scope AllUsers -AllowClobber -Force -AcceptLicense -ErrorAction Continue
install-Module -Name yarn-completion      	-Scope AllUsers -AllowClobber -Force -AcceptLicense -ErrorAction Continue
install-Module -Name scoop-completion 		-Scope AllUsers -AllowClobber -Force -AcceptLicense -ErrorAction Continue
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

Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-ObjectSystem.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
choco feature enable -n allowGlobalConfirmation



function Download-File {
    param (
        [string]$url,
        [string]$file
    )
    Write-Host "Downloading $url to $file"
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    Invoke-WebRequest -Uri $url -OutFile $file
}

function Unzip-File {
    param (
        [string]$File,
        [string]$Destination = (Get-Location).Path
    )

    $filePath = Resolve-Path $File
    $destinationPath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($Destination)

    If (($PSVersionTable.PSVersion.Major -ge 3) -and
        (
            [version](Get-ItemProperty -Path "HKLM:\Software\Microsoft\NET Framework Setup\NDP\v4\Full" -ErrorAction SilentlyContinue).Version -ge [version]"4.5" -or
            [version](Get-ItemProperty -Path "HKLM:\Software\Microsoft\NET Framework Setup\NDP\v4\Client" -ErrorAction SilentlyContinue).Version -ge [version]"4.5"
        )) {
        try {
            [System.Reflection.Assembly]::LoadWithPartialName("System.IO.Compression.FileSystem") | Out-Null
            [System.IO.Compression.ZipFile]::ExtractToDirectory("$filePath", "$destinationPath")
        } catch {
            Write-Warning -Message "Unexpected Error. Error details: $_.Exception.Message"
        }
    } else {
        try {
            $shell = New-Object -ComObject Shell.Application
            $shell.Namespace($destinationPath).copyhere(($shell.NameSpace($filePath)).items())
        } catch {
            Write-Warning -Message "Unexpected Error. Error details: $_.Exception.Message"
        }
    }
}



#Download-File "https://github.com/$gitrepoaccount/$repo/archive/$branch.zip" $sourceFile
#if ([System.IO.Directory]::Exists($pwshProfileInstallDir)) {[System.IO.Directory]::Delete($pwshProfileInstallDir, $true)}
#Unzip-File $sourceFile $dotfilesTempDir

Push-Location "$pwshProfileInstallDir\pwsh"
& .\bootstrap.ps1

Pop-Location



#$newProcess = new-object System.Diagnostics.ProcessStartInfo "PowerShell";
#$newProcess = new-object System.Diagnostics.ProcessStartInfo "pwsh";

#$newProcess = new-object System.Diagnostics.ProcessStartInfo "pwsh";

$newProcess.Arguments = "-nologo";
[System.Diagnostics.Process]::Start($newProcess);
exit
# EOF #
