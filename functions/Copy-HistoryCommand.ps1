#requires -version 5.1
#requires -module PSReadline

Function Copy-HistoryCommand {
<#
.SYNOPSIS
    Copy a history command line to the clipboard.
.DESCRIPTION
    You can use this command to copy the commandline from a given PowerShell
    history item to the clipboard. The default item will the be last history
    item. Once copied, you can paste into your following prompt to edit and/or
    re-run.

    Linux platforms require the xclip utility to be in the path.

    Lee Holmes has a similar function called Copy-History in the PowerShell
    Cookbook that lets you copy a range of history commands to the clipboard.
.EXAMPLE
    PS C:\> Copy-HistoryCommand

    Copy the last command to the clipboard.
.EXAMPLE
    PS C:\> Copy-HistoryCommand 25 -passthru
    get-process -computername $computer | sort ws -Descending | select -first 3

    Copy the command from history item 25 to the clipboard and also pass it to the pipeline.
.EXAMPLE
    PS C:\> $c = [scriptblock]::Create($(Copy-HistoryCommand 25 -passthru))

    This copies the command from history item 25 and turns it into a scriptblock.

    PS C:\> &$c

    Handles  NPM(K)    PM(K)      WS(K) VM(M)   CPU(s)     Id  SI ProcessName
    -------  ------    -----      ----- -----   ------     --  -- -----------
      10414   12744   488164     461596 ...76            3128   0 dns
        581      67   171868     141620 ...82            3104   0 MsMpEng
        678      48   118132      89572   840            7180   0 ServerManager

    Invoke the scriptblock.

.PARAMETER ID
    The history ID number. The default is the last command.
.PARAMETER Passthru
    Use this parameter if you also want to see the command as well as copy it to the clipboard.
.INPUTS
    [int]
.OUTPUTS
    [string]
.NOTES
    Learn more about PowerShell:
    http://jdhitsolutions.com/blog/essential-powershell-resources/

.LINK
Get-History
#>

[CmdletBinding(SupportsShouldProcess)]
[alias("ch")]
[outputtype("None","string")]
Param(
    [Parameter(Position=0)]
    [ValidateNotNullOrEmpty()]
    [int]$ID = $(Get-History).Count,
    [switch]$Passthru)

Begin {
    Write-Verbose "[BEGIN  ] Starting: $($MyInvocation.Mycommand)"
    } #begin

Process {
    Write-Verbose "[PROCESS] Getting commandline from history item: $id"
    $cmdstring = (Get-History -id  $id).CommandLine
    If ($PSCmdlet.ShouldProcess("ID #$id [$cmdstring]")) {
        $cmdstring | Microsoft.PowerShell.Management\Set-Clipboard

        If ($Passthru) {
            #write the command to the pipeline
            $cmdstring
        } #If passthru
    }
} #process

End {
    Write-Verbose "[END    ] Ending: $($MyInvocation.Mycommand)"
} #end

} #close function


Register-ArgumentCompleter -CommandName Copy-HistoryCommand -ParameterName Id -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)

    #PowerShell code to populate $wordtoComplete
    Get-History | Where-object {$_.id -like "$wordtocomplete*"} |
    ForEach-Object {
            # completion text,listitem text,result type,Tooltip
            [System.Management.Automation.CompletionResult]::new($_.id, $_.id, 'ParameterValue', $_.commandline)
        }
}