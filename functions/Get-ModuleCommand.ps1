Function Get-ModuleCommand {
    [cmdletbinding(DefaultParameterSetName = "name")]
    [Alias("gmc")]
    [OutputType("ModuleCommand")]

    Param(
        [Parameter(
            Position = 0,
            Mandatory,
            HelpMessage = "The name of an installed module",
            ParameterSetName = "name"
        )]
        [ValidateNotNullorEmpty()]
        [string]$Name,

        [Parameter(
            Mandatory,
            HelpMessage = "The fully qualified name of an installed module",
            ParameterSetName = "fqdn"
        )]
        [ValidateNotNullorEmpty()]
        [Microsoft.PowerShell.Commands.ModuleSpecification]$FullyQualifiedName,

        [switch]$ListAvailable
    )

    Write-Verbose "Starting $($myinvocation.mycommand)"

    #getting commands directly from the module because for some unknown reason,
    #probably scope related, when using Get-Command alone to list commands in the module,
    #it includes private functions

    $psboundParameters.Add("ErrorAction", "stop")
    Try {
        Write-Verbose "Listing all matching modules"
        Write-Verbose "Using bound parameters"
        $PSBoundParameters | Out-String | Write-Verbose
        $mod = Get-Module @PSBoundParameters
        Write-Verbose "Found $($mod.count) modules"
        if (-not $mod) {
            Throw "Failed to find a matching module. Try again using the -ListAvailable parameter."
        }
    }
    Catch {
        write-verbose "This is weird. There was an exception!"
        Throw $_
        #Bail out
        return
    }

    if ($pscmdlet.parameterSetName -eq 'name' -AND $mod.count -gt 1) {
        #make sure to get the latest version
        Write-Verbose "Getting the latest version of $($mod[0].name)"
        $mod = $mod | Sort-Object -property Version -Descending | Select-Object -first 1
    }

    Write-Verbose "Using version $($mod.version)"

    $cmds = @()
    Write-Verbose "Getting exported functions"
    $cmds += $mod.Exportedfunctions.keys | Get-Command
    Write-Verbose "Getting exported cmdlets"
    $cmds += $mod.Exportedcmdlets.keys | Get-Command

    Write-Verbose "Found $($cmds.count) functions and/or cmdlets"

    $out = foreach ($cmd in $cmds) {
        Write-Verbose "Processing $($cmd.name)"
        #get aliases, ignoring errors for those commands without one
        $alias = (Get-Alias -definition $cmd.Name -erroraction silentlycontinue).name

        #it is assumed you have updated help
        [pscustomobject]@{
            PSTypeName = "ModuleCommand"
            Name       = $cmd.name
            Alias      = $alias
            Verb       = $cmd.verb
            Noun       = $cmd.noun
            Synopsis   = (Get-Help $cmd.name).synopsis.trim()
            Type       = $cmd.CommandType
            Version    = $cmd.version
            ModuleName = $mod.name
        }
    }

    #display results sorted by name for better formatting
    $out | Sort-Object -Property Name

    Write-Verbose "Ending $($myinvocation.mycommand)"
}

Register-ArgumentCompleter -CommandName Get-ModuleCommand -ParameterName Name -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)

    (Get-Module -Name "$wordtoComplete*").name |
        foreach-object {
        # completion text,listitem text,result type,Tooltip
        [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
    }
}