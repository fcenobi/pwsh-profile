# ---------------- #
# pwsh/windows.ps1 #
# ---------------- #

# Check to see if we are currently running "as Administrator"
if (!(Verify-Elevated)) {
  $newProcess = new-object System.Diagnostics.ProcessStartInfo "PowerShell";
  $newProcess.Arguments = $myInvocation.MyCommand.Definition;
  $newProcess.Verb = "runas";
  [System.Diagnostics.Process]::Start($newProcess);

  exit
}

###############################################################################
### Security and Identity                                                     #
###############################################################################

Write-Host "Configuring System..." -ForegroundColor "Yellow"

# Set Computer Name
(Get-WmiObject Win32_ComputerSystem).Rename("PATTOP") | Out-Null

## Set DisplayName for my account. Use only if you are not using a Microsoft Account
#$myIdentity=[System.Security.Principal.WindowsIdentity]::GetCurrent()
#$user = Get-WmiObject Win32_UserAccount | Where {$_.Caption -eq $myIdentity.Name}
#$user.FullName = "Patrick Evans"
#$user.Put() | Out-Null
#Remove-Variable user
#Remove-Variable myIdentity

# Enable Developer Mode
Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" "AllowDevelopmentWithoutDevLicense" 1
# Bash on Windows
Enable-WindowsOptionalFeature -Online -All -FeatureName "Microsoft-Windows-Subsystem-Linux" -NoRestart -WarningAction SilentlyContinue | Out-Null

###############################################################################
### Privacy                                                                   #
###############################################################################

#<#
Write-Host "Configuring Privacy..." -ForegroundColor "Yellow"

# General: Don't let apps use advertising ID for experiences across apps: Allow: 1, Disallow: 0
if (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo")) {New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" -Type Folder | Out-Null}
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" "Enabled" 0
Remove-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" "Id" -ErrorAction SilentlyContinue

# General: Disable Application launch tracking: Enable: 1, Disable: 0
Set-ItemProperty "HKCU:\\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "Start-TrackProgs" 0

# General: Disable SmartScreen Filter: Enable: 1, Disable: 0
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost" "EnableWebContentEvaluation" 0

