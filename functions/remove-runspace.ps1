Function Remove-Runspace {
    [CmdletBinding(SupportsShouldProcess, DefaultParameterSetName = "id")]
    [OutputType("None")]

    Param (
        [Parameter(
            Position = 0,
            Mandatory,
            ParameterSetName = "id"
            )]
        [ValidateNotNullOrEmpty()]
        [int32]$ID,

        [Parameter(
            Position = 0,
            Mandatory,
            ValueFromPipeline,
            ParameterSetName = "runspace"
            )]
        [System.Management.Automation.Runspaces.Runspace]$Runspace
    )

    Begin {
        Write-Verbose "Starting $($MyInvocation.MyCommand)"
    } #begin

    Process {
        if ($id) {
            Write-Verbose "Getting runspace ID $id"
            $runspace = Get-Runspace -id $id
            if (-not $Runspace) {
                Throw "Failed to find a runspace with an id of $id"
            }

        }
        Write-Verbose "Removing runspace $($runspace.id)"
        if ($PSCmdlet.ShouldProcess("$($Runspace.id) - $($Runspace.name)")) {
            if ($Runspace.RunspaceStateInfo -eq "closing" -OR $runspace.RunspaceAvailability -eq "busy") {
                Write-Warning "Can't remove this runspace in its current state"
                Write-Warning ($runspace | Out-String)
            }
            else {
                $Runspace.close()
                $Runspace.dispose()
            }
        }
    } #process


    End {
        Write-Verbose "Ending $($MyInvocation.MyCommand)"
    } #end

} #close function


Register-ArgumentCompleter -CommandName Remove-Runspace -ParameterName Runspace -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)

    (Get-Runspace).where( {$_.RunspaceAvailability -ne 'busy'}).name|
        foreach-object {
        # completion text,listitem text,result type,Tooltip
        [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
    }
}