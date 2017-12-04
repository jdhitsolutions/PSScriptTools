
<#
need an easy way to determine certain locations depending on whether you
are running Windows or Linux

TEMP
HOME (or DOCUMENTS?)
DESKTOP
PowerShell (location of $profile)
#>

Function Get-PSLocation {
    [cmdletbinding()]
    Param()
   
    if ($isLinux) {
        $ThisHome = $Env:HOME
    }
    else {
        #must be running Windows
        $ThisHome = Join-Path -Path $env:UserProfile -ChildPath Documents
    }

    [PSCustomObject]@{
        Temp = [system.io.path]::GetTempPath()
        Home = $ThisHome
        Desktop = [system.environment]::GetFolderPath("Desktop")
        PowerShell = Split-Path $profile
    }

} #close Get-PSLocation