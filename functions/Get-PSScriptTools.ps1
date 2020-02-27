#display a summary of tools in this module
#I am deviating slightly from the singular noun naming convention because I am thinking of
#PSScriptTools as a singular thing, like a toolbox.
Function Get-PSScriptTools {
    [cmdletbinding()]
    [OutputType("PSScriptTool")]
    Param()

    Write-Verbose "Starting $($myinvocation.mycommand)"

    #getting commands directly from the module because for some unknown reason,
    #probably scope related, when using Get-Command alone to list commands in the module,
    #it includes private functions
    $mod = Get-Module -name PSScriptTools

    $funs =$mod.ExportedFunctions.keys | Get-Command

    Write-Verbose "Found $($funs.count) functions"

    foreach ($fun in $funs) {
        Write-Verbose "Processing $($fun.name)"
        #get aliases, ignoring errors for those commands without one
        $alias = (Get-Alias -definition $fun.Name -erroraction silentlycontinue).name

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