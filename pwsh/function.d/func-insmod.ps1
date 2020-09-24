function global:insmod($mod) {
 Install-Module -Name $mod -Scope AllUsers -AllowPrerelease 
 Import-Module $mod 
 get-command -module $mod
 }
 
 set-alias -name 'Instmod' -scope 'global' -value global:insmod
