---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version: http://bit.ly/31SGKce
schema: 2.0.0
---

# Select-Last

## SYNOPSIS

Select the last X number of objects.

## SYNTAX

```yaml
Select-Last -InputObject <PSObject> [-Last] <Int32> [[-Property] <String>]
[-Skip <Int32>] [-Descending] [<CommonParameters>]
```

## DESCRIPTION

This is a modified version of Select-Object designed to select the last X number of objects. The command takes pipelined input and selects the last specified number of objects which are then written to the pipeline. You have an option to first sort on the specified property.

When using this command, there is a trade off of convenience for performance. For a very large number processed objects, use Select-Object directly.

## EXAMPLES

### EXAMPLE 1

```powershell
PS C:\> dir c:\scripts\*.ps1 | last 5 -property lastwritetime

Directory: C:\scripts


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
-a----        1/11/2020   7:18 PM           1818 demo-v5Classes.ps1
-a----        1/11/2020   7:20 PM           1255 demo-v5DSCClassResource.ps1
-a----        1/14/2020  12:58 PM           1967 Demo-ParamTest.ps1
-a----        1/15/2020   9:23 AM            971 Get-WorkflowVariable.ps1
-a----        1/15/2020  12:08 PM           1555 Cost.ps1
```

Get the last 5 ps1 files sorted on the LastWritetime property. This example is using the alias 'last' for Select-Last.

### EXAMPLE 2

```powershell
PS C:\> 1..10 | Select-Last 3 -skip 1

7
8
9
```

Select the last 3 items, skipping the last 1.

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

### -Last

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

Skip or omit the last X number of items.

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

Sort on the specified property in descending order.

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

[Select-First](Select-First.md)
