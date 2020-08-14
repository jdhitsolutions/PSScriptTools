
Function Get-MyAlias {
    [cmdletbinding()]
    [alias("gma")]
    [OutputType([System.Management.Automation.AliasInfo])]
    Param(
        [Parameter(HelpMessage = "Only show aliases that DO NOT belong to a module.")]
        [switch]$NoModule
    )
    Begin {
        Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] Starting $($myinvocation.mycommand)"
        $DefaultAliases = $($host.Runspace).InitialSessionState.commands.where( {$_.commandtype -eq 'alias'}).name
        Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] Detected $($defaultAliases.count) initial aliases."
    } #begin

    Process {
        Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Getting all aliases not part of the initial session."
        if ($NoModule) {
            Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Filtering out aliases that belong to a module."
            (Get-Alias).Where( {($DefaultAliases -notcontains $_.name) -AND (-Not $_.Source)})
        }
        else {
            (Get-Alias).Where({$DefaultAliases -notcontains $_.name})
        }
    } #process

    End {
        Write-Verbose "[$((Get-Date).TimeofDay) END    ] Ending $($myinvocation.mycommand)"
    } #end

} #close Get-MyAlias
