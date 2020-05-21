#requires -module PSScriptTools
#requires -version 5.1

Function Get-DiskData {
[cmdletbinding()]
Param(
    [Parameter(ValueFromPipeline)]
    [ValidateNotNullOrEmpty()]
    [string]$Computername = $env:computername
   )

   Begin {
        Write-Detail "Starting $($myinvocation.MyCommand)" -Prefix BEGIN  | Write-Verbose
   } #begin

   Process {
        Write-Detail "Processing $($computername.toUpper())" -Prefix PROCESS  | Write-Verbose
        Try {
            $data = Get-CimInstance -Class Win32_logicaldisk -Filter "DriveType=3" -ComputerName $Computername -ErrorAction Stop
            $data | Foreach-Object {
                Write-Detail "Calculating PctFree for $($_.DeviceID)" -prefix PROCESS  | Write-Verbose
                $_ | Add-Member -MemberType ScriptProperty -Name PctFree -value { Format-Percent -value $this.freespace -total $this.size -decimal 2} -force
            }
            $data
        }
        Catch {
            Throw $_
        }
   } #process

   End {
        Write-Detail "Ending $($myinvocation.MyCommand)" -Prefix END  | Write-Verbose
   } #end

}

# Get-DiskData -verbose | Select DeviceID,Size,PctFree

<#
$condition =  [ordered]@{{$psitem.pctfree -le 40}='yellow'}
Get-DiskData | Select-object DeviceID,Size,FreeSpace,PctFree,SystemName | Out-ConditionalColor $condition
#>