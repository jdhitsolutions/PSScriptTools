
function Get-MyAlias {
    [cmdletbinding()]
    [alias('gma')]
    [OutputType([System.Management.Automation.AliasInfo])]
    param(
        [Parameter(HelpMessage = 'Specify an alias by name')]
        [ValidateNotNullOrEmpty()]
        [SupportsWildcards()]
        [string]$Name = '*',

        [Parameter(HelpMessage = 'Only show aliases that DO NOT belong to a module.')]
        [switch]$NoModule
    )
    begin {
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Starting $($MyInvocation.MyCommand)"

        #Get initial aliases
        $ps = [powershell]::Create()
        [void]$ps.commands.AddCommand('Get-Alias')
        $DefaultAliases = $ps.invoke()
        $ps.Dispose()

        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Detected $($defaultAliases.count) initial aliases."

        #get defined aliases from my commonly used modules
        $moduleList = "Microsoft.Powershell.PSResourceGet","Microsoft.PowerShell.ConsoleGuiTools","CimCmdlets",
        "Hyper-V","PSReadline","Pester"
        $moduleAliases = (Get-Command -mod $moduleList -CommandType Alias )
        Write-Information $moduleAliases -Tags ModuleAliases
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Adding $($moduleAliases.count) module defined aliases"
        $DefaultAliases += $moduleAliases
        Write-Information $DefaultAliases -Tags DefaultAliases
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Looking for aliases matching the name pattern $Name"
    } #begin

    process {
        Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Getting all aliases that are NOT part of the initial session."
        if ($NoModule) {
            Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Filtering out aliases that belong to a module."
            (Get-Alias -Name $Name -OutVariable defined).Where( {($DefaultAliases.Name -notcontains $_.name) -and (-not $_.Source) })
        }
        else {
            (Get-Alias -Name $Name -OutVariable defined).Where({ $DefaultAliases.Name -notcontains $_.name })
        }
        Write-Information $defined -Tags DefinedAliases
    } #process

    end {
        Write-Verbose "[$((Get-Date).TimeOfDay) END    ] Ending $($MyInvocation.MyCommand)"
    } #end

} #close Get-MyAlias

