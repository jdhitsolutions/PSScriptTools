#requires -module PSScriptTools
#requires -version 5.1

#this is a demonstration script
[cmdletbinding()]
Param(
    [Parameter(Position = 0, Mandatory)]
    [ValidateScript( {Test-Path $_})]
    [string]$Path,
    [switch]$Recurse
)

#create a transcript if -Verbose is used
if ($VerbosePreference -eq 'Continue') {
    $transcript = New-CustomFileName -Template "Transcript-$($myinvocation.MyCommand)-%Year%Month%Day%Time.log"
    Start-Transcript -Path $transcript -IncludeInvocationHeader
}
$PSDefaultParameterValues."write-detail:date" = $True
Write-Detail "Starting $($myinvocation.mycommand)" | Write-Verbose
Write-Detail "Execution metadata" | Write-Verbose
Write-Detail (Get-PSwho -AsString) | Write-Verbose
Write-Detail "Using parameter values" | Write-Verbose
Write-Detail ($PSBoundParameters | Out-String) | Write-Verbose

$name = Split-Path -Path $path -Leaf
Write-Detail "Creating file name with $Name" | Write-Verbose
$file = New-CustomFileName -Template "FolderReport-$($name)_%yr%month%day.log"
$log = Join-path -Path $env:USERPROFILE\Documents -ChildPath $file
Write-Detail "Logging results to $log" | Write-Verbose

Write-Detail "Getting files from $path" | Write-Verbose
$PSBoundParameters.Add("File", $True)
$files = Get-Childitem @PSBoundParameters

Write-Detail "Found $($files.count) files" | Write-Verbose
$grouped = $files | Group-object -property {
    if (-Not $_.extension) { "N/A" }
    else { $_.Extension.Substring(1)}
}
Write-Detail "Processing data" | Write-Verbose
$grouped | Add-Member -MemberType ScriptProperty -Name Size -Value {($this.group | Measure-Object -Property length -sum).sum}

$c = [ordered]@{
    {$psitem.size -ge 1MB}   = "red"
    {$psitem.size -ge 250KB} = "yellow"
    {$psitem.size -le 10KB}  = "green"
}

$grouped | Sort-object -property Name | Out-Conditionalcolor -Conditions $c -OutVariable data

Write-Detail "Saving data to log file $log" | Write-Verbose
Set-Content -Path $log -Value "Usage Report for $Path"
Add-Content -path $log -value (Get-Date)
$data | Select-Object Count, Name, Size | Out-String | Add-Content -Path $log

Write-Detail "Ending $($myinvocation.mycommand)" | Write-Verbose

$PSDefaultParameterValues.Remove("write-detail:date")

if ($Transcript -AND (Test-Path $Transcript)) {
    Stop-Transcript
    Write-Verbose "See $transcript for a transcript of this script."
}
