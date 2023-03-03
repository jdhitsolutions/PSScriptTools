
<#
an easy way to determine certain locations depending on whether you
are running Windows or Linux

TEMP
HOME (or DOCUMENTS?)
DESKTOP
PowerShell (location of $profile)
#>

Function Get-PSLocation {
    [cmdletbinding()]
    Param()

    if ($profile) {
        $ps = Split-Path $profile
    }
    elseif ($IsCoreCLR) {
        $ps = Split-Path (pwsh -noprofile -nologo {$profile})
    }
    else {
        $ps = Split-Path (powershell -noprofile -nologo {$profile})
    }

    [PSCustomObject]@{
        PSTypename = "psLocation"
        Home       = [Environment]::GetFolderPath([Environment+SpecialFolder]::MyDocuments)
        Temp       = [system.io.path]::GetTempPath()
        Desktop    = [environment]::GetFolderPath("Desktop")
        PowerShell = $ps
        PSHome     = $PSHome
    }

} #close Get-PSLocation