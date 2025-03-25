Function Get-ModuleCommand {
    [cmdletbinding(DefaultParameterSetName = "name")]
    [Alias("gmh")]
    [OutputType("ModuleCommand")]

    Param(
        [Parameter(
            Position = 0,
            HelpMessage = "The name of an installed/available module",
            ValueFromPipelineByPropertyName
        )]
        [SupportsWildcards()]
        [string]$Name,

        [Parameter(
            HelpMessage = "Command name to search for"
        )]
        [SupportsWildcards()]
        [string]$CommandName,

        [switch]$ListAvailable
    )

    Begin {
        Write-Verbose "Starting $($MyInvocation.MyCommand)"
        $PSBoundParameters.Add("ErrorAction", "stop")

        #region local functions
        function getModuleInfo {
            [cmdletbinding()]
            param(
                $module,
                $CommandName
            )
            Write-Verbose "Using version $($module.version)"

            $cmds = @()
            Write-Verbose "Getting exported functions"
            $cmds += $module.Exportedfunctions.keys | Where-Object { $_ -like "$CommandName" } | Get-Command
            Write-Verbose "Getting exported cmdlets"
            $cmds += $module.Exportedcmdlets.keys | Where-Object { $_ -like "$CommandName" } | Get-Command

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
                    Synopsis   = (Get-Help $cmd.name -ShowWindow:$false).synopsis.trim()
                    Type       = $cmd.CommandType
                    Version    = $cmd.version
                    Help       = $cmd.HelpUri
                    ModuleName = $module.name
                    ModulePath = $module.Path
                    Compatible = $module.CompatiblePSEditions
                    PSVersion  = $module.PowerShellVersion
                }
            } #foreach cmd

            $out
        }
        #endregion
    }

    Process {
        If ([string]::IsNullOrEmpty($Name) -and [string]::IsNullOrEmpty($CommandName)) {
            if ($ListAvailable) {
                $out = Get-Module -ListAvailable | ForEach-Object {
                    [PSCustomObject]@{
                        PSTypeName = "ModuleCommand"
                        Name       = $_.name
                        Alias      = ""
                        Verb       = ""
                        Noun       = ""
                        Synopsis   = $_.Description
                        Type       = $null
                        Version    = $_.version
                        Help       = $_.HelpInfoUri
                        ModuleName = "Available Modules"
                        ModulePath = $_.Path
                        Compatible = $_.CompatiblePSEditions
                        PSVersion  = $_.PowerShellVersion
                    }
                }
            }
            else {
                $out = Get-InstalledModule | ForEach-Object {
                    [PSCustomObject]@{
                        PSTypeName = "ModuleCommand"
                        Name       = $_.name
                        Alias      = ""
                        Verb       = ""
                        Noun       = ""
                        Synopsis   = $_.Description
                        Type       = $null
                        Version    = $_.version
                        Help       = $_.HelpInfoUri
                        ModuleName = "Installed Modules"
                        ModulePath = $_.Path
                        Compatible = $_.CompatiblePSEditions
                        PSVersion  = $_.PowerShellVersion
                    }
                }
            }
        }
        else {
            if ([string]::IsNullOrEmpty($CommandName)) { $CommandName = "*" }
            if ([string]::IsNullOrEmpty($Name)) { $Name = "*" }

            if ($ListAvailable) {
                $out = Get-Module -Name $Name -ListAvailable | ForEach-Object {
                    #We need to rebind to object (reason unknown!!)
                    getModuleInfo -module $_ -CommandName $CommandName
                }
            }
            else {
                $out = Get-Module -Name $Name | ForEach-Object {
                    getModuleInfo -module $_ -CommandName $CommandName
                }
            }
        }

        #display results sorted by name for better formatting
        $out | Sort-Object -Property ModuleName, Name
    }
    End {
        Write-Verbose "Ending $($MyInvocation.MyCommand)"
    }

} #close function

Register-ArgumentCompleter -CommandName Get-ModuleCommand -ParameterName Name -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)

    (Get-Module -Name "$wordtoComplete*").name |
    ForEach-Object {
        # completion text,listitem text,result type,Tooltip
        [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
    }
}