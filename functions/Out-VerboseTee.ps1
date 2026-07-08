Function Out-VerboseTee {
    [CmdletBinding()]
    [alias("tv", "Tee-Verbose")]
    Param(
        [Parameter(Position = 0, Mandatory)]
        [string]$Path,
        [Parameter(Mandatory, ValueFromPipeline)]
        [object]$Value,
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
            ($Value | Out-String).Trim() | Write-Verbose
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
        $VerbosePreference = "SilentlyContinue"
    }
} #close Out-VerboseTee