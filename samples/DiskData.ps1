#requires -module PSScriptTools

Function Get-DiskData {
[cmdletbinding()]
Param(
    [Parameter(ValueFromPipeline)]
    [ValidateNotNullOrEmpty()]
    [string]$Computername = $env:computername    
   )

   Begin {
        Write-Detail "Starting $($myinvocation.MyCommand)" -Prefix begin -NoDate | Write-Verbose
   } #begin

   Process {
        Write-Detail "Processing $($computername.toUpper())" -Prefix process -NoDate | Write-Verbose
        Try {
            $data = Get-CimInstance -Class Win32_logicaldisk -Filter "DriveType=3" -ComputerName $Computername -ErrorAction Stop
            $data | Foreach-Object {
                Write-Detail "Calculating PctFree for $($_.DeviceID)" -prefix process -NoDate | Write-Verbose
                $_ | Add-Member -MemberType ScriptProperty -Name PctFree -value {($this.freespace/$this.size)*100} -force
            }
            $data
        }   
        Catch {
            Throw $_
        }
   } #process

   End {
        Write-Detail "Ending $($myinvocation.MyCommand)" -Prefix end -NoDate | Write-Verbose
   } #end

}

# Get-DiskData -verbose

<#
$condition =  [ordered]@{{$psitem.pctfree -le 40}='yellow'}
Get-DiskData | Select-object DeviceID,Size,FreeSpace,PctFree,SystemName | Out-ConditionalColor $condition
#>