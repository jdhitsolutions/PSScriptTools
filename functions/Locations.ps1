
<#
an easy way to determine certain locations depending on whether you
are running Windows or Linux

TEMP
HOME (or DOCUMENTS?)
DESKTOP
PowerShell (location of $profile)
#>

function Get-PSLocation {
    [cmdletbinding()]
    param()

    #tags are used for categorizing the command
    #cmdTags = general
    if ($profile) {
        $ps = Split-Path $profile
    }
    elseif ($IsCoreCLR) {
        $ps = Split-Path (pwsh -noprofile -nologo { $profile })
    }
    else {
        $ps = Split-Path (powershell -noprofile -nologo { $profile })
    }

    [PSCustomObject]@{
        PSTypename  = 'psLocation'
        Home        = [environment]::GetFolderPath('UserProfile')
        Documents   = [Environment]::GetFolderPath([Environment+SpecialFolder]::MyDocuments)
        Temp        = [System.IO.Path]::GetTempPath()
        Desktop     = [Environment]::GetFolderPath('Desktop')
        PowerShell  = $ps
        PSHome      = $PSHome
        ModulePaths = $env:PSModulePath -split [System.IO.Path]::PathSeparator
    }

} #close Get-PSLocation
#EOF
