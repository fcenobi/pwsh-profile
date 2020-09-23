function global:OpenEditorws
		{ 
			if (!(Get-Command -Name notepad++.exe).Source) { 
					if (!(Test-Path -Path c:\tools\npp )) {
						New-Item -ItemType Directory -Force -Path c:\tools\npp 
						write-host "Create dir c:\tools\npp"
						}
				write-host "Install notepad++ in c:\tools\npp x86 "
				choco install -y -x86 --install-directory=c:\tools\npp notepadplusplus.install 
				choco install -y -x86 --install-directory=c:\tools\npp npppluginmanager
				}
			
			$notepadexe = (Get-Command -Name notepad++.exe).Source
			start-process $notepadexe "-multiInst -nosession -openfoldersasworkspace  filepath $args" 
		}

set-alias -name 'editws' -scope 'global' -value global:OpenEditorws

write-host "Function editws looad "