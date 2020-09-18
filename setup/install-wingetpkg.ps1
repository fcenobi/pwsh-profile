function resetEnv {
    Set-Item `
        -Path (('Env:', $args[0]) -join '') `
        -Value ((
            [System.Environment]::GetEnvironmentVariable($args[0], "Machine"),
            [System.Environment]::GetEnvironmentVariable($args[0], "User")
        ) -match '.' -join ';')
}
resetEnv Path
resetEnv AppPath


winget install	7zip.7zip

resetEnv Path
resetEnv AppPath

winget install	AdoptOpenJDK.OpenJDK


resetEnv Path
resetEnv AppPath

winget install	GitHub.cli


resetEnv Path
resetEnv AppPath

winget install	Notepad++.Notepad++


resetEnv Path
resetEnv AppPath

winget install	Microsoft.dotNetFramework


resetEnv Path
resetEnv AppPath

winget install	Microsoft.dotnet


resetEnv Path
resetEnv AppPath

winget install	Google.Chrome


resetEnv Path
resetEnv AppPath

winget install	MRidgers.Clink

resetEnv Path
resetEnv AppPath
winget install	FarManager.FarManager

resetEnv Path
resetEnv AppPath
winget install	Microsoft.PowerToys
resetEnv Path
resetEnv AppPath
winget install	Microsoft.WindowsTerminal
resetEnv Path
resetEnv AppPath
winget install	PuTTY.PuTTY
resetEnv Path
resetEnv AppPath
winget install	WinSCP.WinSCP
resetEnv Path
resetEnv AppPath
winget install	dbeaver.dbeaver
resetEnv Path
resetEnv AppPath
winget install	Python.Python
resetEnv Path
resetEnv AppPath
winget install	OpenJS.Nodejs


resetEnv Path
resetEnv AppPath

winget install	Yarn.Yarn

resetEnv Path
resetEnv AppPath
