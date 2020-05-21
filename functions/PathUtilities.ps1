Function Get-PathVariable {
    [cmdletbinding()]
    [OutputType("EnvPath")]
    Param(
        [ValidateSet("All", "User", "Machine")]
        [string]$Scope = "All"
    )

    Write-Verbose "Starting $($myinvocation.MyCommand)"

    #private helper function to create the custom object
    Function NewEnvPath {
        [cmdletbinding()]
        Param(
            [Parameter(ValueFromPipeline)]
            [string]$Path, [string]$Scope
        )

        Process {
            [pscustomobject]@{
                PSTypeName   = "EnvPath"
                Scope        = $Scope
                Computername = [System.Environment]::MachineName
                UserName     = [System.Environment]::UserName
                Path         = $path
                Exists       = Test-Path $Path
            }
        }
    } #newEnvPath

    $user = {
        Write-Verbose "Getting USER paths"
        #filter out blanks if path ends in a splitter
        $paths = [System.Environment]::GetEnvironmentVariable("PATH", "User") -split $splitter | Where-Object { $_ }
        Write-Verbose "Found $($paths.count) path entries"
        $paths | NewEnvPath -Scope User
    }

    $machine = {
        Write-Verbose "Getting MACHINE paths"
        $paths = [System.Environment]::GetEnvironmentVariable("PATH", "Machine") -split $splitter | Where-Object { $_ }
        Write-Verbose "Found $($paths.count) path entries"
        $paths | NewEnvPath -Scope Machine
    }

    $lx = {
        Write-Verbose "Getting ALL paths (Non-Windows)"
        $paths = [System.Environment]::GetEnvironmentVariable("PATH", "Process") -split $splitter | Where-Object { $_ }
        Write-Verbose "Found $($paths.count) path entries"
        $paths | NewEnvPath -scope "Process"
    }

    Write-Verbose "Using scope setting of $Scope"
    #get the path separator character specific to this operating system
    $splitter = [System.IO.Path]::PathSeparator

    if ($IsLinux -OR $IsMacOS) {
        Invoke-Command -scriptblock $lx
    }
    elseif ($scope -eq "User") {
        Invoke-Command -scriptblock $user
    }
    elseif ($scope -eq "Machine") {
        Invoke-Command -scriptblock $machine
    }
    else {
        Write-Verbose "Getting ALL paths (Windows)"
        $paths = @()
        $paths += Invoke-Command -scriptblock $user
        $paths += Invoke-Command -scriptblock $machine
        Write-Verbose "Found $($paths.count) path entries"
        $paths
    }
    Write-Verbose "Ending $($myinvocation.MyCommand)"

} #end function

