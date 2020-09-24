#Requires -RunAsAdministrator

[CmdletBinding()]
param(
    [string] $Name
)

$ErrorActionPreference = 'Stop'

if (-not [System.IO.Path]::GetExtension($Name)) {
    $Name = $Name + '.exe'
}
$toolsdir   = 'c:\tools'
$usrscriptdir  = 'c:\script'

$programDirs = @($env:ProgramFiles, ${env:ProgramFiles(x86)}, $env:ProgramData,$toolsdir,$usrscriptdir )

$path = Get-ChildItem $programDirs -Recurse -Include $Name -ErrorAction SilentlyContinue |
    Select-Object -First 1 -ExpandProperty FullName

if (-not $path) {
    Write-Error "Unable to locate $Name in $programDirs"
    exit 1
}

$regPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\$Name"
if (Test-Path $regPath) {
    Set-ItemProperty $regPath -Name '(default)' -Value $path
}
else {
    New-Item $regPath | Out-Null
    New-ItemProperty $regPath -Name '(default)' -Value $path | Out-Null
}
