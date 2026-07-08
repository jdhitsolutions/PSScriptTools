#requires -version 5.1
#requires -module PSScriptTools

Function Get-DiskData {
    [cmdletbinding()]
    Param(
        [Parameter(ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [string]$Computername = $env:computername
    )

    Begin {
        $log = New-RandomFilename -useTemp -extension log
        "Starting $($MyInvocation.MyCommand)" | Tee-Verbose -path $log
    } #begin

    Process {
        "Processing $($computername.ToUpper())" | Tee-Verbose -path $log -append
        Try {
            $data = Get-CimInstance -Class Win32_logicaldisk -Filter "DriveType=3" -ComputerName $Computername -ErrorAction Stop
            $data | ForEach-Object {
                "Calculating PctFree for $($_.DeviceID)" | Tee-Verbose -path $log -append
                $_ | Add-Member -MemberType ScriptProperty -Name PctFree -Value { Format-Percent -Value $this.FreeSpace -Total $this.Size -Decimal 2 } -Force
            }
            $data
        }
        Catch {
            Throw $_
        }
    } #process

    End {
        Write-Verbose "Verbose log can be found at $log"
        "Ending $($MyInvocation.MyCommand)" | Tee-Verbose -path $log -Append
    } #end

}

# Get-DiskData -verbose | Select DeviceID,Size,PctFree

<#
$condition =  [ordered]@{{$psitem.pctfree -le 40}='yellow'}
Get-DiskData | Select-object DeviceID,Size,FreeSpace,PctFree,SystemName | Out-ConditionalColor $condition
#>