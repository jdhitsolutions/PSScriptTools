
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

    [PSCustomObject]@{
        PSTypename = "psLocation"
        Home       = [Environment]::GetFolderPath([Environment+SpecialFolder]::MyDocuments)
        Temp       = [system.io.path]::GetTempPath()
        Desktop    = [system.environment]::GetFolderPath("Desktop")
        PowerShell = Split-Path $profile
        PSHome     = $PSHome
    }

} #close Get-PSLocation