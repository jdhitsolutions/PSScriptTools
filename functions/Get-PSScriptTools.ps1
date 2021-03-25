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
    $thisCmd = Get-Command $myinvocation.MyCommand
    $thisModule =  $thisCmd.Source
    $thisVersion = $thisCmd.version.tostring()
    Write-Verbose "Using version $thisVersion"

    $PSBoundParameters.Module = $thisModule

    Write-Verbose "Using these bound parameters"
    $PSBoundParameters | Out-String | Write-Verbose

    <#
$h = @"
___ ___ ___        _      _  _____        _
| _ \ __/ __|__ _ _(_)_ __| |__   _|__ ___| |___
|  _\__ \__ \ _| '_| | '_ \  _|| |/ _ \ _ \ (_-<
|_| |___/___\__|_| |_| .__/\__||_|\___\___/_/__/
|_|

"@
    #>
    #ignore and suppress errors to create the ASCII art since this is optional and decorative only
    $h = ConvertTo-ASCIIArt $thisModule -font small -ErrorAction SilentlyContinue
    $h+= "`n"
    $h += ConvertTo-ASCIIArt $thisVersion -Font small -ErrorAction SilentlyContinue

    if ($host.name -match "console") {
        "$([char]0x1b)[1;38;5;177m$h$([char]0x1b)[0m" | Write-Host
    }
    else {
        Write-Host $h
    }
    #Write-Host $h -ForegroundColor Yellow

    Write-Verbose "Getting exported functions from $thisModule"
    #Using Get-Module instead of Get-Command -module which wants to include private functions
    $funs = ((Get-Module $thismodule).exportedfunctions).keys

    if ($Verb) {
       $funs = $funs.where{$_ -match "^$Verb\-"}
    }

    Write-Verbose "Found $($funs.count) functions matching your criteria"

    #get all aliases once
    $allAliases = Get-Alias

    foreach ($fun in $funs) {
        Write-Verbose "Processing $fun"
        #find a matching alias
        $alias = $allAliases.where({$_.referencedcommand.name -eq $fun}).name
        Write-Verbose "Detected alias $alias"

        [pscustomobject]@{
            PSTypeName = "PSScriptTool"
            Name       = $fun
            Alias      = $alias
            Verb       = $fun.split("-")[0]
            Synopsis   = (Get-Help $fun).synopsis
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