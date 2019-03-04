
# set of functions for converting times to and from Universal time

Function ConvertTo-UTCTime {
    [cmdletbinding()]
    [alias("tout")]
    [outputtype([Datetime])]
    Param(
        [Parameter(ValueFromPipeline,HelpMessage = "Enter a Datetime value")]
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
        [Parameter(Mandatory,HelpMessage = "Enter a Universal Datetime value",ValueFromPipeline)]
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