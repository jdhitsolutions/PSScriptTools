#requires -version 7.2
#requires -module PSScriptTools

#2 August 2024 Removing this sample since ConvertTo-ASCIIArt has been removed.
$dow = ConvertTo-ASCIIArt (Get-date).dayofweek -Font CyberSmall
$bar = New-ANSIBar -range (232..255)
$head = @"
$bar

{0}
{1}
{3}

{2}Time to get to work!.{3}
$bar
"@ -f "`e[1;38;2;200;250;240m",$dow,"`e[1;3;6;93m","`e[0m"

Clear-Host
$head