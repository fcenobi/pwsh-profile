$funcname   = func-get-fixed-drive-letter
$funcalias  = get-fixdriveletter
function global:$funcname($arg) {
	Get-Volume | Select-Object -Property DriveLetter,DriveType,FileSystemType,Size | Where-Object -Property Drivetype -eq 'Fixed' | Where-Object -Property FileSystemType -ne 'Unknown' | Where-Object -Property Size -ge  51582979 | Sort-Object  -Property DriveLetter |  Select-Object -Property DriveLetter}

set-alias -name '$funcalias' -scope 'global' -value global:$funcname

