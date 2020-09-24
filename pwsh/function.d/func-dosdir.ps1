function global:dosdir($arg) {
	cmd /c "dir /od  '$arg'"
}

set-alias -name 'll' -scope 'global' -value global:dosdir

function global:dosdirrecurse($arg) {
	cmd /c "dir /s /aa /b $arg"
}

set-alias -name 'll-r' -scope 'global' -value global:dosdirrecurse