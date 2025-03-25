
#region set of functions for converting times to and from Universal time

Function ConvertTo-UTCTime {
    [cmdletbinding()]
    [alias("tout")]
    [OutputType([Datetime],[System.String])]
    Param(
        [Parameter(ValueFromPipeline, HelpMessage = "Enter a Datetime value")]
        [ValidateNotNullOrEmpty()]
        [datetime]$DateTime = $(Get-Date),
        [switch]$AsString
    )
    Begin {
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Starting $($MyInvocation.MyCommand)"

    } #begin

    Process {
        Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Converting $DateTime to UTC"
        $utc = $datetime.ToUniversalTime()
        if ($AsString) {
            "{0:u}" -f $utc
        }
        else {
            $utc
        }

    } #process

    End {
        Write-Verbose "[$((Get-Date).TimeOfDay) END    ] Ending $($MyInvocation.MyCommand)"

    } #end

} #close ConvertTo-UTCTime

Function ConvertFrom-UTCTime {
    [cmdletbinding()]
    [alias("frut")]
    [OutputType([datetime])]

    Param(
        [Parameter(
            Mandatory,
            HelpMessage = "Enter a Universal Datetime value",
            ValueFromPipeline
        )]
        [ValidateNotNullOrEmpty()]
        [datetime]$DateTime
    )
    Begin {
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Starting $($MyInvocation.MyCommand)"
    } #begin

    Process {
        Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Converting $DateTime UTC to local time"
        $DateTime.ToLocalTime()
    } #process

    End {
        Write-Verbose "[$((Get-Date).TimeOfDay) END    ] Ending $($MyInvocation.MyCommand)"
    } #end

} #close ConvertFrom-UTCTime

#endregion

#region time zone related commands
# convert a foreign time to local time
Function ConvertTo-LocalTime {
    [cmdletbinding()]
    [alias("clt")]
    [OutputType("DateTime")]
    Param(
        [Parameter(Position = 0, Mandatory, HelpMessage = "Enter a non local date time")]
        [datetime]$Datetime,
        [Parameter(Position = 1, Mandatory, HelpMessage = "Enter the location's' UTC Offset", ValueFromPipelineByPropertyName)]
        [Alias("offset")]
        [timespan]$UTCOffset,
        [Parameter(HelpMessage = "Indicate that the foreign location is using Daylight Saving Time")]
        [alias("dst")]
        [switch]$DaylightSavingTime
    )
    Begin {
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Starting $($MyInvocation.MyCommand)"
    } #begin

    Process {
        Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Converting $Datetime (UTC $UTCOffset) to local time "
        $u = ($Datetime).AddMinutes( - ($UTCOffset.TotalMinutes))
        Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] UTC is $u"
        if ($DaylightSavingTime) {
            Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Accounting for DST"
            $u.ToLocalTime().AddHours(-1)
        }
        else {
            $u.ToLocalTime()
        }

    } #process

    End {
        Write-Verbose "[$((Get-Date).TimeOfDay) END    ] Ending $($MyInvocation.MyCommand)"
    } #end

} #close ConvertTo-LocalTime

<#
list time zones
    [System.TimeZoneinfo]::GetSystemTimeZones() | Out-GridView
    or
    Get-TimeZone -listavailable
time zone IDs are case sensitive
#>

# http://worldtimeapi.org
Function Get-MyTimeInfo {

    [cmdletbinding()]
    [OutputType("myTimeInfo", "String")]
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

    Write-Verbose "Starting $($MyInvocation.MyCommand)"

    $now = $DateTime
    $utc = $now.ToUniversalTime()

    Write-Verbose "Getting world clock settings for $Now [UTC: $UTC]"

    $hash = [Ordered]@{
        Now  = $now
        Home = [System.TimeZoneInfo]::ConvertTimeBySystemTimeZoneId($now, $HomeTimeZone)
        UTC  = $UTC
    }

    $locations.GetEnumerator() | ForEach-Object {
        Write-Verbose "Getting time for $($_.key)"
        $remote = [System.TimeZoneInfo]::ConvertTimeBySystemTimeZoneId($now, $_.value)
        Write-Verbose $remote
        $hash.Add($_.key, $remote)
    }

    $hash.add("IsDaylightSavings", $now.IsDaylightSavingTime())

    $tObj = New-Object -TypeName PSObject -Property $hash
    $tObj.PSObject.TypeNames.insert(0, "myTimeInfo")

    $cities = $tObj.PSObject.properties.where( {$_.name -notmatch 'utc|now'}).Name
    if ($AsTable) {
        Write-Verbose "Formatting output as a table"
        $tObj | Format-Table -GroupBy @{Name = "Now"; expression = {"$($_.Now) `n   UTC: $($_.utc)"}} -Property $cities | Out-String
    }
    elseif ($AsList) {
        Write-Verbose "Formatting output as a list"
        $tObj | Format-List -GroupBy @{Name = "Now"; expression = {"$($_.Now) `n   UTC: $($_.utc)"}} -Property $cities | Out-String
    }
    else {
        Write-Verbose "Writing object to the pipeline"
        $tObj
    }

    Write-Verbose "Ending $($MyInvocation.MyCommand)"
} #end function

