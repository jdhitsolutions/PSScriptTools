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
        $PSDefaultParameterValues."Write-Detail:Prefix" = 'Begin'
        Write-Detail "Starting $($MyInvocation.MyCommand)" | Tee-Verbose
        Write-Detail "Using verbose log $vLog" | Tee-Verbose
        Write-Detail "Execution metadata" | Tee-Verbose
        Write-Detail (Add-Border -TextBlock (Get-PSWho -AsString) | Out-String) | Tee-Verbose
        Write-Detail "Initializing data array" | Tee-Verbose
    } #begin

    Process {
        $PSDefaultParameterValues."Write-Detail:Prefix" = 'Process'
        Write-Detail "Gathering process information from $Computername" | Tee-Verbose
        $all += Invoke-Command -ScriptBlock {
            Get-Process |
                Sort-Object -Property $using:Property -Descending |
                Select-Object -First $using:Top
        } -ComputerName $computername
    } #process

    End {
        $PSDefaultParameterValues."Write-Detail:Prefix" = 'End'
        $all
        if ($VerbosePreference -eq 'Continue') {
            #save results to the verbose log
            #add the detail to the log but don't make it verbose
            Write-Detail "Data results" | Add-Content -Path $vLog
            $all | Out-String | Add-Content -Path $vLog
            #save results for each computer to a separate log
            $all | Group-Object -Property PSComputername |
                ForEach-Object {
                    $log = New-CustomFileName -Template "$env:temp\$($_.Name)_TopProcess_$Property-%Year%Month%time-%###.txt"
                    Write-Detail "Logging output to $log" | Tee-Verbose
                    $_.Group | Out-String | Set-Content -Path $log
                }
        }

        Write-Detail "Ending $($MyInvocation.MyCommand)" | Tee-Verbose
        $PSDefaultParameterValues.Remove("Out-VerboseTee:Path")
        $PSDefaultParameterValues.Remove("Out-VerboseTee:Append")
        $PSDefaultParameterValues.Remove("Write-Detail:Prefix")
    } #end

} #close command

#run the function
'localhost', $env:computername, (hostname) | Get-TopProcess -top 5 -verbose