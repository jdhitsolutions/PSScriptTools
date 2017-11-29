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
        $vlog = New-CustomFileName -Template "$env:temp\$($myinvocation.mycommand)-%time.log"
        $PSDefaultParameterValues."Out-VerboseTee:Path" = $vlog
        $PSDefaultParameterValues."Out-VerboseTee:Append" = $True
        $PSDefaultParameterValues."Write-Detail:Prefix" = 'Begin' 
        Write-Detail "Starting $($myinvocation.mycommand)" | Tee-Verbose
        Write-Detail "Using verbose log $vlog" | Tee-Verbose
        Write-Detail "Execution metadata" | Tee-Verbose
        Write-Detail (Get-PSwho -AsString) | Tee-Verbose
        Write-Detail "Initializing data array" | Tee-Verbose
    } #begin

    Process {
        $PSDefaultParameterValues."Write-Detail:Prefix" = 'Process' 
        Write-Detail "Gathering process information from $Computername" | Tee-Verbose
        $all += Invoke-Command -ScriptBlock { 
            Get-Process | 
                Sort-Object -Property $using:Property -Descending |
                Select-Object -first $using:Top 
        } -ComputerName $computername
    } #process

    End {
        $PSDefaultParameterValues."Write-Detail:Prefix" = 'End' 
        $all
        if ($VerbosePreference -eq 'Continue') {
            #save results to the verbose log
            #add the detail to the log but don't make it verbose
            Write-Detail "Data results" | Add-Content -path $vlog
            $all | Out-String | Add-Content -path $vlog
            #save results for each computer to a separate log
            $all | Group-Object -property PSComputername |
                foreach-object {
                $log = New-CustomFileName -Template "$env:temp\$($_.Name)_TopProcess_$Property-%Year%Month%time-%###.txt"
                Write-Detail "Logging output to $log" | Tee-Verbose
                $_.Group | Out-String | Set-Content -path $log 
            }
        }

        Write-Detail "Ending $($myinvocation.mycommand)" | Tee-Verbose
        $PSDefaultParameterValues.Remove("Out-VerboseTee:Path")
        $PSDefaultParameterValues.Remove("Out-VerboseTee:Append")
        $PSDefaultParameterValues.Remove("Write-Detail:Prefix")
    } #end

} #close command

#run the function 
'localhost', $env:computername, (hostname) | Get-TopProcess -top 5 -verbose 