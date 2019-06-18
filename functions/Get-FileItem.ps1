
Function Get-FileItem {

    [cmdletbinding(DefaultParameterSetName = "Default")]
    [outputtype("System.IO.FileInfo", "System.Boolean")]
    [alias("pswhere")]

    Param(
        [Parameter(
            Position = 0,
            Mandatory,
            HelpMessage = "Enter a filename or pattern to search for")]
        [ValidateNotNullorEmpty()]
        [string[]]$Pattern,
        [switch]$Regex,
        [Parameter(ParameterSetName = "Path")]
        [string[]]$Path,
        [Parameter(ParameterSetName = "Path")]
        [switch]$Recurse,
        [switch]$Full,
        [switch]$Quiet,
        [switch]$First
    )

#region private helper function
    <#
 The Resolve-EnvVariable function is used by Get-FileItem to resolve
 any paths that might contain environmental names like %WINDIR% or
 %USERNAME%
    #>
    Function Resolve-EnvVariable {

        [cmdletbinding()]
        Param(
            [Parameter(Position = 0, Mandatory = $True,
                HelpMessage = "Enter a string that contains an environmental variable like %WINDIR%")]
            [ValidatePattern("%\S+%")]
            [string]$String
        )

        Write-Verbose "Starting $($myinvocation.mycommand)"
        Write-Verbose "Resolving environmental variables in $String"
        [environment]::ExpandEnvironmentVariables($string)
        Write-Verbose "Ending $($myinvocation.mycommand)"
    } #end Resolve-EnvVariable function

#endregion

    #This is the main part of Get-FileItem
    Write-Verbose "Starting $($myinvocation.MyCommand)"
    Write-Verbose "Searching for $pattern"
    Write-Verbose "Quiet mode is $Quiet"
    Write-Verbose "Full mode is $Full"

    if ($path) {
        #use specified path or array of paths
        $paths = $path
    }
    else {
        #use %PATH% system environmental variable
        #split %PATH% and weed out any potential duplicates or null values
        $paths = $env:path.Split(";") | Select-Object -Unique | Where-Object {$_}
    }

    #define a variable to hold results
    $results = @()

    #foreach path search for the pattern
    foreach ($path in $paths) {
        #if path has an environmental variable, resolve it first
        if ($path.Contains("%")) {
            Write-Verbose "Resolving environmental variables found in the path"
            $path = Resolve-EnvVariable -string $path
        }

        #Validate path is still good
        Write-Verbose "Testing $path"
        If (Test-Path -Path $path) {
            Write-Verbose "Searching $path"

            #search for each pattern
            foreach ($p in $pattern) {
                #define parameters to splat to Get-ChildItem
                #save errors to a variable to display later
                #suppressing error messages for now which are typically for access denied to system folders
                $dirParams = @{
                    Path          = $path
                    Recurse       = $Recurse
                    Force         = $True
                    ErrorAction   = "SilentlyContinue"
                    ErrorVariable = "ev"
                }

                if (-Not $regex) {
                    $dirParams.add("Filter", $p)
                }

                Write-Verbose "...for $p"
                #not thrilled with this structure but it works
                if ($Regex) {
                    Write-Verbose "...as regex"
                    $results += (Get-Childitem @dirParams).where( {$_.name -match $p})
                }
                elseif ($Regex -AND $first) {
                    Write-Verbose "...as regex"
                    $results += (Get-Childitem @dirParams).where( {$_.name -match $p}) |
                        Select-Object -First 1
                }
                elseif ($First) {
                    $results += Get-ChildItem @dirParams | Select-Object -first 1
                }
                else {
                    $results += Get-ChildItem @dirParams
                }
            } #foreach p
            Write-Verbose "Evaluating results"

            #process errors
            foreach ($item in $ev) {
                if ($item.exception.getType().name -eq "UnauthorizedAccessException") {
                    Write-Warning $item.exception.message
                }
                else {
                    Write-Error "$($item.exception.message) [$($item.Exception.getType().name)]"
                }
            }
        } #if test path
        Else {
            Write-Warning "Failed to verify $Path"
        }
    } #foreach

    $count = ($results | Measure-Object).count
    write-verbose "Found $count matches"

    If (($count -gt 0) -And $Quiet) {
        #if Quiet and results found write $True
        $True
    }
    elseif (($count -eq 0) -And $Quiet) {
        $False
    }
    elseif (($count -gt 0) -AND $Full) {
        #if results found and write file results
        $results
    }
    Else {
        #else just write full name
        $results | Select-Object -expandproperty Fullname
    }

    Write-Verbose "Ending $($myinvocation.MyCommand)"

} #end function

