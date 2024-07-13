---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version: https://bit.ly/2SSgQCM
schema: 2.0.0
---

# Write-ANSIProgress

## SYNOPSIS

Display an ANSI progress bar.

## SYNTAX

```
Write-ANSIProgress [-PercentComplete] <Double> [-ProgressColor <String>] [-BarSymbol <String>]
 [-Position <Coordinates>] [-ToHost] [<CommonParameters>]
```

## DESCRIPTION

You can use this command to write an ANSI-styled progress bar to the console. The output will be an array of strings. The item may be a blank line. See examples. If you are incorporating this command into a script or function, you may want to use the -ToHost parameter to write the progress bar to the host instead of the pipeline.

NOTE: If you are using the Windows Terminal and are at the bottom of the screen, you may get improperly formatted results. Clear the host and try again.

## EXAMPLES

### Example 1

```powershell
PS C:\> Write-ANSIProgress -BarSymbol Block -PercentComplete .78 -ToHost

 78% ███████████████████████████████████████
```

This will build a progress bar using a block symbol and the default ANSI color escape. The output will be to the host, not the pipeline.

### Example 2

```powershell
PS C:\> $params = @{
  PercentComplete = .78
  BarSymbol       = "Circle"
  "ProgressColor" =  "$([char]27)[92m"
}
PS C:\> Write-ANSIProgress @params
```

Create a single progress bar for 78% using the Circle symbol and a custom color.

### Example 3

```powershell
PS C:\> Get-CimInstance -ClassName Win32_OperatingSystem |
Select-Object -property @{Name="Computername";Expression={$_.CSName}},
@{Name="TotalMemGB";Expression={Format-Value $_.TotalVisibleMemorySize -unit MB}},
@{Name="FreeMemGB";Expression={Format-Value $_.FreePhysicalMemory -unit MB}},
@{Name="PctFree"; Expression={
$pct = Format-Percent $_.FreePhysicalMemory $_.TotalVisibleMemorySize
Write-ANSIProgress -PercentComplete ($pct/100) | Select-Last 1
}}


Computername TotalMemGB FreeMemGB PctFree
------------ ---------- --------- -------
BOVINE320            32        12 37.87% ■■■■■■■■■■■■■■■■■■■
```

Note that this example uses abbreviations in the Select-Object hashtables.

### Example 4

```powershell
PS C:\> $sb = {
  Clear-Host
  $top = Get-ChildItem c:\scripts -Directory
  $i = 0
  $out=@()
  $pos = $host.UI.RawUI.CursorPosition
  Foreach ($item in $top) {
    $i++
    $pct = [math]::round($i/$top.count,2)
    Write-ANSIProgress -PercentComplete $pct -position $pos
    Write-Host "  Processing $(($item.FullName).PadRight(80))"  -NoNewline
    $out+= Get-ChildItem -Path $item -Recurse -file |
    Measure-Object -property length -sum |
    Select-Object @{Name="Path";Expression={$item.FullName}},Count,
    @{Name="Size";Expression={$_.Sum}}
  }
  Write-Host ""
  $out | Sort-Object -property Size -Descending
}
PS C:\> Invoke-Command -scriptblock $sb
```

You are most likely to use this command in a function or script. This example demonstrates using a script block.

## PARAMETERS

### -BarSymbol

Specify what shape to use for the progress bar.

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: Box, Block, Circle

Required: False
Position: Named
Default value: Box
Accept pipeline input: False
Accept wildcard characters: False
```

### -PercentComplete

Enter a percentage in a decimal value like .25 up to 1.

```yaml
Type: Double
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Position

Specify the cursor position or where you want to place the progress bar.

```yaml
Type: Coordinates
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Current position
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProgressColor

Specify an ANSI escape sequence for the progress bar color. You could also use a PSStyle setting.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ToHost

Write to the host, not the PowerShell pipeline. You may want to do this if using this command in a script or function so the output is not commingled with your command output.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Double

## OUTPUTS

### System.String

## NOTES

This command will not work in the PowerShell ISE. The verbose output should only be used when troubleshooting a display problem.

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[New-ANSIBar](New-ANSIBar.md)

[New-RedGreenGradient](New-RedGreenGradient.md)

[Show-ANSISequence](Show-ANSISequence.md)
