
Function Get-PSProfile {
    [cmdletbinding()]
    [OutputType("PSProfilePath")]
    Param()

    Write-Verbose "Starting $($MyInvocation.MyCommand)"
    if ($IsWindows -OR ($PSEdition -eq "Desktop")) {
        $myDocsLocation = (Get-PSLocation).Home
        # a collection of known PowerShell profile paths
        $hosts = @(
            @{
                Name                   = "PowerShell"
                Command                = "pwsh.exe"
                AllUsersAllHosts       = "$env:PROGRAMFILES\PowerShell\7\profile.ps1"
                AllUsersCurrentHost    = "$env:PROGRAMFILES\PowerShell\7\Microsoft.PowerShell_profile.ps1"
                CurrentUserAllHosts    = "$myDocsLocation\PowerShell\profile.ps1"
                CurrentUserCurrentHost = "$myDocsLocation\PowerShell\Microsoft.PowerShell_profile.ps1"
            },
            @{
                Name                   = "Windows PowerShell"
                Command                = "powershell.exe"
                AllUsersAllHosts       = "$env:WINDIR\System32\WindowsPowerShell\v1.0\profile.ps1"
                AllUsersCurrentHost    = "$env:WINDIR\System32\WindowsPowerShell\v1.0\Microsoft.PowerShell_profile.ps1"
                CurrentUserAllHosts    = "$myDocsLocation\WindowsPowerShell\profile.ps1"
                CurrentUserCurrentHost = "$myDocsLocation\WindowsPowerShell\Microsoft.PowerShell_profile.ps1"
            },
            @{
                Name                   = "VSCode PowerShell"
                Command                = "Code"
                AllUsersCurrentHost    = "$env:PROGRAMFILES\PowerShell\7\Microsoft.VSCode_profile.ps1"
                CurrentUserCurrentHost = "$myDocsLocation\PowerShell\Microsoft.VSCode_profile.ps1"
            },
            @{
                Name                   = "VSCode Windows PowerShell"
                Command                = "Code"
                AllUsersCurrentHost    = "$env:WINDIR\System32\WindowsPowerShell\v1.0\Microsoft.VSCode_profile.ps1"
                CurrentUserCurrentHost = "$myDocsLocation\WindowsPowerShell\Microsoft.VSCode_profile.ps1"
            },
            @{
                Name                   = "PowerShell ISE"
                Command                = "Powershell_ISE.exe"
                AllUsersCurrentHost    = "$env:WINDIR\System32\WindowsPowerShell\v1.0\Microsoft.PowerShellISE_profile.ps1"
                CurrentUserCurrentHost = "$myDocsLocation\WindowsPowerShell\Microsoft.PowerShellISE_profile.ps1"
            }
        )

        Foreach ($h in $hosts) {
            Try {
                #verify command
                Write-Verbose "Processing possible profiles for $($h.name)"
                [void](Get-Command $h.command -erroraction stop)

                $profiles = $h.GetEnumerator() | Where-Object name -match host

                foreach ($item in $profiles) {
                    #test the file
                    Write-Verbose "Testing $($item.value)"
                    if (Test-Path -Path $item.value) {
                        $Exists = $True
                        $Modified = (Get-Item $item.value).LastWriteTime
                    }
                    else {
                        $Exists = $False
                        $Modified = $null
                    }
                    #create a custom object
                    [PSCustomObject]@{
                        PSTypeName   = "PSProfilePath"
                        Name         = $h.Name
                        Scope        = $item.name
                        Path         = $item.Value
                        Exists       = $Exists
                        LastModified = $modified
                        Date         = Get-Date
                    }
                }
            } #Try
            Catch {
                Write-Warning "Could not find $($h.command) on this computer."
            } #Catch

        } #foreach h in hosts
    } #if Windows
    else {
        Write-Warning "This command is intended for a Windows system."
    }

    Write-verbose "Ending $($MyInvocation.MyCommand)"
}