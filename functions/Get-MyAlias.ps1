
Function Get-MyAlias {
    [cmdletbinding()]
    [alias("gma")]
    [OutputType([System.Management.Automation.AliasInfo])]
    Param(
        [Parameter(HelpMessage = "Only show aliases that DO NOT belong to a module.")]
        [switch]$NoModule
    )
    Begin {
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Starting $($MyInvocation.MyCommand)"
        $DefaultAliases = $($host.Runspace).InitialSessionState.commands.where( {$_.commandtype -eq 'alias'}).name
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Detected $($defaultAliases.count) initial aliases."
    } #begin

    Process {
        Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Getting all aliases not part of the initial session."
        if ($NoModule) {
            Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Filtering out aliases that belong to a module."
            (Get-Alias).Where( {($DefaultAliases -NotContains $_.name) -AND (-Not $_.Source)})
        }
        else {
            (Get-Alias).Where({$DefaultAliases -NotContains $_.name})
        }
    } #process

    End {
        Write-Verbose "[$((Get-Date).TimeOfDay) END    ] Ending $($MyInvocation.MyCommand)"
    } #end

} #close Get-MyAlias
