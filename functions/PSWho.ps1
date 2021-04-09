
<#
originally published at:
https://gist.github.com/jdhitsolutions/3ecc6193ab0982d907c2db3f7d2bd15d
#>
Function Get-PSWho {

    [CmdletBinding()]
    [OutputType("PSWho","String")]
    [alias("pswho")]

    Param(
        [switch]$AsString
    )

    if ($PSVersionTable.PSEdition -eq "desktop" -OR $PSVersionTable.OS -match "Windows") {

        #get some basic information about the operating system
        $cimos = Get-CimInstance win32_operatingsystem -Property Caption, Version, OSArchitecture
        $os = "$($cimos.Caption) [$($cimos.OSArchitecture)]"
        $osver = $cimos.Version

        #determine the current user so we can test if the user is running in an elevated session
        $current = [Security.Principal.WindowsIdentity]::GetCurrent()
        $principal = [Security.Principal.WindowsPrincipal]$current
        $Elevated = $principal.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
        $user = $current.Name
        $computer = $env:COMPUTERNAME
    }
    else {
        #non-Windows values
        $os = $PSVersionTable.OS
        $lsb = lsb_release -d
        $osver = ($lsb -split ":")[1].Trim()
        $elevated =  Test-IsElevated
        $user = [System.Environment]::UserName
        $computer = [System.Environment]::MachineName
    }

    #object properties will be displayed in the order they are listed here
    $who = [pscustomObject]@{
        PSTypeName      = "PSWho"
        User            = $user
        Elevated        = $elevated
        Computername    = $computer
        OperatingSystem = $os
        OSVersion       = $osver
        PSVersion       = $PSVersionTable.PSVersion.ToString()
        Edition         = $PSVersionTable.PSEdition
        PSHost          = $host.Name
        WSMan           = $PSVersionTable.WSManStackVersion.ToString()
        ExecutionPolicy = (Get-ExecutionPolicy)
        Culture         = [System.Globalization.CultureInfo]::CurrentCulture.NativeName
    }

    if ($AsString) {
        ($who | Out-String).trim()
    }
    else {
        $who
    }
} #end Get-PSWho