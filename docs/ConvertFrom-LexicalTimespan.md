---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version: https://jdhitsolutions.com/yourls/2bf285
schema: 2.0.0
---

# ConvertFrom-LexicalTimespan

## SYNOPSIS

Convert a lexical timespan into a PowerShell timespan.

## SYNTAX

```yaml
ConvertFrom-LexicalTimespan [-String] <String> [-AsString] [<CommonParameters>]
```

## DESCRIPTION

When working with some XML data, such as that from scheduled tasks, time spans or durations are stored in a lexical format like P0DT0H0M47S. You can use this command to convert that value into a timespan object.

## EXAMPLES

### Example 1

```powershell
PS C:\> ConvertFrom-LexicalTimespan P0DT0H0M47S


Days              : 0
Hours             : 0
Minutes           : 0
Seconds           : 47
Milliseconds      : 0
Ticks             : 470000000
TotalDays         : 0.000543981481481481
TotalHours        : 0.0130555555555556
TotalMinutes      : 0.783333333333333
TotalSeconds      : 47
TotalMilliseconds : 47000
```

### Example 2

```powershell
PS C:\> Get-ScheduledTask -TaskName DailyWatcher |
Select-Object TaskName,
@{Name="ExecutionLimit";Expression = `
{ ConvertFrom-LexicalTimespan $_.settings.ExecutionTimeLimit }}

TaskName     ExecutionLimit
--------     --------------
DailyWatcher 3.00:00:00
```

## PARAMETERS

### -AsString

Format the timespan as a string

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

### -String

Enter a lexical time string like P23DT3H43M. This is case-sensitive.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

## OUTPUTS

### String

### Timespan

## NOTES

Learn more about PowerShell: https://jdhitsolutions.com/yourls/newsletter

## RELATED LINKS

[ConvertTo-LexicalTimespan](ConvertTo-LexicalTimespan.md)
