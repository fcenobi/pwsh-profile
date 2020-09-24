$OpenSSHServer = Get-WindowsCapability -Online | ? Name -like 'OpenSSH.Server*'

Add-WindowsCapability -Online -Name $OpenSSHServer.Name 

$SSHDaemonSvc = Get-Service -Name 'sshd'
Start-Service -Name $SSHDaemonSvc.Name
Stop-Service -Name $SSHDaemonSvc.Name


$authorizedKeyFilePath = "$env:ProgramData\ssh\administrators_authorized_keys"

New-Item $authorizedKeyFilePath


$autkey = 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCpO8US5JGTL4Jg6/ASSVARx2S58iOyWFwd1+V54xyplKFNI8aLc89D2dO77pgOv3vVAY+4FZ9U6rlMFbqeQ+xjSF/74Q2UnbZVXJs9KaWSXbefkVywv+eKAPeG9T5/lnqD6TO9TsupXg1xqJwtGVs0Mzhphj5264rvAUKPcdIvagx4jF0X/EYhCWMdbuXIYZ5TvgTqnt6z00iRXEOM1U6jj26Bo7eB5ovoADHTJJhbSRDbZ5osF94yHngfjjgz01rfJDjOMgrer1NDufAt961M5uqmibve+EFiFPhDz81i/MhvoTO2IIBjLzRa4r5xY88x77DhLMbPXlHQcb+aioTp fcenobi@bradibook.local'

Add-Content -Value $autkey -Path $authorizedKeyFilePath -force

icacls.exe $authorizedKeyFilePath /remove "NT AUTHORITY\Authenticated Users"
icacls.exe $authorizedKeyFilePath /inheritance:r
Get-Acl "$env:ProgramData\ssh\ssh_host_dsa_key" | Set-Acl $authorizedKeyFilePath


Write-Host -ForegroundColor Yellow 		-Object '+**************************+'
Write-Host -ForegroundColor Yellow 		-Object ':       powershell5        :'
Write-Host -ForegroundColor Yellow 		-Object '+**************************+'
Write-Host -ForegroundColor DarkCyan 	-Object 'New-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" -Name DefaultShell -Value "$env:WINDIR\System32\WindowsPowerShell\v1.0\powershell.exe" -PropertyType String -Force'

Write-Host -ForegroundColor Yellow 		-Object '+**************************+'
Write-Host -ForegroundColor Yellow 		-Object ':       powershell core    :'
Write-Host -ForegroundColor Yellow 		-Object '+**************************+'
Write-Host -ForegroundColor DarkCyan 	-Object 'New-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" -Name DefaultShell -Value "C:\Program Files\PowerShell\7\pwsh.exe" -PropertyType String -Force'

$SSHDaemonSvc = Get-Service -Name 'sshd'
Set-Service 	-Name $SSHDaemonSvc.Name -StartupType Automatic
Start-Service   -Name $SSHDaemonSvc.Name

