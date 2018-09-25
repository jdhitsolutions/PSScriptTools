
Function New-RandomFileName {
    [cmdletbinding(DefaultParameterSetName = "none")]
    [outputtype([string])]
    Param(
        [parameter(Position = 0)]
        [Parameter(ParameterSetName = 'none')]
        [Parameter(ParameterSetName = 'home')]
        [Parameter(ParameterSetName = 'temp')]
        #enter an extension without the leading period e.g 'bak'
        [string]$Extension,
        [Parameter(ParameterSetName = 'temp')]
        [alias("temp")]
        [Switch]$UseTempFolder,
        [Parameter(ParameterSetName = 'home')]
        [alias("home")]
        [Switch]$UseHomeFolder
    )

    if ($UseTempFolder) {
        $filename = [system.io.path]::GetTempFileName()
    }
    elseif ($UseHomeFolder) {
        if ($PSVersionTable.PSEdition -eq 'Core' -AND $PSVersionTable.OS -notmatch "Windows") {
            $filename = Join-Path -Path $env:HOME -ChildPath ([system.io.path]::GetRandomFileName())
        }
        else {
            $filename = Join-Path -Path $env:USERPROFILE\Documents -ChildPath ([system.io.path]::GetRandomFileName())
        }
    }
    else {
        $filename = [system.io.path]::GetRandomFileName()
    }

    if ($Extension) {
        #get the extension and strip off the leading period
        $original = [system.io.path]::GetExtension($filename).Substring(1)
        $filename -replace "$original$", $Extension
    }
    else {
        $filename
    }

} #end New-RandomFilename


Function New-CustomFileName {
    [cmdletbinding()]
    [outputtype([string])]
    Param (
        [Parameter(Position = 0, Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Template,
        [ValidateSet("Lower", "Upper", "Default")]
        [string]$Case = "default"
    )

    #convert placeholders to lower case but leave everything else as is
    [regex]$rx = "%\w+(?=%|-|\.|\s|\(|\)|\[|\])"
   
    Write-Detail "Starting $($myinvocation.MyCommand)" | Write-Verbose
    Write-Detail "Processing template: $template" | Write-Verbose
    $rx.matches($Template) | foreach-object {
        Write-Detail "Converting $($_.value) to lower case" | Write-Verbose
        $Template = $Template.replace($_.value, $_.value.tolower())
    }

    [string]$filename = $Template
    Write-Detail "Using filename: $filename" | Write-Verbose
    $now = Get-Date
    if ($env:USERNAME) {
        $user = $env:USERNAME
    }
    elseif ($env:USER) {
        $user = $env:USER
    }
    else {
        $user = "Unknown"
    }
    #this needs to be an ordered hashtable so that the regex replacements
    #will be processed in the right order
    $hash = [ordered]@{
        '%username'     = $user
        '%computername' = (hostname)
        '%year'         = $now.Year
        '%yr'           = "{0:yy}" -f $now
        '%monthname'    = ("{0:MMM}" -f $now)
        '%month'        = $now.month
        '%dayofweek'    = $now.DayOfWeek
        '%day'          = $now.Day
        '%hour'         = $now.hour
        '%minute'       = $now.minute
        '%time'         = "{0}{1}{2}" -f $now.hour, $now.minute, $now.Second
        '%string'       = ([system.io.path]::GetRandomFileName()).split(".")[0]
        '%guid'         = [System.Guid]::NewGuid().guid
    }

    $hash.GetEnumerator() | foreach-object { 
        Write-Detail "Testing $filename for $($_.key)" | Write-Verbose
        if ($filename -match "($($_.key))") {
            Write-Detail "replacing $($_.key) with $($_.value)" | Write-Verbose
            $filename = $filename -replace "($($_.key))", $_.value
        }
    }

    #handle ### number replacement
    [regex]$rx = '%#+'
    if ($rx.IsMatch($filename)) {
        $count = $rx.Match($filename).Value.length - 1
        $num = (0..9 | Get-Random -Count 10 | Get-Random -count $count) -join ""
        Write-Detail "replacing # with $num" | Write-Verbose
        $filename = $rx.Replace($filename, $num)
    }

    Write-Detail "Converting case to $Case" | Write-Verbose
    Switch ($Case) {
        "Upper" {
            $filename.toUpper()
        }
        "Lower" {
            $filename.ToLower()
        }
        default {
            $filename
        }   
    } #close switch

    Write-Detail "Ending $($myinvocation.MyCommand)" | Write-Verbose
} #end New-CustomFileName

