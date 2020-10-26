---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version: https://bit.ly/33WapF8
schema: 2.0.0
---

# New-RedGreenGradient

## SYNOPSIS

Create an ANSI gradient from red to green.

## SYNTAX

```yaml
New-RedGreenGradient [[-Percent] <Double>] [-Step <Int32>] [-Character <Char>]
[<CommonParameters>]
```

## DESCRIPTION

You can use this command to create an ANSI colored gradient bar running from red to green. By specifying a percentage, you can provide a visual representation. The closer the percent value is to 1 the more green will be displayed. Use the -Step parameter to adjust the bar length. The smaller the step the longer the bar.

## EXAMPLES

### Example 1

```powershell
PS C:\> New-RedGreenGradient -Percent .75
```

This will display a red to green gradient bar.

### Example 2

```powershell
PS C:\> Get-Volume |
Where {$_.FileSystemType -eq 'NTFS' -AND $_.driveletter -match "[C-Zc-z]"} |
Sort-Object -property DriveLetter |
Select-Object -property DriveLetter, FileSystemLabel,
@{Name="FreeGB";Expression={Format-Value -input $_.SizeRemaining -unit GB}},
@{Name = "PctFree"; Expression = {
$pct = Format-Percent -value $_.sizeremaining -total $_.size -decimal 2;
"{1} {0}" -f $(New-RedGreenGradient -percent ($pct/100) -step 6),$pct}}

DriveLetter FileSystemLabel FreeGB PctFree
----------- --------------- ------ -------
          C Windows             92 38.84 █████████████████
          D Data               104 21.82 ██████████
```

The bar graph will be colored from red towards green. This example is using format command from the PSScriptTools module.

## PARAMETERS

### -Character

Specify a character to use for the gradient bar

```yaml
Type: Char
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: [char]0x2588
Accept pipeline input: False
Accept wildcard characters: False
```

### -Percent

Specify a percentage as a decimal value like .35

```yaml
Type: Double
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Step

Specify a relative bar length between 2 and 10. The smaller the number the longer the bar.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 5
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.String

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[New-ANSIBar](New-ANSIBar.md)

[Write-ANSIProgress](Write-ANSIProgress.md)
