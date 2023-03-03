Function Copy-HistoryCommand {

    [CmdletBinding(SupportsShouldProcess)]
    [alias("ch")]
    [OutputType("None", "System.String")]
    Param(
        [Parameter(Position = 0)]
        [ValidateNotNullOrEmpty()]
        [int[]]$ID = $(Get-History).Count,
        [switch]$PassThru)

    Begin {
        Write-Verbose "[BEGIN  ] Starting: $($MyInvocation.MyCommand)"
    } #begin

    Process {
        $idString = $id -join ','
        Write-Verbose "[PROCESS] Getting command line from history item: $idstring"
        $cmdstring = (Get-History -Id $($id)).CommandLine
        If ($PSCmdlet.ShouldProcess("ID #$idstring")) {
            $cmdstring | Microsoft.PowerShell.Management\Set-Clipboard

            If ($PassThru) {
                #write the command to the pipeline
                $cmdstring
            } #If PassThru
        }
    } #process

    End {
        Write-Verbose "[END    ] Ending: $($MyInvocation.MyCommand)"
    } #end

} #close function


Register-ArgumentCompleter -CommandName Copy-HistoryCommand -ParameterName Id -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)
   Get-History | Where-Object { $_.id -like "$wordtocomplete*" } |
    ForEach-Object {
        # completion text,listitem text,result type,Tooltip
        [System.Management.Automation.CompletionResult]::new($_.id, $_.id, 'ParameterValue', $_.commandline)
    }
}