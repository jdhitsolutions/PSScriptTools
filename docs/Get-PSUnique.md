---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version: https://bit.ly/3FcGibX
schema: 2.0.0
---

# Get-PSUnique

## SYNOPSIS

Filter for unique objects.

## SYNTAX

```yaml
Get-PSUnique [-InputObject] <Object> [-Property <String[]>] [<CommonParameters>]
```

## DESCRIPTION

You can use this command to filter for truly unique objects. That is, every property on every object is considered unique. Most things in PowerShell are already guaranteed to be unique, but you might import data from a CSV file with duplicate entries. Get-PSUnique can help filter.

This command works best with simple objects. Objects with nested objects as properties may not be properly detected. For complex objects, you might need to specify the property or properties to use for comparison.

## EXAMPLES

### Example 1

```powershell
PS C:\> $clean = Import-CSV c:\data\newinfo.csv | Get-PSUnique
```

Import unique objects from a CSV file and save the results to a variable.

## PARAMETERS

### -InputObject

Simple, objects. The flatter the better this command will work.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Property

Specify a property to use for the comparison.

```yaml
Type: String[]
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

### Object

## OUTPUTS

### Object

## NOTES

Learn more about PowerShell: https://jdhitsolutions.com/yourls/newsletter

## RELATED LINKS

[Compare-Object]()
