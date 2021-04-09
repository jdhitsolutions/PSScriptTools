#Requires -Module Microsoft.PowerShell.Diagnostics

#don't load this function if running Linux or Mac because they don't have the
#required Microsoft.PowerShell.Diagnostics module

if ($IsWindows -OR ($PSEdition -eq 'Desktop')) {

    Class myCounter {
        [string]$Computername
        [string]$Category
        [string]$Counter
        [string]$Instance
        [double]$Value  #cooked value
        [datetime]$Timestamp

        myCounter ([Microsoft.PowerShell.Commands.GetCounter.PerformanceCounterSample]$CounterSample) {
            $this.Computername = $countersample.path.split("\")[2].toUpper()
            $this.Counter = $countersample.path.split("\")[-1]
            $this.Category = $countersample.path.split("\")[-2]
            $this.Instance = $countersample.InstanceName
            $this.Value = $countersample.CookedValue
            $this.Timestamp = $countersample.Timestamp
        }
    }

    # RemoteRegistry service must be running to query remote computers and you need to have admin access
    Function Get-MyCounter {

        [CmdletBinding()]
        [OutputType("myCounter")]
        Param(
            [Parameter(ParameterSetName = 'GetCounterSet', Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
            [AllowEmptyCollection()]
            [string[]]$Counter,

            [Parameter(ParameterSetName = 'GetCounterSet')]
            [ValidateRange(1, 2147483647)]
            [int]$SampleInterval,

            [Parameter(ParameterSetName = 'GetCounterSet')]
            [ValidateRange(1, 9223372036854775807)]
            [long]$MaxSamples,

            [Parameter(ParameterSetName = 'GetCounterSet')]
            [switch]$Continuous,

            [Alias('Cn')]
            [ValidateNotNull()]
            [AllowEmptyCollection()]
            [string[]]$ComputerName
        )

        Begin {
            Write-Verbose "[BEGIN  ] Starting $($MyInvocation.Mycommand)"
        } #begin

        Process {
            if ($isLinux -OR $IsMacOS) {
                #this should never be needed
                Write-Warning "This command requires a Windows platform."
            }
            else {
                Write-Verbose "[PROCESS] Using parameter set $($PSCmdlet.ParameterSetName) with these bound parameters"
                Write-Verbose ($PSBoundParameters | Out-String)

                Get-Counter @PSBoundParameters | Select-Object -ExpandProperty Countersamples |
                ForEach-Object { [mycounter]::new($_) }
            }

        } #process

        End {
            Write-Verbose "[END    ] Ending $($MyInvocation.Mycommand)"
        } #end

    } #close function Get-MyCounter
}
else {
    Write-Warning "This command requires a Windows platform."
}