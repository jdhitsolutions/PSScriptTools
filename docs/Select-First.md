---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version: http://bit.ly/31VhYb9
schema: 2.0.0
---

# Select-First

## SYNOPSIS

Select the first X number of objects.

## SYNTAX

```yaml
Select-First -InputObject <PSObject> [-First] <Int32> [[-Property] <String>]
[-Skip <Int32>] [-Descending] [<CommonParameters>]
```

## DESCRIPTION

This command is intended to take pipelined input and select the first specified number of objects which are then written to the pipeline. You also have the option to sort on a specified property.

When using this command, there is a trade-off of convenience for performance. For a very large number processed objects, use Select-Object directly.

## EXAMPLES

### EXAMPLE 1

```powershell
PS C:\> Get-Process | Select-First 3 -property WS -descending

Handles  NPM(K)    PM(K)      WS(K) VM(M)   CPU(s)     Id  SI ProcessName
-------  ------    -----      ----- -----   ------     --  -- -----------
   1118      66   419952     392396 ...12   107.33   7312   1 powershell
    343      43   237928     235508  1237 3,905.22   6424   1 slack
   1051      88   231216     234728  1175    61.88   8324   1 powershell_ise
```

### EXAMPLE 2

```powershell
PS C:\> 1..10 | Select-First 3 -Skip 2

3
4
5
```

Select the first 3 objects after skipping 2.

## PARAMETERS

### -InputObject

Pipelined input to be selected.

```yaml
Type: PSObject
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -First

How many items do you want to select?

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Property

Sort first on this property then select the specified number of items.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Skip

Skip or omit the first X number of items.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Descending

Sort the property in descending order.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### Object[]

## OUTPUTS

### Object[]

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Select-Object]()

[Select-Last](Select-Last.md)
