#display a summary of tools in this module
#I am deviating slightly from the singular noun naming convention because I am thinking of
#PSScriptTools as a singular thing, like a toolbox.
Function Get-PSScriptTools {
    [cmdletbinding()]
    [OutputType("PSScriptTool")]
    Param()

    Write-Verbose "Starting $($myinvocation.mycommand)"

    $h = @"
 ___ ___ ___        _      _  _____        _
| _ \ __/ __|__ _ _(_)_ __| |__   _|__ ___| |___
|  _\__ \__ \ _| '_| | '_ \  _|| |/ _ \ _ \ (_-<
|_| |___/___\__|_| |_| .__/\__||_|\___\___/_/__/
                     |_|
"@
    "$([char]0x1b)[1;38;5;177m$h$([char]0x1b)[0m" | write-host
   #Write-Host $h -ForegroundColor Yellow

    #getting commands directly from the module because for some unknown reason,
    #probably scope related, when using Get-Command alone to list commands in the module,
    #it includes private functions
    $mod = Get-Module -Name PSScriptTools

    $funs = $mod.ExportedFunctions.keys | Get-Command

    Write-Verbose "Found $($funs.count) functions"

    foreach ($fun in $funs) {
        Write-Verbose "Processing $($fun.name)"
        #get aliases, ignoring errors for those commands without one
        $alias = (Get-Alias -Definition $fun.Name -ErrorAction silentlycontinue).name

        [pscustomobject]@{
            PSTypeName = "PSScriptTool"
            Name       = $fun.name
            Alias      = $alias
            Verb       = $fun.verb
            Synopsis   = (Get-Help $fun.name).synopsis
            Version    = $fun.version
        }
    }

    Write-Verbose "Ending $($myinvocation.mycommand)"
}