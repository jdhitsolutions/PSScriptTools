Function Write-Detail {
    [cmdletbinding(DefaultParameterSetName = "Default")]
    Param(
        [Parameter(Position = 0, Mandatory)]
        [Parameter(ParameterSetName = "Default")]
        [Parameter(ParameterSetName = "Date")]
        [Parameter(ParameterSetName = "Time")]
        [ValidateNotNullOrEmpty()]
        [string]$Message,

        [Parameter(ParameterSetName = "Default")]
        [Parameter(ParameterSetName = "Date")]
        [Parameter(ParameterSetName = "Time")]
        [string]$Prefix = "PROCESS",

        [Parameter(ParameterSetName = "Date")]
        [switch]$Date,
        [Parameter(ParameterSetName = "Time")]
        [Switch]$Time
    )

    #$pfx = $($Prefix.ToUpper()).PadRight("process".length)
    if ($time) {
        $dt = (Get-Date -Format "hh:mm:ss:ffff")
    }
    elseif ($Date) {
        $dt = "{0} {1}" -f (Get-Date).ToShortDateString(), (Get-Date -Format "hh:mm:ss")
    }

    if ($PSCmdlet.ParameterSetName -eq 'Default') {
        $Text = "[$($prefix.ToUpper())] $Message"
    }
    else {
        $Text = "$dt [$($prefix.ToUpper())] $Message"
    }
    $Text

} #close Write-Detail



