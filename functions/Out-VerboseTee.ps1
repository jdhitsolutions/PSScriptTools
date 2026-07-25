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
        #tags are used for categorizing the command
        #cmdTags = general,scripting
        #inherit verbose preference
        $VerbosePreference = $PSCmdlet.GetVariableValue("VerbosePreference")
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
#EOF