# General: Disable key logging & transmission to Microsoft: Enable: 1, Disable: 0
# Disabled when Telemetry is set to Basic
if (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Input")) {New-Item -Path "HKCU:\SOFTWARE\Microsoft\Input" -Type Folder | Out-Null}
if (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Input\TIPC")) {New-Item -Path "HKCU:\SOFTWARE\Microsoft\Input\TIPC" -Type Folder | Out-Null}
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Input\TIPC" "Enabled" 0

# General: Opt-out from websites from accessing language list: Opt-in: 0, Opt-out 1
Set-ItemProperty "HKCU:\Control Panel\International\User Profile" "HttpAcceptLanguageOptOut" 1

# General: Disable SmartGlass: Enable: 1, Disable: 0
Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\SmartGlass" "UserAuthPolicy" 0

# General: Disable SmartGlass over BlueTooth: Enable: 1, Disable: 0
Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\SmartGlass" "BluetoothPolicy" 0

# General: Disable suggested content in settings app: Enable: 1, Disable: 0
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SubscribedContent-338393Enabled" 0
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SubscribedContent-338394Enabled" 0
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SubscribedContent-338396Enabled" 0

# Camera: Don't let apps use camera: Allow, Deny
# Build 1709
# Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{E5323777-F976-4f5b-9B55-B94699C46E44}" "Value" "Deny"
# Build 1903
#Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\webcam" "Value" "Deny"

# Microphone: Don't let apps use microphone: Allow, Deny
# Build 1709
#Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{2EEF81BE-33FA-4800-9670-1CD474972C3F}" "Value" "Deny"
# Build 1903
#Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\microphone" "Value" "Deny"

# Notifications: Don't let apps access notifications: Allow, Deny
# Build 1511
#Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{21157C1F-2651-4CC1-90CA-1F28B02263F6}" "Value" "Deny"
# Build 1607, 1709
#if (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{52079E78-A92B-413F-B213-E8FE35712E72}")) {New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{52079E78-A92B-413F-B213-E8FE35712E72}" -Type Folder | Out-Null}
#Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{52079E78-A92B-413F-B213-E8FE35712E72}" "Value" "Deny"
# Build 1903
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userNotificationListener" "Value" "Deny"

# Speech, Inking, & Typing: Stop "Getting to know me"
if (!(Test-Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization")) {New-Item -Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization" -Type Folder | Out-Null}
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\InputPersonalization" "RestrictImplicitTextCollection" 1
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\InputPersonalization" "RestrictImplicitInkCollection" 1
if (!(Test-Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore")) {New-Item -Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore" -Type Folder | Out-Null}
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore" "HarvestContacts" 0
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Personalization\Settings" "AcceptedPrivacyPolicy" 0
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Speech_OneCore\Settings\OnlineSpeechPrivacy" "HasAccepted" 0

# Account Info: Don't let apps access name, picture, and other account info: Allow, Deny
# Build 1709
#if (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{C1D23ACC-752B-43E5-8448-8D0E519CD6D6}")) {New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{C1D23ACC-752B-43E5-8448-8D0E519CD6D6}" -Type Folder | Out-Null}
#Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{C1D23ACC-752B-43E5-8448-8D0E519CD6D6}" "Value" "Deny"
# Build 1903
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userAccountInformation" "Value" "Deny"

# Contacts: Don't let apps access contacts: Allow, Deny
# Build 1709
#if (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{7D7E8402-7C54-4821-A34E-AEEFD62DED93}")) {New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{7D7E8402-7C54-4821-A34E-AEEFD62DED93}" -Type Folder | Out-Null}
#Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{7D7E8402-7C54-4821-A34E-AEEFD62DED93}" "Value" "Deny"
# Build 1903
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\contacts" "Value" "Deny"

# Calendar: Don't let apps access calendar: Allow, Deny
# Build 1709
#if (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{D89823BA-7180-4B81-B50C-7E471E6121A3}")) {New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{D89823BA-7180-4B81-B50C-7E471E6121A3}" -Type Folder | Out-Null}
#Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{D89823BA-7180-4B81-B50C-7E471E6121A3}" "Value" "Deny"
# Build 1903
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appointments" "Value" "Deny"

# Call History: Don't let apps make phone calls: Allow, Deny
# Build 1903
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\phoneCall" "Value" "Deny"

# Call History: Don't let apps access call history: Allow, Deny
# Build 1709
#if (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{8BC668CF-7728-45BD-93F8-CF2B3B41D7AB}")) {New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{8BC668CF-7728-45BD-93F8-CF2B3B41D7AB}" -Type Folder | Out-Null}
#Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{8BC668CF-7728-45BD-93F8-CF2B3B41D7AB}" "Value" "Deny"
# Build 1903
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\phoneCallHistory" "Value" "Deny"

# Diagnostics: Don't let apps access diagnostics of other apps: Allow, Deny
# Build 1903
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appDiagnostics" "Value" "Deny"

# Documents: Don't let apps access documents: Allow, Deny
# Build 1903
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\documentsLibrary" "Value" "Deny"

# Email: Don't let apps read and send email: Allow, Deny
# Build 1709
#if (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{9231CB4C-BF57-4AF3-8C55-FDA7BFCC04C5}")) {New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{9231CB4C-BF57-4AF3-8C55-FDA7BFCC04C5}" -Type Folder | Out-Null}
#Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{9231CB4C-BF57-4AF3-8C55-FDA7BFCC04C5}" "Value" "Deny"
# Build 1903
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\email" "Value" "Deny"

# File System: Don't let apps access the file system: Allow, Deny
# Build 1903
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\broadFileSystemAccess" "Value" "Deny"

# Location: Don't let apps access the location: Allow, Deny
# Build 1903
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" "Value" "Deny"

# Messaging: Don't let apps read or send messages (text or MMS): Allow, Deny
# Build 1709
#if (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{992AFA70-6F47-4148-B3E9-3003349C1548}")) {New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{992AFA70-6F47-4148-B3E9-3003349C1548}" -Type Folder | Out-Null}
#Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{992AFA70-6F47-4148-B3E9-3003349C1548}" "Value" "Deny"
# Build 1903
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\chat" "Value" "Deny"

# Pictures: Don't let apps access pictures: Allow, Deny
# Build 1903
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\picturesLibrary" "Value" "Deny"

# Radios: Don't let apps control radios (like Bluetooth): Allow, Deny
# Build 1709
#if (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{A8804298-2D5F-42E3-9531-9C8C39EB29CE}")) {New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{A8804298-2D5F-42E3-9531-9C8C39EB29CE}" -Type Folder | Out-Null}
#Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{A8804298-2D5F-42E3-9531-9C8C39EB29CE}" "Value" "Deny"
# Build 1903
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\radios" "Value" "Deny"

# Tasks: Don't let apps access the tasks: Allow, Deny
# Build 1903
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userDataTasks" "Value" "Deny"

# Other Devices: Don't let apps share and sync with non-explicitly-paired wireless devices over uPnP: Allow, Deny
# Build 1709
#if (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\LooselyCoupled")) {New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\LooselyCoupled" -Type Folder | Out-Null}
#Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\LooselyCoupled" "Value" "Deny"
# Build 1903
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\bluetoothSync" "Value" "Deny"

# Videos: Don't let apps access videos: Allow, Deny
# Build 1903
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\videosLibrary" "Value" "Deny"

# Feedback: Windows should never ask for my feedback
if (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Siuf")) {New-Item -Path "HKCU:\SOFTWARE\Microsoft\Siuf" -Type Folder | Out-Null}
if (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Siuf\Rules")) {New-Item -Path "HKCU:\SOFTWARE\Microsoft\Siuf\Rules" -Type Folder | Out-Null}
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Siuf\Rules" "NumberOfSIUFInPeriod" 0

# Feedback: Telemetry: Send Diagnostic and usage data: Basic: 1, Enhanced: 2, Full: 3
Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" "AllowTelemetry" 1

# Start Menu: Disable suggested content: Enable: 1, Disable: 0
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SubscribedContent-338388Enabled" 0
#>

###############################################################################
### Devices, Power, and Startup                                               #
###############################################################################

#<#
Write-Host "Configuring Devices, Power, and Startup..." -ForegroundColor "Yellow"

# Sound: Disable Startup Sound
Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" "DisableStartupSound" 1
Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI\BootAnimation" "DisableStartupSound" 1

# Power: Disable Hibernation
powercfg /hibernate off

# Power: Set standby delay to 24 hours
powercfg /change /standby-timeout-ac 1440

# SSD: Disable SuperFetch
Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" "EnableSuperfetch" 0

# Network: Disable WiFi Sense
Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\WcmSvc\wifinetworkmanager\config" "AutoConnectAllowedOEM" 0
#>

###############################################################################
### Explorer, Taskbar, and System Tray                                        #
###############################################################################

#<#
Write-Host "Configuring Explorer, Taskbar, and System Tray..." -ForegroundColor "Yellow"

# Ensure necessary registry paths
if (!(Test-Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer")) {New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Type Folder | Out-Null}
if (!(Test-Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\CabinetState")) {New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\CabinetState" -Type Folder | Out-Null}
if (!(Test-Path "HKLM:\Software\Policies\Microsoft\Windows\Windows Search")) {New-Item -Path "HKLM:\Software\Policies\Microsoft\Windows\Windows Search" -Type Folder | Out-Null}

# Explorer: Show hidden files by default: Show Files: 1, Hide Files: 2
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "Hidden" 1

# Explorer: Show file extensions by default
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "HideFileExt" 0

# Explorer: Show path in title bar
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\CabinetState" "FullPath" 1

# Explorer: Avoid creating Thumbs.db files on network volumes
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" "DisableThumbnailsOnNetworkFolders" 1

# Taskbar: Enable small icons
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "TaskbarSmallIcons" 1

# Taskbar: Don't show Windows Store Apps on Taskbar
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "StoreAppsOnTaskbar" 0

# Taskbar: Disable Bing Search
# Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\ConnectedSearch" "ConnectedSearchUseWeb" 0 # For Windows 8.1
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" "BingSearchEnabled" 0 # For Windows 10

# Taskbar: Disable Cortana
Set-ItemProperty "HKLM:\Software\Policies\Microsoft\Windows\Windows Search" "AllowCortana" 0

# SysTray: Hide the Action Center, Network, Clock, and Volume icons
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" 	"HideSCAHealth" 		1  	# Action Center
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" 	"HideSCANetwork" 		0 	# Network
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" 	"HideSCAVolume" 		0  	# Volume
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer"	"HideClock" 			0 	# Clock
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer"	"NoDriveTypeAutoRun"	145 # NoDriveTypeAutoRun
#Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" "HideSCAPower" 1  # Power
# Taskbar: Show colors on Taskbar, Start, and SysTray: Disabled: 0, Taskbar, Start, & SysTray: 1, Taskbar Only: 2
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" "ColorPrevalence" 1

# Titlebar: Disable theme colors on titlebar
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\DWM" "ColorPrevalence" 0

# Recycle Bin: Disable Delete Confirmation Dialog
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" "ConfirmFileDelete" 0

# Sync Settings: Disable automatically syncing settings with other Windows 10 devices
# Theme
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Personalization" "Enabled" 0
# Internet Explorer (Removed in 1903)
#Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\SettingSync\Groups\BrowserSettings" "Enabled" 0
# Passwords
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Credentials" "Enabled" 0
# Language
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Language" "Enabled" 0
# Accessibility / Ease of Access
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Accessibility" "Enabled" 0
# Other Windows Settings
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Windows" "Enabled" 0
#>

###############################################################################
### Default Windows Applications                                              #
###############################################################################

#
Write-Host "Configuring Default Windows Applications..." -ForegroundColor "Yellow"

# Uninstall 3D Builder
Get-AppxPackage "Microsoft.3DBuilder" -AllUsers | Remove-AppxPackage
Get-AppXProvisionedPackage -Online | Where DisplayNam -like "Microsoft.3DBuilder" | Remove-AppxProvisionedPackage -Online

# Uninstall Alarms and Clock
Get-AppxPackage "Microsoft.WindowsAlarms" -AllUsers | Remove-AppxPackage
Get-AppXProvisionedPackage -Online | Where DisplayNam -like "Microsoft.WindowsAlarms" | Remove-AppxProvisionedPackage -Online

# Uninstall Autodesk Sketchbook
Get-AppxPackage "*.AutodeskSketchBook" -AllUsers | Remove-AppxPackage
Get-AppXProvisionedPackage -Online | Where DisplayNam -like "*.AutodeskSketchBook" | Remove-AppxProvisionedPackage -Online

# Uninstall Bing Finance
Get-AppxPackage "Microsoft.BingFinance" -AllUsers | Remove-AppxPackage
Get-AppXProvisionedPackage -Online | Where DisplayNam -like "Microsoft.BingFinance" | Remove-AppxProvisionedPackage -Online

# Uninstall Bing News
Get-AppxPackage "Microsoft.BingNews" -AllUsers | Remove-AppxPackage
Get-AppXProvisionedPackage -Online | Where DisplayNam -like "Microsoft.BingNews" | Remove-AppxProvisionedPackage -Online

# Uninstall Bing Sports
Get-AppxPackage "Microsoft.BingSports" -AllUsers | Remove-AppxPackage
Get-AppXProvisionedPackage -Online | Where DisplayNam -like "Microsoft.BingSports" | Remove-AppxProvisionedPackage -Online

# Uninstall Bing Weather
Get-AppxPackage "Microsoft.BingWeather" -AllUsers | Remove-AppxPackage
Get-AppXProvisionedPackage -Online | Where DisplayNam -like "Microsoft.BingWeather" | Remove-AppxProvisionedPackage -Online

# Uninstall Bubble Witch 3 Saga
Get-AppxPackage "king.com.BubbleWitch3Saga" -AllUsers | Remove-AppxPackage
Get-AppXProvisionedPackage -Online | Where DisplayNam -like "king.com.BubbleWitch3Saga" | Remove-AppxProvisionedPackage -Online

# Uninstall Calendar and Mail
Get-AppxPackage "Microsoft.WindowsCommunicationsApps" -AllUsers | Remove-AppxPackage
Get-AppXProvisionedPackage -Online | Where DisplayNam -like "Microsoft.WindowsCommunicationsApps" | Remove-AppxProvisionedPackage -Online

# Uninstall Candy Crush Soda Saga
Get-AppxPackage "king.com.CandyCrushSodaSaga" -AllUsers | Remove-AppxPackage
Get-AppXProvisionedPackage -Online | Where DisplayNam -like "king.com.CandyCrushSodaSaga" | Remove-AppxProvisionedPackage -Online

# Uninstall Disney Magic Kingdoms
Get-AppxPackage "*.DisneyMagicKingdoms" -AllUsers | Remove-AppxPackage
Get-AppXProvisionedPackage -Online | Where DisplayNam -like "*.DisneyMagicKingdoms" | Remove-AppxProvisionedPackage -Online

# Uninstall Dolby
Get-AppxPackage "DolbyLaboratories.DolbyAccess" -AllUsers | Remove-AppxPackage
Get-AppXProvisionedPackage -Online | Where DisplayNam -like "DolbyLaboratories.DolbyAccess" | Remove-AppxProvisionedPackage -Online

# Uninstall Facebook
Get-AppxPackage "*.Facebook" -AllUsers | Remove-AppxPackage
Get-AppXProvisionedPackage -Online | Where DisplayNam -like "*.Facebook" | Remove-AppxProvisionedPackage -Online

# Uninstall Get Office, and it's "Get Office365" notifications
Get-AppxPackage "Microsoft.MicrosoftOfficeHub" -AllUsers | Remove-AppxPackage
Get-AppXProvisionedPackage -Online | Where DisplayNam -like "Microsoft.MicrosoftOfficeHub" | Remove-AppxProvisionedPackage -Online

# Uninstall Get Started
Get-AppxPackage "Microsoft.GetStarted" -AllUsers | Remove-AppxPackage
Get-AppXProvisionedPackage -Online | Where DisplayNam -like "Microsoft.GetStarted" | Remove-AppxProvisionedPackage -Online

# Uninstall Maps
Get-AppxPackage "Microsoft.WindowsMaps" -AllUsers | Remove-AppxPackage
Get-AppXProvisionedPackage -Online | Where DisplayNam -like "Microsoft.WindowsMaps" | Remove-AppxProvisionedPackage -Online

# Uninstall March of Empires
Get-AppxPackage "*.MarchofEmpires" -AllUsers | Remove-AppxPackage
Get-AppXProvisionedPackage -Online | Where DisplayNam -like "*.MarchofEmpires" | Remove-AppxProvisionedPackage -Online

# Uninstall Messaging
Get-AppxPackage "Microsoft.Messaging" -AllUsers | Remove-AppxPackage
Get-AppXProvisionedPackage -Online | Where DisplayNam -like "Microsoft.Messaging" | Remove-AppxProvisionedPackage -Online

# Uninstall Mobile Plans
Get-AppxPackage "Microsoft.OneConnect" -AllUsers | Remove-AppxPackage
Get-AppXProvisionedPackage -Online | Where DisplayNam -like "Microsoft.OneConnect" | Remove-AppxProvisionedPackage -Online

# Uninstall OneNote
Get-AppxPackage "Microsoft.Office.OneNote" -AllUsers | Remove-AppxPackage
Get-AppXProvisionedPackage -Online | Where DisplayNam -like "Microsoft.Office.OneNote" | Remove-AppxProvisionedPackage -Online

# Uninstall Paint
Get-AppxPackage "Microsoft.MSPaint" -AllUsers | Remove-AppxPackage
Get-AppXProvisionedPackage -Online | Where DisplayNam -like "Microsoft.MSPaint" | Remove-AppxProvisionedPackage -Online

# Uninstall People
Get-AppxPackage "Microsoft.People" -AllUsers | Remove-AppxPackage
Get-AppXProvisionedPackage -Online | Where DisplayNam -like "Microsoft.People" | Remove-AppxProvisionedPackage -Online

# Uninstall Photos
Get-AppxPackage "Microsoft.Windows.Photos" -AllUsers | Remove-AppxPackage
Get-AppXProvisionedPackage -Online | Where DisplayNam -like "Microsoft.Windows.Photos" | Remove-AppxProvisionedPackage -Online

# Uninstall Print3D
Get-AppxPackage "Microsoft.Print3D" -AllUsers | Remove-AppxPackage
Get-AppXProvisionedPackage -Online | Where DisplayNam -like "Microsoft.Print3D" | Remove-AppxProvisionedPackage -Online

# Uninstall Skype
Get-AppxPackage "Microsoft.SkypeApp" -AllUsers | Remove-AppxPackage
Get-AppXProvisionedPackage -Online | Where DisplayNam -like "Microsoft.SkypeApp" | Remove-AppxProvisionedPackage -Online

# Uninstall SlingTV
Get-AppxPackage "*.SlingTV" -AllUsers | Remove-AppxPackage
Get-AppXProvisionedPackage -Online | Where DisplayNam -like "*.SlingTV" | Remove-AppxProvisionedPackage -Online

# Uninstall Solitaire
Get-AppxPackage "Microsoft.MicrosoftSolitaireCollection" -AllUsers | Remove-AppxPackage
Get-AppXProvisionedPackage -Online | Where DisplayNam -like "Microsoft.MicrosoftSolitaireCollection" | Remove-AppxProvisionedPackage -Online

# Uninstall Spotify
Get-AppxPackage "SpotifyAB.SpotifyMusic" -AllUsers | Remove-AppxPackage
Get-AppXProvisionedPackage -Online | Where DisplayNam -like "SpotifyAB.SpotifyMusic" | Remove-AppxProvisionedPackage -Online

# Uninstall StickyNotes
#Get-AppxPackage "Microsoft.MicrosoftStickyNotes" -AllUsers | Remove-AppxPackage
#Get-AppXProvisionedPackage -Online | Where DisplayNam -like "Microsoft.MicrosoftStickyNotes" | Remove-AppxProvisionedPackage -Online

# Uninstall Sway
Get-AppxPackage "Microsoft.Office.Sway" -AllUsers | Remove-AppxPackage
Get-AppXProvisionedPackage -Online | Where DisplayNam -like "Microsoft.Office.Sway" | Remove-AppxProvisionedPackage -Online

# Uninstall Twitter
Get-AppxPackage "*.Twitter" -AllUsers | Remove-AppxPackage
Get-AppXProvisionedPackage -Online | Where DisplayNam -like "*.Twitter" | Remove-AppxProvisionedPackage -Online

# Uninstall Voice Recorder
Get-AppxPackage "Microsoft.WindowsSoundRecorder" -AllUsers | Remove-AppxPackage
Get-AppXProvisionedPackage -Online | Where DisplayNam -like "Microsoft.WindowsSoundRecorder" | Remove-AppxProvisionedPackage -Online

# Uninstall Windows Phone Companion
Get-AppxPackage "Microsoft.WindowsPhone" -AllUsers | Remove-AppxPackage
Get-AppXProvisionedPackage -Online | Where DisplayNam -like "Microsoft.WindowsPhone" | Remove-AppxProvisionedPackage -Online

# Uninstall XBox
Get-AppxPackage "Microsoft.XboxApp" -AllUsers | Remove-AppxPackage
Get-AppXProvisionedPackage -Online | Where DisplayNam -like "Microsoft.XboxApp" | Remove-AppxProvisionedPackage -Online

# Uninstall Zune Music (Groove)
Get-AppxPackage "Microsoft.ZuneMusic" -AllUsers | Remove-AppxPackage
Get-AppXProvisionedPackage -Online | Where DisplayNam -like "Microsoft.ZuneMusic" | Remove-AppxProvisionedPackage -Online

# Uninstall Zune Video
Get-AppxPackage "Microsoft.ZuneVideo" -AllUsers | Remove-AppxPackage
Get-AppXProvisionedPackage -Online | Where DisplayNam -like "Microsoft.ZuneVideo" | Remove-AppxProvisionedPackage -Online

# Uninstall Windows Media Player
Disable-WindowsOptionalFeature -Online -FeatureName "WindowsMediaPlayer" -NoRestart -WarningAction SilentlyContinue | Out-Null

# Prevent "Suggested Applications" from returning
if (!(Test-Path "HKLM:\Software\Policies\Microsoft\Windows\CloudContent")) {New-Item -Path "HKLM:\Software\Policies\Microsoft\Windows\CloudContent" -Type Folder | Out-Null}
Set-ItemProperty "HKLM:\Software\Policies\Microsoft\Windows\CloudContent" "DisableWindowsConsumerFeatures" 1
#>

###############################################################################
### Lock Screen                                                               #
###############################################################################

## Enable Custom Background on the Login / Lock Screen
## Background file: C:\someDirectory\someImage.jpg
## File Size Limit: 256Kb
# Set-ItemProperty "HKLM:\Software\Policies\Microsoft\Windows\Personalization" "LockScreenImage" "C:\someDirectory\someImage.jpg"

###############################################################################
### Accessibility and Ease of Use                                             #
###############################################################################

<#
Write-Host "Configuring Accessibility..." -ForegroundColor "Yellow"

# Turn Off Windows Narrator
if (!(Test-Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\Narrator.exe")) {New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\Narrator.exe" -Type Folder | Out-Null}
Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\Narrator.exe" "Debugger" "%1"

# Disable "Window Snap" Automatic Window Arrangement
Set-ItemProperty "HKCU:\Control Panel\Desktop" "WindowArrangementActive" 0

# Disable automatic fill to space on Window Snap
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "SnapFill" 0

# Disable showing what can be snapped next to a window
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "SnapAssist" 0

# Disable automatic resize of adjacent windows on snap
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "JointResize" 0

# Disable auto-correct
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\TabletTip\1.7" "EnableAutocorrection" 0
#>

###############################################################################
### Windows Update & Application Updates                                      #
###############################################################################

<#
Write-Host "Configuring Windows Update..." -ForegroundColor "Yellow"

# Ensure Windows Update registry paths
if (!(Test-Path "HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate")) {New-Item -Path "HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate" -Type Folder | Out-Null}
if (!(Test-Path "HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU")) {New-Item -Path "HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" -Type Folder | Out-Null}

# Enable Automatic Updates
Set-ItemProperty "HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" "NoAutoUpdate" 0

# Disable automatic reboot after install
Set-ItemProperty "HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate" "NoAutoRebootWithLoggedOnUsers" 1
Set-ItemProperty "HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" "NoAutoRebootWithLoggedOnUsers" 1

# Configure to Auto-Download but not Install: NotConfigured: 0, Disabled: 1, NotifyBeforeDownload: 2, NotifyBeforeInstall: 3, ScheduledInstall: 4
Set-ItemProperty "HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" "AUOptions" 3

# Include Recommended Updates
Set-ItemProperty "HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" "IncludeRecommendedUpdates" 1

# Opt-In to Microsoft Update
$MU = New-Object -ComObject Microsoft.Update.ServiceManager -Strict
$MU.AddService2("7971f918-a847-4430-9279-4a52d1efe18d",7,"") | Out-Null
Remove-Variable MU

# Delivery Optimization: Download from 0: Http Only [Disable], 1: Peering on LAN, 2: Peering on AD / Domain, 3: Peering on Internet, 99: No peering, 100: Bypass & use BITS
#Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" "DODownloadMode" 0
if (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization")) {New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization" -Type Folder | Out-Null}
if (!(Test-Path "HKLM:\SOFTWARE\WOW6432Node\Policies\Microsoft\Windows\DeliveryOptimization")) {New-Item -Path "HKLM:\SOFTWARE\WOW6432Node\Policies\Microsoft\Windows\DeliveryOptimization" -Type Folder | Out-Null}
Set-ItemProperty "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization" "DODownloadMode" 0
Set-ItemProperty "HKLM:\SOFTWARE\WOW6432Node\Policies\Microsoft\Windows\DeliveryOptimization" "DODownloadMode" 0
#>

###############################################################################
### Windows Defender                                                          #
###############################################################################

#<#
Write-Host "Configuring Windows Defender..." -ForegroundColor "Yellow"

# Disable Cloud-Based Protection: Enabled Advanced: 2, Enabled Basic: 1, Disabled: 0
Set-MpPreference -MAPSReporting 0

# Disable automatic sample submission: Prompt: 0, Auto Send Safe: 1, Never: 2, Auto Send All: 3
Set-MpPreference -SubmitSamplesConsent 2
#>

###############################################################################
### Internet Explorer                                                         #
###############################################################################

<#
Write-Host "Configuring Internet Explorer..." -ForegroundColor "Yellow"

# Set home page to `about:blank` for faster loading
Set-ItemProperty "HKCU:\Software\Microsoft\Internet Explorer\Main" "Start Page" "about:blank"

# Disable 'Default Browser' check: "yes" or "no"
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Internet Explorer\Main" "Check_Associations" "no"

# Disable Password Caching [Disable Remember Password]
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings" "DisablePasswordCaching" 1
#>

###############################################################################
### Disk Cleanup (CleanMgr.exe)                                               #
###############################################################################

#<#
Write-Host "Configuring Disk Cleanup..." -ForegroundColor "Yellow"

$diskCleanupRegPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\"

# Cleanup Files by Group: 0=Disabled, 2=Enabled
Set-ItemProperty $(Join-Path $diskCleanupRegPath "BranchCache"                                  ) "StateFlags6174" 0   -ErrorAction SilentlyContinue
Set-ItemProperty $(Join-Path $diskCleanupRegPath "Downloaded Program Files"                     ) "StateFlags6174" 2   -ErrorAction SilentlyContinue
Set-ItemProperty $(Join-Path $diskCleanupRegPath "Internet Cache Files"                         ) "StateFlags6174" 2   -ErrorAction SilentlyContinue
Set-ItemProperty $(Join-Path $diskCleanupRegPath "Offline Pages Files"                          ) "StateFlags6174" 0   -ErrorAction SilentlyContinue
Set-ItemProperty $(Join-Path $diskCleanupRegPath "Old ChkDsk Files"                             ) "StateFlags6174" 2   -ErrorAction SilentlyContinue
Set-ItemProperty $(Join-Path $diskCleanupRegPath "Previous Installations"                       ) "StateFlags6174" 0   -ErrorAction SilentlyContinue
Set-ItemProperty $(Join-Path $diskCleanupRegPath "Recycle Bin"                                  ) "StateFlags6174" 0   -ErrorAction SilentlyContinue
Set-ItemProperty $(Join-Path $diskCleanupRegPath "RetailDemo Offline Content"                   ) "StateFlags6174" 2   -ErrorAction SilentlyContinue
Set-ItemProperty $(Join-Path $diskCleanupRegPath "Service Pack Cleanup"                         ) "StateFlags6174" 0   -ErrorAction SilentlyContinue
Set-ItemProperty $(Join-Path $diskCleanupRegPath "Setup Log Files"                              ) "StateFlags6174" 2   -ErrorAction SilentlyContinue
Set-ItemProperty $(Join-Path $diskCleanupRegPath "System error memory dump files"               ) "StateFlags6174" 0   -ErrorAction SilentlyContinue
Set-ItemProperty $(Join-Path $diskCleanupRegPath "System error minidump files"                  ) "StateFlags6174" 0   -ErrorAction SilentlyContinue
Set-ItemProperty $(Join-Path $diskCleanupRegPath "Temporary Files"                              ) "StateFlags6174" 2   -ErrorAction SilentlyContinue
Set-ItemProperty $(Join-Path $diskCleanupRegPath "Temporary Setup Files"                        ) "StateFlags6174" 2   -ErrorAction SilentlyContinue
Set-ItemProperty $(Join-Path $diskCleanupRegPath "Thumbnail Cache"                              ) "StateFlags6174" 2   -ErrorAction SilentlyContinue
Set-ItemProperty $(Join-Path $diskCleanupRegPath "Update Cleanup"                               ) "StateFlags6174" 2   -ErrorAction SilentlyContinue
Set-ItemProperty $(Join-Path $diskCleanupRegPath "Upgrade Discarded Files"                      ) "StateFlags6174" 0   -ErrorAction SilentlyContinue
Set-ItemProperty $(Join-Path $diskCleanupRegPath "User file versions"                           ) "StateFlags6174" 0   -ErrorAction SilentlyContinue
Set-ItemProperty $(Join-Path $diskCleanupRegPath "Windows Defender"                             ) "StateFlags6174" 2   -ErrorAction SilentlyContinue
Set-ItemProperty $(Join-Path $diskCleanupRegPath "Windows Error Reporting Archive Files"        ) "StateFlags6174" 0   -ErrorAction SilentlyContinue
Set-ItemProperty $(Join-Path $diskCleanupRegPath "Windows Error Reporting Queue Files"          ) "StateFlags6174" 0   -ErrorAction SilentlyContinue
Set-ItemProperty $(Join-Path $diskCleanupRegPath "Windows Error Reporting System Archive Files" ) "StateFlags6174" 0   -ErrorAction SilentlyContinue
Set-ItemProperty $(Join-Path $diskCleanupRegPath "Windows Error Reporting System Queue Files"   ) "StateFlags6174" 0   -ErrorAction SilentlyContinue
Set-ItemProperty $(Join-Path $diskCleanupRegPath "Windows Error Reporting Temp Files"           ) "StateFlags6174" 0   -ErrorAction SilentlyContinue
Set-ItemProperty $(Join-Path $diskCleanupRegPath "Windows ESD installation files"               ) "StateFlags6174" 0   -ErrorAction SilentlyContinue
Set-ItemProperty $(Join-Path $diskCleanupRegPath "Windows Upgrade Log Files"                    ) "StateFlags6174" 0   -ErrorAction SilentlyContinue

Remove-Variable diskCleanupRegPath
#>

###############################################################################
### PowerShell Console                                                        #
###############################################################################

Write-Host "Configuring Console..." -ForegroundColor "Yellow"

# Make 'Source Code Pro' an available Console font
# Set-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Console\TrueTypeFont' 000 'Source Code Pro'
# Make 'Hack NF' an available Console font
Set-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Console\TrueTypeFont' 000 'Hack NF'


@(`
"HKCU:\Console\%SystemRoot%_System32_bash.exe",`
"HKCU:\Console\%SystemRoot%_System32_WindowsPowerShell_v1.0_powershell.exe",`
"HKCU:\Console\%SystemRoot%_SysWOW64_WindowsPowerShell_v1.0_powershell.exe",`
"HKCU:\Console\Windows PowerShell (x86)",`
"HKCU:\Console\Windows PowerShell",`
"HKCU:\Console"`
) | ForEach-Object {
  If (!(Test-Path $_)) {
    New-Item -path $_ -ItemType Folder | Out-Null
  }

  # Name of display font
  Set-ItemProperty $_ "FaceName"             "Hack NF"

}

#<#
# Dimensions of window, in characters: 8-byte; 4b height, 4b width. Max: 0x7FFF7FFF (32767h x 32767w)
Set-ItemProperty $_ "WindowSize"           0x002D0078 # 45h x 120w
# Dimensions of screen buffer in memory, in characters: 8-byte; 4b height, 4b width. Max: 0x7FFF7FFF (32767h x 32767w)
Set-ItemProperty $_ "ScreenBufferSize"     0x0BB80078 # 3000h x 120w
# Percentage of Character Space for Cursor: 25: Small, 50: Medium, 100: Large
Set-ItemProperty $_ "CursorSize"           100
# Name of display font
Set-ItemProperty $_ "FaceName"             "Source Code Pro"
# Font Family: Raster: 0, TrueType: 54
Set-ItemProperty $_ "FontFamily"           54
# Dimensions of font character in pixels, not Points: 8-byte; 4b height, 4b width. 0: Auto
Set-ItemProperty $_ "FontSize"             0x00110000 # 17px height x auto width
# Boldness of font: Raster=(Normal: 0, Bold: 1), TrueType=(100-900, Normal: 400)
Set-ItemProperty $_ "FontWeight"           400
# Number of commands in history buffer
Set-ItemProperty $_ "HistoryBufferSize"    999
# Discard duplicate commands
Set-ItemProperty $_ "HistoryNoDup"         1
# Typing Mode: Overtype: 0, Insert: 1
Set-ItemProperty $_ "InsertMode"           1
# Enable Copy/Paste using Mouse
Set-ItemProperty $_ "QuickEdit"            1
# Background and Foreground Colors for Window: 2-byte; 1b background, 1b foreground; Color: 0-F
Set-ItemProperty $_ "ScreenColors"         0x0F
# Background and Foreground Colors for Popup Window: 2-byte; 1b background, 1b foreground; Color: 0-F
Set-ItemProperty $_ "PopupColors"          0xF0
# Adjust opacity between 30% and 100%: 0x4C to 0xFF -or- 76 to 255
Set-ItemProperty $_ "WindowAlpha"          0xF2

# The 16 colors in the Console color well (Persisted values are in BGR).
# Theme: Jellybeans
Set-ItemProperty $_ "ColorTable00"         $(Convert-ConsoleColor "#151515") # Black (0)
Set-ItemProperty $_ "ColorTable01"         $(Convert-ConsoleColor "#8197bf") # DarkBlue (1)
Set-ItemProperty $_ "ColorTable02"         $(Convert-ConsoleColor "#437019") # DarkGreen (2)
Set-ItemProperty $_ "ColorTable03"         $(Convert-ConsoleColor "#556779") # DarkCyan (3)
Set-ItemProperty $_ "ColorTable04"         $(Convert-ConsoleColor "#902020") # DarkRed (4)
Set-ItemProperty $_ "ColorTable05"         $(Convert-ConsoleColor "#540063") # DarkMagenta (5)
Set-ItemProperty $_ "ColorTable06"         $(Convert-ConsoleColor "#dad085") # DarkYellow (6)
Set-ItemProperty $_ "ColorTable07"         $(Convert-ConsoleColor "#888888") # Gray (7)
Set-ItemProperty $_ "ColorTable08"         $(Convert-ConsoleColor "#606060") # DarkGray (8)
Set-ItemProperty $_ "ColorTable09"         $(Convert-ConsoleColor "#7697d6") # Blue (9)
Set-ItemProperty $_ "ColorTable10"         $(Convert-ConsoleColor "#99ad6a") # Green (A)
Set-ItemProperty $_ "ColorTable11"         $(Convert-ConsoleColor "#c6b6ee") # Cyan (B)
Set-ItemProperty $_ "ColorTable12"         $(Convert-ConsoleColor "#cf6a4c") # Red (C)
Set-ItemProperty $_ "ColorTable13"         $(Convert-ConsoleColor "#f0a0c0") # Magenta (D)
Set-ItemProperty $_ "ColorTable14"         $(Convert-ConsoleColor "#fad07a") # Yellow (E)
Set-ItemProperty $_ "ColorTable15"         $(Convert-ConsoleColor "#e8e8d3") # White (F)
#}

# Customizing PoSh syntax
# Theme: Jellybeans
Set-PSReadlineOption -Colors @{
    "Default"   = "#e8e8d3"
    "Comment"   = "#888888"
    "Keyword"   = "#8197bf"
    "String"    = "#99ad6a"
    "Operator"  = "#c6b6ee"
    "Variable"  = "#c6b6ee"
    "Command"   = "#8197bf"
    "Parameter" = "#e8e8d3"
    "Type"      = "#fad07a"
    "Number"    = "#cf6a4c"
    "Member"    = "#fad07a"
    "Emphasis"  = "#f0a0c0"
    "Error"     = "#902020"
}
#>

# Remove property overrides from PowerShell and Bash shortcuts
# Reset-AllPowerShellShortcuts
# Reset-AllBashShortcuts

# echo "Done. Note that some of these changes require a logout/restart to take effect."
Write-Output "Done. Note that some of these changes require a logout/restart to take effect."

# EOF #

# SIG # Begin signature block
# MIIUZgYJKoZIhvcNAQcCoIIUVzCCFFMCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCAu5xNtWe2e/QlH
# S7A1q2OuNVEwLtaJVMxrPPY9DLDv0qCCD1MwggMuMIICFqADAgECAhBN/MLpeivG
# gk7YFhWTpn1NMA0GCSqGSIb3DQEBDQUAMB8xHTAbBgNVBAMMFFdpbmRvd3MgQWRt
# aW4gQ2VudGVyMB4XDTIwMDgxOTIzMzgxN1oXDTMwMDgxOTIzMzgxN1owHzEdMBsG
# A1UEAwwUV2luZG93cyBBZG1pbiBDZW50ZXIwggEiMA0GCSqGSIb3DQEBAQUAA4IB
# DwAwggEKAoIBAQDbaUTAmKYrZoQ4KlGHDLP0l8KBeBsNKo+wnTGifjk6Pmf3hi4m
# XiYX3H4BR39Tvwm4A2AcriUgN2Jq0XjcqcjpEaRZOtjWy6PAFYZ4QyfFifAUtfs8
# T/sId6JHys2s8oNatJVwIpGIviaqpyFpes8RHbHsxg4Yyd9WwV0FEm6DLCPHW9fM
# NeF+Ye9PRuKzSMBQSFCGv9sk7jF1XBmb64ZV6dzuLUyC871MqqoODDBahatsnJ9E
# +4GR5JEtdUw69MZQ5gyYzlVZ/n83IBSgqYFurb1rbVV18v3//7gXxxbdsaaddLzA
# icP3TmlfCAMLKMegpnb+0ylQEIQWuROn/8j5AgMBAAGjZjBkMA4GA1UdDwEB/wQE
# AwICtDATBgNVHSUEDDAKBggrBgEFBQcDATAeBgNVHREEFzAVggh3MTAtNTAwboIJ
# bG9jYWxob3N0MB0GA1UdDgQWBBSMd1qShkCXOs8OwJpf+bEiLrk32jANBgkqhkiG
# 9w0BAQ0FAAOCAQEAbDHoo4Zc+yBq79lG+eO2O+N9MpwIkPw1RZxoI6dgot7kaR+9
# A9ZQom2d7jXHnuNYj+M4A3Yk12Ps4/hoLUUAF3PSQOr0Tli2QXXkryc0mqDUBfms
# XdN2xop09u8uQKOcAZwm1t+pcyKgOZtkUc+92xwL9jS7dTYwbKDXAmrfbHXtqqdj
# qtPBUOOhhjhco7hU0BWpt0G9b4fxjsifIonk+aDOOYZGNQGVA6lCZ+T7Zqsm7Gl7
# KzPuyKeiGcaQkarSwkCCnZ9UtYxMEFv0dePpoxHKasjghD38rEegbhrQjPwDXhm1
# yjPBo/mGVYnZj9LwlWSqSRUwpwQufFhjSy1lADCCAzowggIioAMCAQICEGScKRIp
# 1L66RgurHfOyi3cwDQYJKoZIhvcNAQENBQAwHzEdMBsGA1UEAwwUV2luZG93cyBB
# ZG1pbiBDZW50ZXIwHhcNMjAwODE5MjMzODIyWhcNMzAwODE5MjMzODIyWjAqMSgw
# JgYDVQQDDB9XaW5kb3dzIEFkbWluIENlbnRlciBFbmNyeXB0aW9uMIIBIjANBgkq
# hkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAnA1SqLJv2oaIzFGZqDuZtEeIbsKGA/+p
# BTsXzRmqNmTYql6q8nKwM+lDSpgshcyHKlSQB+cxB3oFR+f7dOBNR0BF0E1NtUYw
# W3uXmhOQAW6GERnBxUofEbA2pNyHZrK3sCqaDHlFYaekRPzrbp9wTIrhaxK0Ygdq
# qakMLZ+vDYpiO7lHNgCpnxbBnyJuRMvQfQMmjdBZKXXyyr9/SqkGtVRh2PgBeaJ+
# ZgkZyIQCEs24Pu30YiQBntp8JEjdbekrIJ4OH1l7iE+q9ur29m/9PLzob1uS9csS
# KcJZ//OsxyEbyeHQXNRm3dnoKGNAtQstpeYIk2jdzUPz2O5hhG/eiQIDAQABo2cw
# ZTAOBgNVHQ8BAf8EBAMCBJAwEwYDVR0lBAwwCgYIKwYBBQUHAwMwHwYDVR0jBBgw
# FoAUjHdakoZAlzrPDsCaX/mxIi65N9owHQYDVR0OBBYEFPa7Sv5t0pQfqjOhX5qI
# hBz3OGiWMA0GCSqGSIb3DQEBDQUAA4IBAQBW1vNmXC1kPJzm0p2XYe36WX/3hOmt
# ZX2SiYBpa6proqFoNrP523Gl0ZCeqwf9vlKFRpZVx2eW8AAdJRAw47zZ5LGgq5xf
# aG4u7Eug0kE2S2CvJY8776prZ2GnLcXQPP4vmwr1X/b/XADdevJWI6DRlGNZ2XUn
# ZmC3xAVbeSzc66W9ZJWuU9Xf7sSrtefmdV9n/ilokehELIiiKPTCr8FMsHEBHMw1
# EkFc4n/jl4vK2ORvsKJ01jViJxp3yU2OQdhuQWzUcia5ndHIMAdvno6Yk7f+vy8j
# Z0EAL4/kZ76HxrGgbHSh32hk9gl/L3VFZyA8OlYzsJvHBMhePZt4/0nRMIIEFTCC
# Av2gAwIBAgILBAAAAAABMYnGUAQwDQYJKoZIhvcNAQELBQAwTDEgMB4GA1UECxMX
# R2xvYmFsU2lnbiBSb290IENBIC0gUjMxEzARBgNVBAoTCkdsb2JhbFNpZ24xEzAR
# BgNVBAMTCkdsb2JhbFNpZ24wHhcNMTEwODAyMTAwMDAwWhcNMjkwMzI5MTAwMDAw
# WjBbMQswCQYDVQQGEwJCRTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTExMC8G
# A1UEAxMoR2xvYmFsU2lnbiBUaW1lc3RhbXBpbmcgQ0EgLSBTSEEyNTYgLSBHMjCC
# ASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAKqbjsOrEVElAbaWlOJP2MEI
# 9kYj2UXFlZdbqxq/0mxXyTMGH6APxjx+U0h6v52Hnq/uw4xH4ULs4+OhSmwMF8Sm
# wbnNW/EeRImO/gveIVgT7k3IxWcLHLKz8TR2kaLLB203xaBHJgIVpJCRqXme1+tX
# nSt8ItgU1/EHHngiNmt3ea+v+X+OTuG1CDH96u1LcWKMI/EDOY9EebZ2A1eerS8I
# RtzSjLz0jnTOyGhpUXYRiw9dJFsZVD0mzECNgicbWSB9WfaTgI74Kjj9a6BAZR9X
# dsxbjgRPLKjbhFATT8bci7n43WlMiOucezAm/HpYu1m8FHKSgVe3dsnYgAqAbgkC
# AwEAAaOB6DCB5TAOBgNVHQ8BAf8EBAMCAQYwEgYDVR0TAQH/BAgwBgEB/wIBADAd
# BgNVHQ4EFgQUkiGnSpVdZLCbtB7mADdH5p1BK0wwRwYDVR0gBEAwPjA8BgRVHSAA
# MDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2JhbHNpZ24uY29tL3JlcG9z
# aXRvcnkvMDYGA1UdHwQvMC0wK6ApoCeGJWh0dHA6Ly9jcmwuZ2xvYmFsc2lnbi5u
# ZXQvcm9vdC1yMy5jcmwwHwYDVR0jBBgwFoAUj/BLf6guRSSuTVD6Y5qL3uLdG7ww
# DQYJKoZIhvcNAQELBQADggEBAARWgkp80M7JvzZm0b41npNsl+gGzjEYWflsQV+A
# LsBCJbgYx/zUsTfEaKDPKGoDdEtjl4V3YTvXL+P1vTOikn0RH56KbO8ssPRijTZz
# 0RY28bxe7LSAmHj80nZ56OEhlOAfxKLhqmfbs5xz5UAizznO2+Z3lae7ssv2GYad
# n8jUmAWycW9Oda7xPWRqO15ORqYqXQiS8aPzHXS/Yg0jjFwqOJXSwNXNz4jaHyi1
# uoFpZCq1pqLVc6/cRtsErpHXbsWYutRHxFZ0gEd4WIy+7yv97Gy/0ZT3v1Dge+CQ
# /SAYeBgiXQgujBygl/MdmX2jnZHTBkROBG56HCDjNvC2ULkwggTGMIIDrqADAgEC
# AgwkVLh/HhRTrTf6oXgwDQYJKoZIhvcNAQELBQAwWzELMAkGA1UEBhMCQkUxGTAX
# BgNVBAoTEEdsb2JhbFNpZ24gbnYtc2ExMTAvBgNVBAMTKEdsb2JhbFNpZ24gVGlt
# ZXN0YW1waW5nIENBIC0gU0hBMjU2IC0gRzIwHhcNMTgwMjE5MDAwMDAwWhcNMjkw
# MzE4MTAwMDAwWjA7MTkwNwYDVQQDDDBHbG9iYWxTaWduIFRTQSBmb3IgTVMgQXV0
# aGVudGljb2RlIGFkdmFuY2VkIC0gRzIwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAw
# ggEKAoIBAQDZeGGhlq4S/6P/J/ZEYHtqVi1n41+fMZIqSO35BYQObU4iVsrYmZeO
# acqfew8IyCoraNEoYSuf5Cbuurj3sOxeahviWLW0vR0J7c3oPdRm/74iIm02Js8R
# eJfpVQAow+k3Tr0Z5ReESLIcIa3sc9LzqKfpX+g1zoUTpyKbrILp/vFfxBJasfcM
# QObSoOBNaNDtDAwQHY8FX2RV+bsoRwYM2AY/N8MmNiWMew8niFw4MaUB9l5k3oPA
# FFzg59JezI3qI4AZKrNiLmDHqmfWs0DuUn9WDO/ZBdeVIF2FFUDPXpGVUZ5GGheR
# vsHAB3WyS/c2usVUbF+KG/sNKGHIifAVAgMBAAGjggGoMIIBpDAOBgNVHQ8BAf8E
# BAMCB4AwTAYDVR0gBEUwQzBBBgkrBgEEAaAyAR4wNDAyBggrBgEFBQcCARYmaHR0
# cHM6Ly93d3cuZ2xvYmFsc2lnbi5jb20vcmVwb3NpdG9yeS8wCQYDVR0TBAIwADAW
# BgNVHSUBAf8EDDAKBggrBgEFBQcDCDBGBgNVHR8EPzA9MDugOaA3hjVodHRwOi8v
# Y3JsLmdsb2JhbHNpZ24uY29tL2dzL2dzdGltZXN0YW1waW5nc2hhMmcyLmNybDCB
# mAYIKwYBBQUHAQEEgYswgYgwSAYIKwYBBQUHMAKGPGh0dHA6Ly9zZWN1cmUuZ2xv
# YmFsc2lnbi5jb20vY2FjZXJ0L2dzdGltZXN0YW1waW5nc2hhMmcyLmNydDA8Bggr
# BgEFBQcwAYYwaHR0cDovL29jc3AyLmdsb2JhbHNpZ24uY29tL2dzdGltZXN0YW1w
# aW5nc2hhMmcyMB0GA1UdDgQWBBTUh7iN5uVAPJ1aBmPGRYTZ3bscwzAfBgNVHSME
# GDAWgBSSIadKlV1ksJu0HuYAN0fmnUErTDANBgkqhkiG9w0BAQsFAAOCAQEAJHJQ
# pQy8QAmmwfTVgmpOQV/Ox4g50+R8+SJsOHi49Lr3a+Ek6518zUisi+y1dkyP3IJp
# CJbnuuFntvCmvxgIQuHrzRlYOaURYSPWGdcA6bvS+V9B+wQ+/oogYAzRTyNaGRoY
# 79jG3tZfVKF6k+G2d4XA+7FGxAmuL1P7lZyOJuJK5MTmPDXvusbZucXNzQebY7s9
# D2G8VXwjELWMiqPSaEWxQLqg3TwbFUC4SXhv5ZTAbVZLPPYSKtSF80gTBeG7MEUK
# Qbd8km6+TpJggspbZOZV09IH3p1fm6EB7Zvww127GfAYDJqgHOlqCAs96WaXp3Ue
# D78o1wkjDeIW+rrzNDGCBGkwggRlAgEBMDMwHzEdMBsGA1UEAwwUV2luZG93cyBB
# ZG1pbiBDZW50ZXICEGScKRIp1L66RgurHfOyi3cwDQYJYIZIAWUDBAIBBQCgTDAZ
# BgkqhkiG9w0BCQMxDAYKKwYBBAGCNwIBBDAvBgkqhkiG9w0BCQQxIgQg2i5FviH5
# FL+pmb8YU2FCo00+pxtmTlZsPohj9d8PynAwDQYJKoZIhvcNAQEBBQAEggEAPdHT
# wc4FZOaxUcb7PFruhjQTA3+qQD81y4l8JNc1HIfkcQreER9TSImwBu/TB8bmDaIP
# w+4iI+HwjfvLv5cYETE9SPxRztkmjhgdbg5+fSVIwBnD1W+mUhoB5C7awKT6vk+M
# wa4kMUmpVGly611gWeDjxfUz9ubBRxz3r3CSVfO9vwnjKNAg0A0oz1v66l79ff1m
# x6/iY4TrpaxQJTSa1h/64q88WcXwcEOrqF61ZVTyxG91u1TJNX+g5Yn7wSVegnGN
# CBu+II+TakT95JTcixpTyBN45p7oria4IGTmAzstMhm19urFoHYSUbHZHcecHlhv
# qZdBdOhng/XmTdhlQ6GCArkwggK1BgkqhkiG9w0BCQYxggKmMIICogIBATBrMFsx
# CzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQD
# EyhHbG9iYWxTaWduIFRpbWVzdGFtcGluZyBDQSAtIFNIQTI1NiAtIEcyAgwkVLh/
# HhRTrTf6oXgwDQYJYIZIAWUDBAIBBQCgggEMMBgGCSqGSIb3DQEJAzELBgkqhkiG
# 9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIwMDkwODE4MDUzM1owLwYJKoZIhvcNAQkE
# MSIEIPKTaU2P5OYsgXLBhD3B77tUfHSgr/uA07VozLSGYXEHMIGgBgsqhkiG9w0B
# CRACDDGBkDCBjTCBijCBhwQUPsdm1dTUcuIbHyFDUhwxt5DZS2gwbzBfpF0wWzEL
# MAkGA1UEBhMCQkUxGTAXBgNVBAoTEEdsb2JhbFNpZ24gbnYtc2ExMTAvBgNVBAMT
# KEdsb2JhbFNpZ24gVGltZXN0YW1waW5nIENBIC0gU0hBMjU2IC0gRzICDCRUuH8e
# FFOtN/qheDANBgkqhkiG9w0BAQEFAASCAQAkH/6qWDkcKpVexhoW6NXzdbTQp6oh
# JrEPly4ctilOcsaovAn4V6pK4A8h+SrMmKiIGSNk6YCEAufsTT2tAPt47biWsZA2
# NicuMeuGzUXiN5umfT7TsI9ulTjoMt8ndlK+9Tq0kgY3rRemhqHdpIt2Q2oX1ZEf
# /1Yd2fKAkUVxBmXuA1ukOOeBvZQlnzT5H0XDNPuoJ5LoHXTtBq5KSOcNCdcdrEBG
# 4nwe2B3IB81NJFGaDHosOlRi/0hZ9aK8grRTY8Q7KCSLg53pJ+2RNRYkrAd4sprU
# vrRJoW5htWV+YIBupg+OBOoGXq4puwOjlYmHRaxq64hYD7wlRkkk436N
# SIG # End signature block
