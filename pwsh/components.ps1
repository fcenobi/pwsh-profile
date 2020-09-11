# -------------- #
# components.ps1 #
# -------------- #

# These components will be loaded for all PowerShell instances

# TODO: Add rustup component

# Write-Output "components.ps1"

Push-Location (Join-Path (Split-Path -parent $profile) "components")

# From within the ./components directory...
. .\general-modules.ps1
# . .\cargo.ps1
. .\dotnet.ps1
. .\choco.ps1
. .\git.ps1
. .\npm.ps1
. .\scoop.ps1
. .\yarn.ps1
. .\admintoolbox.ps1


Pop-Location

# EOF #
