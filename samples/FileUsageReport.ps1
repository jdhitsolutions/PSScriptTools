#requires -version 7.4
#requires -module PSScriptTools

#this is a demonstration script
[cmdletbinding()]
Param(
    [Parameter(Position = 0, Mandatory, HelpMessage = "Specify a path like C:\Scripts")]
    [ValidateScript( { Test-Path $_ })]
    [string]$Path,
    [switch]$Recurse
)

#create a transcript if -Verbose is used
if ($VerbosePreference -eq 'Continue') {
    $transcript = New-CustomFileName -Template "Transcript-$($MyInvocation.MyCommand)-%Year%Month%Day%Time.log"
    Start-Transcript -Path $transcript -IncludeInvocationHeader
}

$name = Split-Path -Path $path -Leaf

$file = New-CustomFileName -Template "FolderReport-$($name)_%yr%month%day.log"
$log = Join-Path -Path $env:USERPROFILE\Documents -ChildPath $file
$PSBoundParameters.Add("File", $True)
$files = Get-ChildItem @PSBoundParameters

$grouped = $files | Group-Object -Property {
    if (-Not $_.extension) { "N/A" }
    else { $_.Extension.Substring(1) }
}
$grouped | Add-Member -MemberType ScriptProperty -Name Size -Value { ($this.group | Measure-Object -Property length -Sum).sum }

Format-BorderBox -Text "Folder Usage: $path" -BorderColor $PSStyle.Formatting.Verbose

$grouped | Sort-Object -Property Name
Set-Content -Path $log -Value "Usage Report for $Path"
Add-Content -Path $log -Value (Get-Date)
$data | Select-Object Count, Name, Size | Out-String | Add-Content -Path $log

if ($Transcript -AND (Test-Path $Transcript)) {
    Stop-Transcript
    Write-Verbose "See $transcript for a transcript of this script."
}
