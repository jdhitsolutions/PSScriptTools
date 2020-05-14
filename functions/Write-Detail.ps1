Function Write-Detail {
    [cmdletbinding(DefaultParameterSetName = "Default")]
    Param(
        [Parameter(Position = 0, Mandatory)]
        [Parameter(ParameterSetName = "Default")]
        [Parameter(ParameterSetName = "Date")]
        [Parameter(ParameterSetName = "Time")]
        [ValidateNotNullorEmpty()]
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
        $Text = "$dt [$($prefix.toUpper())] $Message"
    }
    $Text

} #close Write-Detail

Function Out-VerboseTee {
    [CmdletBinding()]
    [alias("Tee-Verbose","tv")]
    Param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [object]$Value,
        [Parameter(Position = 0, Mandatory)]
        [string]$Path,
        [System.Text.Encoding]$Encoding,
        [switch]$Append
    )
    Begin {
        #turn on verbose pipeline since if you are running this command you intend for it to be on
        $VerbosePreference = "continue"
    }
    Process {
        #only run if Verbose is turned on
        if ($VerbosePreference -eq "continue") {
            $Value | Out-String | Write-Verbose
            [void]$PSBoundParameters.Remove("Append")
            if ($Append) {
                Add-Content @PSBoundParameters
            }
            else {
                Set-Content @PSBoundParameters
            }
        }
    }
    End {
        $VerbosePreference = "silentlycontinue"
    }
} #close Out-VerboseTee

