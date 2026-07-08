#requires -version 5.1
#requires -module PSScriptTools

Function Get-TopProcess {
    [cmdletbinding()]
    Param(
        [Parameter(Position = 0)]
        [ValidateSet('WorkingSet', 'VM', 'CPU', 'Handles', 'PM')]
        [string]$Property = "WorkingSet",
        [ValidateRange(1, 25)]
        [int32]$Top = 10,
        [Parameter(ValueFromPipeline)]
        [string]$Computername = $env:computername
    )
    Begin {
        $vLog = New-CustomFileName -Template "$env:temp\$($MyInvocation.MyCommand)-%time.log"
        $PSDefaultParameterValues."Out-VerboseTee:Path" = $vLog
        $PSDefaultParameterValues."Out-VerboseTee:Append" = $True
        "[$(Get-Date -format "hh\:mm\:ss\:ffff")] Starting $($MyInvocation.MyCommand)" | Tee-Verbose
        "[$(Get-Date -format "hh\:mm\:ss\:ffff")] Using verbose log $vLog" | Tee-Verbose
        "[$(Get-Date -format "hh\:mm\:ss\:ffff")] Execution metadata" | Tee-Verbose
        (Add-Border -TextBlock (Get-PSWho -AsString) | Out-String) | Tee-Verbose
        "[$(Get-Date -format "hh\:mm\:ss\:ffff")] Initializing data array" | Tee-Verbose
    } #begin

    Process {
        "[$(Get-Date -format "hh\:mm\:ss\:ffff")] Gathering process information from $Computername" | Tee-Verbose
        $all += Invoke-Command -ScriptBlock {
            Get-Process |
                Sort-Object -Property $using:Property -Descending |
                Select-Object -First $using:Top
        } -ComputerName $computername
    } #process

    End {
        $all
        if ($VerbosePreference -eq 'Continue') {
            #save results to the verbose log
            #add the detail to the log but don't make it verbose
            "[$(Get-Date -format "hh\:mm\:ss\:ffff")] Data results"| Tee-Verbose
            $all | Out-String | Add-Content -Path $vLog
            #save results for each computer to a separate log
            $all | Group-Object -Property PSComputername |
                ForEach-Object {
                    $log = New-CustomFileName -Template "$env:temp\$($_.Name)_TopProcess_$Property-%Year%Month%time-%###.txt"
                    "[$(Get-Date -format "hh\:mm\:ss\:ffff")] Logging output to $log" | Tee-Verbose
                    $_.Group | Out-String | Set-Content -Path $log
                }
        }

        "[$(Get-Date -format "hh\:mm\:ss\:ffff")] Ending $($MyInvocation.MyCommand)" | Tee-Verbose
        $PSDefaultParameterValues.Remove("Out-VerboseTee:Path")
        $PSDefaultParameterValues.Remove("Out-VerboseTee:Append")
    } #end

} #close command

#run the function
'localhost', $env:computername, (hostname) | Get-TopProcess -top 5 -verbose