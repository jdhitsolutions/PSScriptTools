---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version: 
schema: 2.0.0
---

# Format-Percent

## SYNOPSIS

Format a value as a percentage.

## SYNTAX

### None (Default)

```yaml
Format-Percent [-Value] <Object> [-Total] <Object> [-Decimal <Int32>] [<CommonParameters>]
```

### String

```yaml
Format-Percent [-Value] <Object> [-Total] <Object> [-Decimal <Int32>] [-AsString] [<CommonParameters>]
```

## DESCRIPTION

This command calculates a percentage of a value from a total, with the formula (value/total)*100. The default is to return a value to 2 decimal places but you can configure that with -Decimal. There is also an option to format the percentage as a string which will include the % symbol.

## EXAMPLES

### EXAMPLE 1

```powershell
PS C:\> Format-Percent -value 1234.567 -total 5000 -decimal 4

24.6913
```

Calculate a percentage from 1234.567 out of 5000 (i.e. 1234.567/5000) to 4 decimal points.

### EXAMPLE 2

```powershell
PS C:\> get-ciminstance win32_operatingsystem -computer chi-dc04 | select PSComputername,TotalVisibleMemorySize,@{Name="PctFreeMem";Expression={ Format-Percent $_.FreePhysicalMemory $_.TotalVisibleMemorySize}}

PSComputerName             TotalVisibleMemorySize           PctFreeMem
--------------             ----------------------           ----------
chi-dc04                                  1738292                23.92
```

### EXAMPLE 3

```powershell
PS C:\> get-ciminstance win32_operatingsystem -computer chi-dc04 | select PSComputername,TotalVisibleMemorySize,@{Name="PctFreeMem";Expression={ Format-Percent $_.FreePhysicalMemory $_.TotalVisibleMemorySize -asString}}

PSComputerName             TotalVisibleMemorySize           PctFreeMem
--------------             ----------------------           ----------
chi-dc04                                  1738292           23.92%
```

## PARAMETERS

### -Value

The numerator value.

```yaml
Type: Object
Parameter Sets: (All)
Aliases: X, Numerator

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Total

The denominator value.

```yaml
Type: Object
Parameter Sets: (All)
Aliases: Y, Denominator

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Decimal

The number of decimal places to return between 0 and 15.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 2
Accept pipeline input: False
Accept wildcard characters: False
```

### -AsString

Write the result as a string.

```yaml
Type: SwitchParameter
Parameter Sets: String
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Object

## OUTPUTS

### System.Double

### System.String

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Format-Value](./Format-Value.md)

[Format-String](./Format-String.md)
