---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version: https://jdhitsolutions.com/yourls/fcd685
schema: 2.0.0
---

# ConvertTo-UTCTime

## SYNOPSIS

Convert a local datetime to universal time.

## SYNTAX

```yaml
ConvertTo-UTCTime [[-DateTime] <DateTime>] [-AsString] [<CommonParameters>]
```

## DESCRIPTION

Convert a local datetime to universal time. The default is now but you can specify a datetime value. You also have an option to format the result as a sortable string.

This command was introduced in v2.3.0.

## EXAMPLES

### Example 1

```powershell
PS C:\> Get-Date

Wednesday, March 26, 2025 11:01:57 AM

PS C:\> ConvertTo-UTCTime

Wednesday, March 26, 2025 3:02:13 PM
```

### Example 2

```powershell
PS C:\> ConvertTo-UTCTime -asString
2025-03-26 15:02:29Z
```

## PARAMETERS

### -DateTime

Enter a Datetime value

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: now
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -AsString

Convert the date-time value to a sortable string. This is the same thing as running a command like "{0:u}" -f (Get-Date).ToUniversalTime()

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

### System.DateTime

## OUTPUTS

### System.DateTime

## NOTES

Learn more about PowerShell: https://jdhitsolutions.com/yourls/newsletter

## RELATED LINKS

[ConvertFrom-UTCTime]()

[Get-Date]()
