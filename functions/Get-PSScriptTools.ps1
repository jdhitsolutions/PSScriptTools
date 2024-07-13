#display a summary of tools in this module
#I am deviating slightly from the singular noun naming convention because I am thinking of
#PSScriptTools as a singular thing, like a toolbox.
Function Get-PSScriptTools {
    [cmdletbinding()]
    [OutputType('PSScriptTool')]
    Param(
        [Parameter(HelpMessage = 'Filter commands based on a standard verb.')]
        [string]$Verb
    )

    Write-Verbose "Starting $($MyInvocation.MyCommand)"
    $thisCmd = Get-Command $MyInvocation.MyCommand
    $ThisModule = $thisCmd.Source
    $thisVersion = $thisCmd.version.ToString()
    Write-Verbose "Using version $thisVersion"

    $h = @"
___ ___ ___         _      _  _____        _
| _ \ __/ __|__ _ _(_)_ __| |__   _|__ ___| |___
|  _\__ \__ \ _| '_| | '_ \  _|| |/ _ \ _ \ (_-<
|_| |___/___\__|_| |_|_.__/\__||_|\___\___/_/__/
|_|                  |_|
v$ThisVersion
"@


    #ConvertTo-ASCIIArt has been removed from the module 4/4/2022
    #ignore and suppress errors to create the ASCII art since this is optional and decorative only
    #$h = ConvertTo-ASCIIArt $ThisModule -font small -ErrorAction SilentlyContinue
    # $h+= "`n"
    #$h += ConvertTo-ASCIIArt $thisVersion -Font small -ErrorAction SilentlyContinue

    if ($host.name -match 'console|code') {
        "$([char]27)[1;38;5;177m$h$([char]27)[0m" | Write-Host
    }
    else {
        Write-Host $h
    }

    #Write-Host $h -ForegroundColor Yellow

    Write-Verbose "Getting PSScriptTool data $ThisModule"
    $ModuleFunctions = Get-Content -path $ToolDataPath | ConvertFrom-Json
    if ($Verb) {
        $ModuleFunctions = $ModuleFunctions.where{ $_.verb -match $Verb }
        Write-Verbose "Found $($ModuleFunctions.count) functions matching your criteria"
    }


    foreach ($fun in $ModuleFunctions) {

        [PSCustomObject]@{
            PSTypeName = 'PSScriptTool'
            Name       = $fun.Name
            Alias      = $fun.Alias
            Verb       = $fun.verb #$fun.split("-")[0]
            Synopsis   = $fun.Synopsis
            Version    = $fun.version -as [version]
        }
    }

    Write-Verbose "Ending $($MyInvocation.MyCommand)"
}

#define an argument completer for the Verb parameter
Register-ArgumentCompleter -CommandName Get-PSScriptTools -ParameterName Verb -ScriptBlock {
    param($commandName, $parameterName, $WordToComplete, $commandAst, $fakeBoundParameter)

    #PowerShell code to populate $WordToComplete
    Get-Verb | Where-Object { $_.verb -like "$WordToComplete*" } |
    ForEach-Object {
        [System.Management.Automation.CompletionResult]::new($_.verb, $_.verb, 'ParameterValue', $_.group)
    }
}

<#
Previous version
Function Get-PSScriptTools {
    [cmdletbinding()]
    [OutputType('PSScriptTool')]
    Param(
        [Parameter(HelpMessage = 'Filter commands based on a standard verb.')]
        [string]$Verb
    )

    Write-Verbose "Starting $($MyInvocation.MyCommand)"
    $thisCmd = Get-Command $MyInvocation.MyCommand
    $ThisModule = $thisCmd.Source
    $thisVersion = $thisCmd.version.ToString()
    Write-Verbose "Using version $thisVersion"

    $PSBoundParameters.Module = $ThisModule

    Write-Verbose 'Using these bound parameters'
    $PSBoundParameters | Out-String | Write-Verbose


    $h = @"
___ ___ ___         _      _  _____        _
| _ \ __/ __|__ _ _(_)_ __| |__   _|__ ___| |___
|  _\__ \__ \ _| '_| | '_ \  _|| |/ _ \ _ \ (_-<
|_| |___/___\__|_| |_|_.__/\__||_|\___\___/_/__/
|_|                  |_|
v$ThisVersion
"@


    #ConvertTo-ASCIIArt has been removed from the module 4/4/2022
    #ignore and suppress errors to create the ASCII art since this is optional and decorative only
    #$h = ConvertTo-ASCIIArt $ThisModule -font small -ErrorAction SilentlyContinue
    # $h+= "`n"
    #$h += ConvertTo-ASCIIArt $thisVersion -Font small -ErrorAction SilentlyContinue

    if ($host.name -match 'console|code') {
        "$([char]27)[1;38;5;177m$h$([char]27)[0m" | Write-Host
    }
    else {
        Write-Host $h
    }

    #Write-Host $h -ForegroundColor Yellow

    Write-Verbose "Getting exported functions from $ThisModule"
    #Using Get-Module instead of Get-Command -module which wants to include private functions
    $ModuleFunctions = ((Get-Module $ThisModule).ExportedFunctions).values

    if ($Verb) {
        $ModuleFunctions = $ModuleFunctions.where{ $_.verb -match $Verb }
    }

    Write-Verbose "Found $($ModuleFunctions.count) functions matching your criteria"

    #get all aliases once
    $allAliases = Get-Alias

    foreach ($fun in $ModuleFunctions) {
        Write-Verbose "Processing $fun"
        #find a matching alias
        $alias = $allAliases.where({ $_.ReferencedCommand.name -eq $fun }).name
        Write-Verbose "Detected alias $alias"

        [PSCustomObject]@{
            PSTypeName = 'PSScriptTool'
            Name       = $fun
            Alias      = $alias
            Verb       = $fun.verb #$fun.split("-")[0]
            Synopsis   = (Get-Help $fun.name).synopsis
            Version    = $fun.version
        }
    }

    Write-Verbose "Ending $($MyInvocation.MyCommand)"
}
#>