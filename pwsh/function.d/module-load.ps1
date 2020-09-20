function module-load($moduleFolder) #import-all-module in the modulefolder 
  {
    foreach ($module in Get-Childitem $modulesFolder -Name -Filter "*.psm1")
            {
              Import-Module $modulesFolder\$module
            }
  }
