#requires -module PSScriptTools

$processes = Get-Process
$total = ($processes | Measure-Object -Property WS -Sum).sum

$processes | Sort-Object WS -Descending |
    Select-Object -property Name, ID, Handles, @{Name = 'WS(MB)'; Expression = {Format-value $_.WS -unit MB}},
@{Name = "PctWS"; Expression = {Format-Percent -Value $_.ws -Total $total -Decimal 4}} -first 25
