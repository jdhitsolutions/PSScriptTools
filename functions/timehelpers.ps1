
#region set of functions for converting times to and from Universal time

function ConvertTo-UTCTime {
    [cmdletbinding()]
    [alias('tout')]
    [OutputType([Datetime], [System.String])]
    param(
        [Parameter(ValueFromPipeline, HelpMessage = 'Enter a Datetime value')]
        [ValidateNotNullOrEmpty()]
        [datetime]$DateTime = $(Get-Date),
        [switch]$AsString
    )
    begin {
        #tags are used for categorizing the command
        #cmdTags = time,scripting
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Starting $($MyInvocation.MyCommand)"
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Running under PowerShell version $($PSVersionTable.PSVersion)"

    } #begin

    process {
        Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Converting $DateTime to UTC"
        $utc = $datetime.ToUniversalTime()
        if ($AsString) {
            '{0:u}' -f $utc
        }
        else {
            $utc
        }

    } #process

    end {
        Write-Verbose "[$((Get-Date).TimeOfDay) END    ] Ending $($MyInvocation.MyCommand)"

    } #end

} #close ConvertTo-UTCTime

function ConvertFrom-UTCTime {
    [cmdletbinding()]
    [alias('frut')]
    [OutputType([datetime])]

    param(
        [Parameter(
            Mandatory,
            HelpMessage = 'Enter a Universal Datetime value',
            ValueFromPipeline
        )]
        [ValidateNotNullOrEmpty()]
        [datetime]$DateTime
    )
    begin {
        #tags are used for categorizing the command
        #cmdTags = time,scripting
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Starting $($MyInvocation.MyCommand)"
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Running under PowerShell version $($PSVersionTable.PSVersion)"
    } #begin

    process {
        Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Converting $DateTime UTC to local time"
        $DateTime.ToLocalTime()
    } #process

    end {
        Write-Verbose "[$((Get-Date).TimeOfDay) END    ] Ending $($MyInvocation.MyCommand)"
    } #end

} #close ConvertFrom-UTCTime

#endregion

#region time zone related commands
# convert a foreign time to local time
function ConvertTo-LocalTime {
    [cmdletbinding()]
    [alias('clt')]
    [OutputType('DateTime')]
    param(
        [Parameter(Position = 0, Mandatory, HelpMessage = 'Enter a non local date time')]
        [datetime]$Datetime,
        [Parameter(Position = 1, Mandatory, HelpMessage = "Enter the location's' UTC Offset", ValueFromPipelineByPropertyName)]
        [Alias('offset')]
        [timespan]$UTCOffset,
        [Parameter(HelpMessage = 'Indicate that the foreign location is using Daylight Saving Time')]
        [alias('dst')]
        [switch]$DaylightSavingTime
    )
    begin {
        #tags are used for categorizing the command
        #cmdTags = time,scripting
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Starting $($MyInvocation.MyCommand)"
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Running under PowerShell version $($PSVersionTable.PSVersion)"
    } #begin

    process {
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

    end {
        Write-Verbose "[$((Get-Date).TimeOfDay) END    ] Ending $($MyInvocation.MyCommand)"
    } #end

} #close ConvertTo-LocalTime

<#
list time zones
    [System.TimeZoneInfo]::GetSystemTimeZones() | Out-GridView
    or
    Get-TimeZone -listAvailable
time zone IDs are case sensitive
#>

function Get-MyTimeInfo {
    [cmdletbinding()]
    [OutputType('myTimeInfo', 'String')]
    [alias('gti')]

    param(
        [Parameter(Position = 0)]
        [ValidateNotNullOrEmpty()]
        #limit this to no more than 5 locations
        [System.Collections.Specialized.OrderedDictionary]$Locations = [ordered]@{
            Singapore = 'Singapore Standard Time';
            Seattle   = 'Pacific Standard Time';
            Stockholm = 'Central Europe Standard Time';
        },
        [ValidateNotNullOrEmpty()]
        [string]$HomeTimeZone = 'Eastern Standard Time',

        [Parameter(HelpMessage = 'Specify the datetime value to use. The default is now.')]
        [ValidateNotNullOrEmpty()]
        [datetime]$DateTime = $(Get-Date),

        #Display the results as a formatted table. This parameter has an alias of ft.
        [Alias('ft')]
        [switch]$AsTable,

        #Display the results as a formatted list. This parameter has an alias of fl.
        [Alias('fl')]
        [switch]$AsList
    )

    #tags are used for categorizing the command
    #cmdTags = time
    Write-Verbose "Starting $($MyInvocation.MyCommand)"
    Write-Verbose "Running under PowerShell version $($PSVersionTable.PSVersion)"

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

    $hash.add('IsDaylightSavings', $now.IsDaylightSavingTime())

    $tObj = New-Object -TypeName PSObject -Property $hash
    $tObj.PSObject.TypeNames.insert(0, 'myTimeInfo')

    $cities = $tObj.PSObject.properties.where( { $_.name -notmatch 'utc|now' }).Name
    if ($AsTable) {
        Write-Verbose 'Formatting output as a table'
        $tObj | Format-Table -GroupBy @{Name = 'Now'; expression = { "$($_.Now) `n   UTC: $($_.utc)" } } -Property $cities | Out-String
    }
    elseif ($AsList) {
        Write-Verbose 'Formatting output as a list'
        $tObj | Format-List -GroupBy @{Name = 'Now'; expression = { "$($_.Now) `n   UTC: $($_.utc)" } } -Property $cities | Out-String
    }
    else {
        Write-Verbose 'Writing object to the pipeline'
        $tObj
    }

    Write-Verbose "Ending $($MyInvocation.MyCommand)"
} #end function

#endregion
#EOF
