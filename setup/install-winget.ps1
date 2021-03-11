Start-Process -FilePath 'C:\Program Files\Internet Explorer\iexplore.exe'
Stop-Process -Name iexplore

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
	$tag = ($json | ConvertFrom-Json)[1].tag_name
	$file = ($json | ConvertFrom-Json)[1].assets[1].name
	Write-Host "https://github.com/$repo/releases/download/$tag/$file"
	$download = "https://github.com/$repo/releases/download/$tag/$file"
	$output = $PSScriptRoot + "\winget-latest.appxbundle"
	Write-Host "Dowloading latest release"
	Invoke-WebRequest -Uri $download -OutFile $output
	
	Write-Host "Installing the package"
	Add-AppxPackage -Path $output
}
