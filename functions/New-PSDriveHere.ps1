Function New-PSDriveHere {

    [cmdletBinding(SupportsShouldProcess = $True, DefaultParameterSetName = "Folder")]
    [OutputType([System.Management.Automation.PSDriveInfo])]
    [Alias("npsd")]

    Param(
        [Parameter(Position = 0)]
        [ValidateScript( {Test-Path $_})]
        [string]$Path = ".",

        [Parameter(Position = 1, ParameterSetName = "Name")]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [Parameter(ParameterSetName = "Folder")]
        [switch]$First,

        [Alias("cd")]
        [switch]$SetLocation,

        [Parameter(HelpMessage="Pass the new PSDrive object to the pipeline.")]
        [switch]$PassThru
    )

    Write-Verbose "Starting: $($MyInvocation.MyCommand)"

    Write-Verbose "Getting the location for $path"
    #get the specified location
    $location = Get-Item -Path $path

    #did the user specify a name?
    if ($PSCmdlet.ParameterSetName -eq "Name") {
        Write-Verbose "Defining a new PSDrive with the name $Name."
    } #if $name
    else {
        if ($first) {
            Write-Verbose "Using the first word in the target location."
            $pattern = "^\w+"
        }
        else {
            Write-Verbose "Using the last word in the target location."
            $pattern = "\w+$"
        }
        #Make sure name contains valid characters. This function
        #should work for all but the oddest named folders.
        if ($location.Name -match $pattern) {
            $name = $matches[0]
        }
        else {
            #The location has something odd about it so bail out
            Write-Warning "$path doesn't meet the criteria"
            Break
        }

    } #else using part of folder name

    #verify a PSDrive doesn't already exist
    Write-Verbose "Testing $($name):"

    If (-not (Test-Path -Path "$($name):")) {
        Write-Verbose "Creating PSDrive for $name"
        #a hash table of parameter values to splat to New-PSDrive
        $paramHash = @{
            Name        = $name
            PSProvider  = $location.PSProvider
            Root        = $Path
            Description = "Created $(Get-Date)"
            Scope       = 'Global'
            ErrorAction = 'Stop'
        }

        Try {
            $result = New-PSDrive @paramHash
            if ($PassThru) {
                $result
            }
            if ($SetLocation) {
                Write-Verbose "Setting location to $($name):"
                Set-Location -Path "$($name):"
            }
        } #try
        Catch {
            Write-Error $_
        }

    } #if Not Test-Path
    else {
        Write-Warning "A PSDrive for $name already exists"
    }

    Write-Verbose "Ending: $($MyInvocation.MyCommand)"

} #function



