#requires -version 5.1
#requires -module PSScriptTools

param([int]$Count = 20)

$processes = Get-Process
$total = ($processes | Measure-Object -Property WS -Sum).sum

$hrParams = @{
    Title      = ([Environment]::MachineName)
    TitleStyle = 'italic', 'bold'
    Alignment  = 'Center'
    Style      = "$([char]27)[38;5;228m"
}
#insert an empty line
"`n"
Write-PSHorizontalRule @hrParams

$processes | Sort-Object WS -Descending |
First $count |
Format-Table -Property Name, ID, Handles,
@{Name = 'WS(MB)'; Expression = { Format-Value $_.WS -Unit MB } },
@{Name = 'PctWS'; Expression = {
    $pct = Format-Percent -Value $_.ws -Total $total -Decimal 2
    #scale the percentage for display purposes
    $bar = New-ANSIBar -Range 210 -Spacing ($pct * 5) -Character BlackSquare
    '{0:00.00} {1}' -f $pct, $bar
    }
}
Write-PSHorizontalRule -Style $hrParams.Style
#insert an empty line
"`n"

#EOF