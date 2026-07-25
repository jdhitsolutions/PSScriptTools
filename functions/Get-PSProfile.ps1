function Get-PSProfile {
    [cmdletbinding()]
    [OutputType('PSProfilePath')]
    param()

    #tags are used for categorizing the command
    #cmdTags = general
    Write-Verbose "Starting $($MyInvocation.MyCommand)"
    Write-Verbose "Running under PowerShell version $($PSVersionTable.PSVersion)"
    #24 April 2025 Revise to support non-Windows systems

    if ($IsLinux -or $IsMacOS) {
        $hosts = [ordered]@{
            Name                   = 'PowerShell'
            Command                = 'pwsh'
            AllUsersAllHosts       = $profile.AllUsersAllHosts
            AllUsersCurrentHost    = $profile.AllUsersCurrentHost
            CurrentUserAllHosts    = $profile.CurrentUserAllHosts
            CurrentUserCurrentHost = $profile.CurrentUserCurrentHost
        }
        #TODO: Add locations for VSCode which can run cross-platform
    }
    else {
        $myLocation = (Get-PSLocation).Documents

        # a collection of known PowerShell profile paths
        $hosts = @(
            [ordered]@{
                Name                   = 'PowerShell'
                Command                = 'pwsh.exe'
                AllUsersAllHosts       = "$env:PROGRAMFILES\PowerShell\7\profile.ps1"
                AllUsersCurrentHost    = "$env:PROGRAMFILES\PowerShell\7\Microsoft.PowerShell_profile.ps1"
                CurrentUserAllHosts    = "$myLocation\PowerShell\profile.ps1"
                CurrentUserCurrentHost = "$myLocation\PowerShell\Microsoft.PowerShell_profile.ps1"
            },
            [ordered]@{
                Name                   = 'Windows PowerShell'
                Command                = 'powershell.exe'
                AllUsersAllHosts       = "$env:WINDIR\System32\WindowsPowerShell\v1.0\profile.ps1"
                AllUsersCurrentHost    = "$env:WINDIR\System32\WindowsPowerShell\v1.0\Microsoft.PowerShell_profile.ps1"
                CurrentUserAllHosts    = "$myLocation\WindowsPowerShell\profile.ps1"
                CurrentUserCurrentHost = "$myLocation\WindowsPowerShell\Microsoft.PowerShell_profile.ps1"
            },
            [ordered]@{
                Name                   = 'VSCode PowerShell'
                Command                = 'Code'
                AllUsersCurrentHost    = "$env:PROGRAMFILES\PowerShell\7\Microsoft.VSCode_profile.ps1"
                CurrentUserCurrentHost = "$myLocation\PowerShell\Microsoft.VSCode_profile.ps1"
            },
            [ordered]@{
                Name                   = 'VSCode Windows PowerShell'
                Command                = 'Code'
                AllUsersCurrentHost    = "$env:WINDIR\System32\WindowsPowerShell\v1.0\Microsoft.VSCode_profile.ps1"
                CurrentUserCurrentHost = "$myLocation\WindowsPowerShell\Microsoft.VSCode_profile.ps1"
            },
            [ordered]@{
                Name                   = 'PowerShell ISE'
                Command                = 'Powershell_ISE.exe'
                AllUsersCurrentHost    = "$env:WINDIR\System32\WindowsPowerShell\v1.0\Microsoft.PowerShellISE_profile.ps1"
                CurrentUserCurrentHost = "$myLocation\WindowsPowerShell\Microsoft.PowerShellISE_profile.ps1"
            }
        )
    } #if windows

    foreach ($h in $hosts) {
        try {
            #verify command
            Write-Verbose "Processing possible profiles for $($h.name)"
            [void](Get-Command $h.command -ErrorAction stop)

            $profiles = $h.GetEnumerator() | Where-Object name -Match host

            foreach ($item in $profiles) {
                #test the file
                Write-Verbose "Testing $($item.value)"
                if (Test-Path -Path $item.value) {
                    $Exists = $True
                    $file = Get-Item $item.value
                    # 8 July 2026 Account for profiles that might be using symbolic links
                    if ($file.Target) {
                        $Modified = (Get-Item $file.target).LastWriteTime
                        #8 July 2026 Add the profile file size
                        $Size = (Get-Item $file.target).Length
                    }
                    else {
                        $Modified = (Get-Item $item.value).LastWriteTime
                        #8 July 2026 Add the profile file size
                        $Size = (Get-Item $item.value).Length
                    }
                }
                else {
                    $Exists = $False
                    $Modified = $null
                    $Size = $null
                }
                #create a custom object
                [PSCustomObject]@{
                    PSTypeName   = 'PSProfilePath'
                    Name         = $h.Name
                    Scope        = $item.name
                    Path         = $item.Value
                    Exists       = $Exists
                    Size         = $Size
                    LastModified = $modified
                    Date         = Get-Date
                }
            }
        } #Try
        catch {
            Write-Warning "Could not find $($h.command) on this computer."
        } #Catch

    } #foreach h in hosts

    Write-Verbose "Ending $($MyInvocation.MyCommand)"
}
#EOF
