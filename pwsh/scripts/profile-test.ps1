$Profile | Get-Member |?{$_.membertype -eq “NoteProperty”}     | Select-Object -Property Name, @{label="Path";e={$_.definition -replace "^.+="}}


If (!( Test-Path $Profile )) { 
New-Item $Profile  -Type  File  -Force
} Else  {
$A  =  Get-Content  $Profile }

If (!( $A -Like  "*Get-WMIClass*"  ))  {
 $Content = @(
 "Function GET-WMIClass {"
 '$NS="Root\CIMV2"'
 '$Class=$args[0]'
 'Get-WMIObject -Namespace $NS -Class $Class'
 "}"
 )
 $Content | Add-Content $Profile -Encoding  UTF8
}
