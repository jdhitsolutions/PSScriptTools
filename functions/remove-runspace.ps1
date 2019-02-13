Function Remove-Runspace {

    [CmdletBinding(SupportsShouldProcess, DefaultParameterSetName = "id")]
    [Outputtype("None")]

    Param
    (
        [Parameter(Mandatory, Position = 0, ParameterSetName = "id")]
        [ValidateNotNullorEmpty()]
        [int32]$ID,

        [Parameter(Mandatory, ValueFromPipeline, Position = 0, ParameterSetName = "runspace")]
        [System.Management.Automation.Runspaces.Runspace]$Runspace
    )

    Begin {
        Write-Verbose "Starting $($MyInvocation.Mycommand)"
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
        Write-Verbose "Ending $($MyInvocation.Mycommand)"
    } #end

} #close function