#requires -version 5.1

<#
list time zones
    [System.TimeZoneinfo]::GetSystemTimeZones() | out-gridview
    or
    Get-TimeZone -listavailable
time zone IDs are case sensitive
#>

Function Get-MyTimeInfo {

    [cmdletbinding()]
    [Outputtype("myTimeInfo", "String")]
    [alias("gti")]

    Param(
        [Parameter(Position = 0)]
        [ValidateNotNullOrEmpty()]
        #limit this to no more than 5 locations
        [System.Collections.Specialized.OrderedDictionary]$Locations = [ordered]@{
            Singapore = "Singapore Standard Time";
            Seattle   = "Pacific Standard Time";
            Stockholm = "Central Europe Standard Time";
        },
        [ValidateNotNullOrEmpty()]
        [string]$HomeTimeZone = "Eastern Standard Time",

        [Parameter(HelpMessage = "Specify the datetime value to use. The default is now.")]
        [ValidateNotNullOrEmpty()]
        [datetime]$DateTime = $(Get-Date),

        #Display the results as a formatted table. This parameter has an alias of ft.
        [Alias("ft")]
        [switch]$AsTable,

        #Display the results as a formatted list. This parameter has an alias of fl.
        [Alias("fl")]
        [switch]$AsList
    )

    Write-Verbose "Starting $($myinvocation.mycommmand)"

    $now = $DateTime
    $utc = $now.ToUniversalTime()

    Write-Verbose "Getting world clock settings for $Now [UTC: $UTC]"

    $hash = [Ordered]@{
        Now  = $now
        Home = [System.TimeZoneinfo]::ConvertTimeBySystemTimeZoneId($now, $HomeTimeZone)
        UTC  = $UTC
    }

    $locations.GetEnumerator() | foreach-object {
        Write-Verbose "Getting time for $($_.key)"
        $remote = [System.TimeZoneinfo]::ConvertTimeBySystemTimeZoneId($now, $_.value)
        Write-Verbose $remote
        $hash.Add($_.key, $remote)
    }

    $hash.add("IsDaylightSavings", $now.IsDaylightSavingTime())

    $tobj = New-Object -TypeName PSObject -Property $hash
    $tobj.psobject.TypeNames.insert(0, "myTimeInfo")

    $cities = $tobj.psobject.properties.where( {$_.name -notmatch 'utc|now'}).Name
    if ($AsTable) {
        Write-Verbose "Formatting output as a table"
        $tobj | Format-Table -GroupBy @{Name = "Now"; expression = {"$($_.Now) `n   UTC: $($_.utc)"}} -Property $cities | Out-String
    }
    elseif ($AsList) {
        Write-Verbose "Formatting output as a list"
        $tobj | Format-List -GroupBy @{Name = "Now"; expression = {"$($_.Now) `n   UTC: $($_.utc)"}} -Property $cities | Out-String
    }
    else {
        Write-Verbose "Writing object to the pipeline"
        $tobj
    }

    Write-Verbose "Ending $($myinvocation.mycommmand)"
} #end function