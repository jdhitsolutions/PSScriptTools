Function Get-ModuleCommand {
    [cmdletbinding(DefaultParameterSetName = "name")]
    [Alias("gmc")]
    [OutputType("ModuleCommand")]

    Param(
        [Parameter(
            Position = 0,
            Mandatory,
            HelpMessage = "The name of an installed module",
            ParameterSetName = "name",
            ValueFromPipelineByPropertyName
        )]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [Parameter(
            Mandatory,
            HelpMessage = "The fully qualified name of an installed module",
            ParameterSetName = "fqdn"
        )]
        [ValidateNotNullOrEmpty()]
        [Microsoft.PowerShell.Commands.ModuleSpecification]$FullyQualifiedName,

        [switch]$ListAvailable
    )

    Begin {
        Write-Verbose "Starting $($MyInvocation.MyCommand)"
        $PSBoundParameters.Add("ErrorAction", "stop")
    }

    Process {
        #getting commands directly from the module because for some unknown reason,
        #probably scope related, when using Get-Command alone to list commands in the module,
        #it includes private functions

        Try {
            Write-Verbose "Listing all matching modules"
            Write-Verbose "Using bound parameters"
            $PSBoundParameters | Out-String | Write-Verbose

            #get newest version of the module
            $mod = Get-Module @PSBoundParameters | Select-Object -First 1
            Write-Verbose "Found $($mod.count) modules"
            if (-not $mod) {
                Throw "Failed to find a matching module. Try again using the -ListAvailable parameter."
            }
            #get prerelease from private data
            if ($mod.PrivateData -and $mod.PrivateData.ContainsKey('PSData') -and $mod.PrivateData.PSData.ContainsKey('PreRelease')) {
                $prerelease = $mod.PrivateData.PSData.PreRelease
            }
            else {
                $prerelease = $null
            }
        } #try
        Catch {
            Write-Verbose "This is weird. There was an exception!"
            Throw $_
            #Bail out
            return
        }

        if ($PSCmdlet.parameterSetName -eq 'name' -AND $mod.count -gt 1) {
            #make sure to get the latest version
            Write-Verbose "Getting the latest version of $($mod[0].name)"
            $mod = $mod | Sort-Object -Property Version -Descending | Select-Object -First 1
        }

        Write-Verbose "Using version $($mod.version)"

        $cmds = @()
        Write-Verbose "Getting exported functions"
        $cmds += $mod.ExportedFunctions.keys | Get-Command
        Write-Verbose "Getting exported cmdlets"
        $cmds += $mod.ExportedCmdlets.keys | Get-Command

        Write-Verbose "Found $($cmds.count) functions and/or cmdlets"

        $out = foreach ($cmd in $cmds) {
            Write-Verbose "Processing $($cmd.name)"
            #get aliases, ignoring errors for those commands without one
            $alias = (Get-Alias -Definition $cmd.Name -ErrorAction SilentlyContinue).name

            #it is assumed you have updated help
            [PSCustomObject]@{
                PSTypeName = "ModuleCommand"
                Name       = $cmd.name
                Alias      = $alias
                Verb       = $cmd.verb
                Noun       = $cmd.noun
                Synopsis   = (Get-Help $cmd.name).synopsis.trim()
                Type       = $cmd.CommandType
                Version    = $cmd.version
                Help       = $cmd.HelpUri
                ModuleName = $mod.name
                Compatible = $mod.CompatiblePSEditions
                PSVersion  = $mod.PowerShellVersion
            }
        } #foreach cmd

    #display results sorted by name for better formatting
    $out | Sort-Object -Property Name
}
End {
    Write-Verbose "Ending $($MyInvocation.MyCommand)"
}

} #close function

Register-ArgumentCompleter -CommandName Get-ModuleCommand -ParameterName Name -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)

    (Get-Module -Name "$WordToComplete*").name |
    ForEach-Object {
        [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
    }
}