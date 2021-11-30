Function Get-LastModifiedFile {
    [cmdletbinding()]
    [alias("glm")]
    [OutputType("System.IO.FileInfo")]
    Param(
        [Parameter(Position = 0, HelpMessage = "Specify a file filter like *.ps1.")]
        [ValidateNotNullOrEmpty()]
        [string]$Filter = "*",

        [Parameter(Position = 1, HelpMessage = "Specify the folder to search.")]
        [ValidateScript({
          #this will write a custom error message if validation fails
          If ((Test-Path -path $_ -PathType Container) -AND ((Get-Item -path $_).psprovider.name -eq 'Filesystem')) {
              return $True
          }
          else {
              Throw "The specified Path value $_ is not a valid folder or not a file system location."
              return $False
          }
        })]
        [string]$Path = ".",

        [Parameter(HelpMessage = "Specify the search interval based on the last write time.")]
        [ValidateSet("Hours", "Minutes", "Days", "Months", "Years")]
        [string]$Interval = "Hours",

        [Parameter(HelpMessage = "Specify the number of intervals.")]
        [alias("ic")]
        [ValidateScript({$_ -ge 1})]
        [int32]$IntervalCount = 24,

        [Parameter(HelpMessage = "Recurse from the specified path.")]
        [switch]$Recurse
    )

    Write-Verbose "Starting $($myinvocation.mycommand)"
    $msg ="Searching {0} for {1} files modified in the last {2} {3}." -f (Convert-Path $Path),$filter,$IntervalCount,$Interval
    Write-Verbose $msg

    switch ($Interval) {
        "minutes" { $last = (Get-Date).AddMinutes(-$IntervalCount) }
        "hours"   { $last = (Get-Date).AddHours(-$IntervalCount) }
        "days"    { $last = (Get-Date).AddDays(-$IntervalCount) }
        "months"  { $last = (Get-Date).AddMonths(-$IntervalCount) }
        "years"   { $last = (Get-Date).AddYears(-$IntervalCount) }
    }
    Write-Verbose "Cutoff date is $Last"

    #remove bound parameters that don't belong to Get-ChildItem
    "IntervalCount", "Interval" | ForEach-Object {
        if ($PSBoundParameters.ContainsKey($_)) {
            [void]$PSBoundParameters.Remove($_)
        }
    }
    #add -File to PSBoundParameters
    $PSBoundParameters.Add("file", $True)
    if ($recurse) {
        Write-Verbose "Recursing..."
    }
    else {
        Write-Verbose "Searching..."
    }

    #get the files and filter on the LastWriteTime using the Where() method for
    #better performance
    (Get-ChildItem @PSBoundParameters).Where({$_.LastWriteTime -ge $last})

    Write-Verbose "Ending $($myinvocation.mycommand)"
}

