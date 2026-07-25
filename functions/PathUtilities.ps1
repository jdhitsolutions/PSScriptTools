function Get-PathVariable {
    [cmdletbinding()]
    [Alias('Get-Path')]
    [OutputType('EnvPath')]
    param(
        [ValidateSet('All', 'User', 'Machine')]
        [string]$Scope = 'All'
    )

    #tags are used for categorizing the command
    #cmdTags = general
    Write-Verbose "Starting $($MyInvocation.MyCommand)"
    Write-Verbose "Running under PowerShell version $($PSVersionTable.PSVersion)"

    #private helper function to create the custom object
    function NewEnvPath {
        [cmdletbinding()]
        param(
            [Parameter(ValueFromPipeline)]
            [string]$Path, [string]$Scope
        )

        process {
            [PSCustomObject]@{
                PSTypeName   = 'EnvPath'
                Scope        = $Scope
                Computername = [System.Environment]::MachineName
                UserName     = [System.Environment]::UserName
                Path         = $path
                Exists       = Test-Path $Path
            }
        }
    } #newEnvPath

    $user = {
        Write-Verbose 'Getting USER paths'
        #filter out blanks if path ends in a splitter
        $paths = [System.Environment]::GetEnvironmentVariable('PATH', 'User') -split $splitter | Where-Object { $_ }
        Write-Verbose "Found $($paths.count) path entries"
        $paths | NewEnvPath -Scope User
    }

    $machine = {
        Write-Verbose 'Getting MACHINE paths'
        $paths = [System.Environment]::GetEnvironmentVariable('PATH', 'Machine') -split $splitter | Where-Object { $_ }
        Write-Verbose "Found $($paths.count) path entries"
        $paths | NewEnvPath -Scope Machine
    }

    $lx = {
        Write-Verbose 'Getting ALL paths (Non-Windows)'
        $paths = [System.Environment]::GetEnvironmentVariable('PATH', 'Process') -split $splitter | Where-Object { $_ }
        Write-Verbose "Found $($paths.count) path entries"
        $paths | NewEnvPath -scope 'Process'
    }

    Write-Verbose "Using scope setting of $Scope"
    #get the path separator character specific to this operating system
    $splitter = [System.IO.Path]::PathSeparator

    if ($IsLinux -or $IsMacOS) {
        Invoke-Command -ScriptBlock $lx
    }
    elseif ($scope -eq 'User') {
        Invoke-Command -ScriptBlock $user
    }
    elseif ($scope -eq 'Machine') {
        Invoke-Command -ScriptBlock $machine
    }
    else {
        Write-Verbose 'Getting ALL paths (Windows)'
        $paths = @()
        $paths += Invoke-Command -ScriptBlock $user
        $paths += Invoke-Command -ScriptBlock $machine
        Write-Verbose "Found $($paths.count) path entries"
        $paths
    }
    Write-Verbose "Ending $($MyInvocation.MyCommand)"

} #end function


#EOF
