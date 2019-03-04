---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version:
schema: 2.0.0
---

# ConvertTo-UTCTime

## SYNOPSIS

Convert a local datetime to universal time.

## SYNTAX

```yaml
ConvertTo-UTCTime [[-DateTime] <DateTime>] [<CommonParameters>]
```

## DESCRIPTION

Convert a local datetime to universal time. The default is now but you can specify a datetime value.

This command was introduced in v2.3.0.

## EXAMPLES

### Example 1

```powershell
PS S:\PSScriptTools> get-date

Monday, March 4, 2019 12:51:47 PM


PS S:\PSScriptTools> ConvertTo-UTCTime

Monday, March 4, 2019 5:51:49 PM
```

## PARAMETERS

### -DateTime
+
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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.DateTime

## OUTPUTS

### System.DateTime

## NOTES

Learn more about PowerShell:
http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[ConvertFrom-UTCTime]()