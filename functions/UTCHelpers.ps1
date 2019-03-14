
# set of functions for converting times to and from Universal time

Function ConvertTo-UTCTime {
    [cmdletbinding()]
    [alias("tout")]
    [outputtype([Datetime])]
    Param(
        [Parameter(ValueFromPipeline, HelpMessage = "Enter a Datetime value")]
        [ValidateNotNullOrEmpty()]
        [datetime]$DateTime = $(Get-Date)
    )
    Begin {
        Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] Starting $($myinvocation.mycommand)"

    } #begin

    Process {
        Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Converting $DateTime to UTC"
        $datetime.ToUniversalTime()

    } #process

    End {
        Write-Verbose "[$((Get-Date).TimeofDay) END    ] Ending $($myinvocation.mycommand)"

    } #end

} #close ConvertTo-UTCTime

Function ConvertFrom-UTCTime {
    [cmdletbinding()]
    [alias("frut")]
    [outputtype([datetime])]

    Param(
        [Parameter(Mandatory, HelpMessage = "Enter a Universal Datetime value", ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [datetime]$DateTime
    )
    Begin {
        Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] Starting $($myinvocation.mycommand)"
    } #begin

    Process {
        Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Converting $DateTime UTC to local time"
        $DateTime.ToLocalTime()
    } #process

    End {
        Write-Verbose "[$((Get-Date).TimeofDay) END    ] Ending $($myinvocation.mycommand)"
    } #end

} #close ConvertFrom-UTCTime

Function ConvertTo-LocalTime {
    [cmdletbinding()]
    [alias("clt")]
    [outputtype("DateTime")]
    Param(
        [Parameter(Position = 0, Mandatory, HelpMessage = "Enter a non local date time")]
        [datetime]$Datetime,
        [Parameter(Position = 1, Mandatory, HelpMessage = "Enter the location's' UTC Offset")]
        [Alias("offset")]
        [timespan]$UTCOffset
    )
    Begin {
        Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] Starting $($myinvocation.mycommand)"
    } #begin

    Process {
        Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Converting $Datetime (UTC $UTCOffset) to local time "
        $u = ($Datetime).addminutes( - ($UTCOffset.TotalMinutes))
        Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] UTC is $u"
        $u.ToLocalTime()
    } #process

    End {
        Write-Verbose "[$((Get-Date).TimeofDay) END    ] Ending $($myinvocation.mycommand)"
    } #end

} #close ConvertTo-LocalTime