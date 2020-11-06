#display a summary of tools in this module
#I am deviating slightly from the singular noun naming convention because I am thinking of
#PSScriptTools as a singular thing, like a toolbox.
Function Get-PSScriptTools {
    [cmdletbinding()]
    [OutputType("PSScriptTool")]
    Param(
        [Parameter(HelpMessage = "Filter commands based on a standard verb.")]
        [string]$Verb
    )

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
    Write-Verbose "Getting the PSScriptTools module"
    $mod = Get-Module -Name PSScriptTools

    Write-Verbose "Using version $($mod.version)"
    Write-Verbose "Getting exported functions"
    $funs = $mod.ExportedFunctions.keys | Get-Command

    if ($verb) {
        Write-Verbose "Filtering on verb $Verb"
        $funs = $funs.where({$_.verb -eq $verb})
    }
    Write-Verbose "Found $($funs.count) functions"

    foreach ($fun in $funs) {
        Write-Verbose "Processing $($fun.name)"
        #get aliases, ignoring errors for those commands without one
        $alias = (Get-Alias -Definition $fun.Name -ErrorAction silentlycontinue).nameget

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

#define an argumentcompleter for the Verb parameter
Register-ArgumentCompleter -CommandName Get-PSScriptTools -ParameterName Verb -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)

    #PowerShell code to populate $wordtoComplete
    Get-Verb | Where-object {$_.verb -like "$wordtocomplete*"} |
        ForEach-Object {
            # completion text,listitem text,result type,Tooltip
            [System.Management.Automation.CompletionResult]::new($_.verb, $_.verb, 'ParameterValue', $_.group)
        }
}