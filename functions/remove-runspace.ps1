function Remove-Runspace {
    [CmdletBinding(SupportsShouldProcess, DefaultParameterSetName = 'id')]
    [OutputType('None')]

    param (
        [Parameter(
            Position = 0,
            Mandatory,
            ParameterSetName = 'id'
        )]
        [ValidateNotNullOrEmpty()]
        [int32]$ID,

        [Parameter(
            Position = 0,
            Mandatory,
            ValueFromPipeline,
            ParameterSetName = 'runspace'
        )]
        [System.Management.Automation.Runspaces.Runspace]$Runspace
    )

    begin {
        #tags are used for categorizing the command
        #cmdTags = general,scripting
        Write-Verbose "Starting $($MyInvocation.MyCommand)"
        Write-Verbose "Running under PowerShell version $($PSVersionTable.PSVersion)"
    } #begin

    process {
        if ($id) {
            Write-Verbose "Getting runspace ID $id"
            $runspace = Get-Runspace -Id $id
            if (-not $Runspace) {
                throw "Failed to find a runspace with an id of $id"
            }

        }
        Write-Verbose "Removing runspace $($runspace.id)"
        if ($PSCmdlet.ShouldProcess("$($Runspace.id) - $($Runspace.name)")) {
            if ($Runspace.RunspaceStateInfo -eq 'closing' -or $runspace.RunspaceAvailability -eq 'busy') {
                Write-Warning "Can't remove this runspace in its current state"
                Write-Warning ($runspace | Out-String)
            }
            else {
                $Runspace.close()
                $Runspace.dispose()
            }
        }
    } #process


    end {
        Write-Verbose "Ending $($MyInvocation.MyCommand)"
    } #end

} #close function


Register-ArgumentCompleter -CommandName Remove-Runspace -ParameterName Runspace -ScriptBlock {
    param($commandName, $parameterName, $WordToComplete, $commandAst, $fakeBoundParameter)

    (Get-Runspace).where( { $_.RunspaceAvailability -ne 'busy' }).name |
    ForEach-Object {
        # completion text,listitem text,result type,Tooltip
        [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
    }
}
#EOF
