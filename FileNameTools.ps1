
#TODO: aDD OPTION TO WRITE TO HOME FOLDER OR DOCUMENTS

Function New-RandomFileName {
    [cmdletbinding()]
    Param(
        [parameter(Position = 0)]
        #enter an extension without the leading period e.g 'bak'
        [string]$Extension,
        [alias("temp")]
        [Switch]$UseTempFolder
    )

    if ($UseTempFolder) {
        $filename = [system.io.path]::GetTempFileName()
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

} #end Get-RandomFilename

<#
create a custom file name from any combination of elements
computername
username
month
day
year
time (hour:minute:second)

specify a separate like - _ or none
#>
Function New-CustomFileName {
    [cmdletbinding()]
    Param (
        [Parameter(Position = 0)]
        [string]$Template,
        [ValidateSet("Lower", "Upper", "Default")]
        [string]$Case = "default"
    )

    [string]$filename = $Template.toLower()

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
        '%monthname'  = ("{0:MMM}" -f $now)
        '%month'        = $now.month
        '%dayofweek'    = $now.DayOfWeek
        '%day'          = $now.Day
        '%hour'         = $now.hour
        '%minute'       = $now.minute
        '%time'         = "{0}{1}{2}" -f $now.hour, $now.minute, $now.Second
    }

    $hash.GetEnumerator() | foreach-object { 
        write-verbose "Testing $filename for ($($_.key))"
        if ($filename -match "($($_.key))") {
          write-verbose "replacing $($_.key) with $($_.value)"
          $filename = $filename -replace "($($_.key))",$_.value
        }
    }

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
} #end New-CustomFileName

#New-CustomFileName '%Username-%DayofWeek.log' -Verbose

#New-CustomFileName '%UserName_%Computername_%Year%monthname%day-%time.txt' -case default -Verbose