Function Get-TZData {
    [cmdletbinding()]
    [OutputType("PSCustomObject", "TimeZoneData")]
    Param(
        [Parameter(Position = 0, Mandatory, ValueFromPipeline,
            HelpMessage = "Enter a timezone location like Pacific/Auckland. It is case sensitive.")]
        [string]$TimeZoneArea,
        [parameter(HelpMessage = "Return raw, unformatted data.")]
        [switch]$Raw
    )
    Begin {
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Starting $($MyInvocation.MyCommand)"
        $base = "http://worldtimeapi.org/api/timezone"
    } #begin

    Process {
        Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Getting time zone information for $TimeZoneArea "
        $target = "$base/$TimeZoneArea"
        Try {
            $data = Invoke-RestMethod -Uri $target -DisableKeepAlive -UseBasicParsing -ErrorAction Stop -ErrorVariable e
            if ($data.utc_offset -match "\+") {
                $offset = ($data.utc_offset.substring(1) -as [timespan])
            } else {
                $offset = ($data.utc_offset -as [timespan])
            }
        }
        Catch {
            Throw $e.InnerException
        }
        if ($data -AND $Raw -AND ($psEdition -eq 'Core')) {

            #PowerShell Core automatically converts datetime strings and I want to preserve the raw value
            $toUTC = ([datetime]$data.datetime).ToUniversalTime().AddHours($offset.hours)
            [string]$dtString = "{0:s}.{2:ffffff}{1}" -f ([datetime]$toUTC.datetime), ($data.utc_offset),([datetime]$toUTC.DateTime)

            $data | Select-Object week_number, utc_offset, unixtime, timezone,
            @{Name = "dst_until"; expression = {"{0:s}+00:00" -f ([datetime]$data.dst_until).ToUniversalTime() }},
            @{Name = "dst_from"; expression = {"{0:s}+00:00" -f ([datetime]$data.dst_from).ToUniversalTime()  }},
            dst, day_of_year, day_of_week,
            @{Name = "datetime"; expression = {$dtString}},
            abbreviation
        }
        elseif ($data -AND $Raw -AND ($psEdition -eq 'Desktop')) {
            $data
        }
        elseif ($data) {
            [PSCustomObject]@{
                PSTypename         = "TimeZoneData"
                Timezone           = $data.timezone
                Abbreviation       = $data.abbreviation
                Offset             = $offset
                DaylightSavingTime = $data.dst
                Time               = ([datetime]"1/1/1970").AddSeconds($data.unixtime).AddHours($offset.hours)
            }
        }
    } #process

    End {
        Write-Verbose "[$((Get-Date).TimeOfDay) END    ] Ending $($MyInvocation.MyCommand)"

    } #end

} #close Get-TZData


Function Get-TZList {
    [cmdletbinding(DefaultParameterSetName = "zone")]
    [OutputType("string")]
    Param(
        [Parameter(Position = 0, Mandatory, ValueFromPipeline, HelpMessage = "Specify a timezone area", ParameterSetName = "zone")]
        [ValidateSet('Africa', 'America', 'Antarctica', 'Asia', 'Atlantic', 'Australia', 'Europe', 'Indian', 'Pacific')]
        [string]$TimeZoneArea,
        [Parameter(HelpMessage = "Get a list of all timezone areas", ParameterSetName = "all")]
        [switch]$All
    )
    Begin {
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Starting $($MyInvocation.MyCommand)"
        $base = "http://worldtimeapi.org/api/timezone"
    } #begin

    Process {
        if ($all) {
            Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Getting all time zones "
            $target = $base
        }
        else {
            Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Getting time zones for $TimeZoneArea "
            $target = "$base/$TimeZoneArea"

        }

        #because of the way the data is returned and in order to write this to the pipeline
        #so it can be passed to another command, it appears necessary to add a Foreach-Object
        #output
        Invoke-RestMethod -Uri $target -DisableKeepAlive -UseBasicParsing | Foreach-Object {$_}

    } #process

    End {
        Write-Verbose "[$((Get-Date).TimeOfDay) END    ] Ending $($MyInvocation.MyCommand)"
    } #end

} #close Get-TZList

#endregion