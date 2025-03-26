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
        Write-Detail "Starting $($MyInvocation.MyCommand)" -Prefix BEGIN -Time | Write-Verbose
    } #begin

    Process {
        Write-Detail "Processing $($computername.ToUpper())" -Prefix PROCESS -Time | Write-Verbose
        Try {
            $data = Get-CimInstance -Class Win32_logicaldisk -Filter "DriveType=3" -ComputerName $Computername -ErrorAction Stop
            $data | ForEach-Object {
                Write-Detail "Calculating PctFree for $($_.DeviceID)" -Prefix PROCESS -Time | Write-Verbose
                $_ | Add-Member -MemberType ScriptProperty -Name PctFree -Value { Format-Percent -Value $this.FreeSpace -Total $this.Size -Decimal 2 } -Force
            }
            $data
        }
        Catch {
            Throw $_
        }
    } #process

    End {
        Write-Detail "Ending $($MyInvocation.MyCommand)" -Prefix END -Time | Write-Verbose
    } #end

}

# Get-DiskData -verbose | Select DeviceID,Size,PctFree

<#
$condition =  [ordered]@{{$psitem.pctfree -le 40}='yellow'}
Get-DiskData | Select-object DeviceID,Size,FreeSpace,PctFree,SystemName | Out-ConditionalColor $condition
#>