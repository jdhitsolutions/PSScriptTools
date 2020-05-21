#requires -module PSScriptTools
#requires -version 5.1

$processes = Get-Process
$total = ($processes | Measure-Object -Property WS -Sum).sum

$processes | Sort-Object WS -Descending |
Select-Object -first 25 |
Format-Table -property Name, ID, Handles, @{Name = 'WS(MB)'; Expression = {Format-value $_.WS -unit MB}},
@{Name = "PctWS"; Expression = {
    $pct = Format-Percent -Value $_.ws -Total $total -Decimal 2
    $bar = New-ANSIBar -Range 14 -Spacing $pct -Character BlackSquare
    "{0:00.00} {1}" -f $pct,$bar
}}
