---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version: https://jdhitsolutions.com/yourls/ba6489
schema: 2.0.0
---

# ConvertFrom-UTCTime

## SYNOPSIS

Convert a datetime value from universal.

## SYNTAX

```yaml
ConvertFrom-UTCTime [-DateTime] <DateTime> [<CommonParameters>]
```

## DESCRIPTION

Use this command to convert a universal datetime object into local time.

This command was introduced in v2.3.0.

## EXAMPLES

### Example 1

```powershell
PS C:\> ConvertFrom-UTCTime "18:00"

Monday, March 4, 2020 1:00:00 PM
```

Covert the time 18:00 for the current day from universal time to local time. This result reflects Eastern Time which on this date is UTC-5.

## PARAMETERS

### -DateTime

Enter a Universal Datetime value

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
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

Learn more about PowerShell: https://jdhitsolutions.com/yourls/newsletter

## RELATED LINKS

[ConvertTo-UTCTime](ConvertTo-UTCTime.md)

[Get-Date]()
