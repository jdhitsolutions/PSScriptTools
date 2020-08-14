---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version: http://bit.ly/31VABfp
schema: 2.0.0
---

# ConvertTo-LocalTime

## SYNOPSIS

Convert a foreign time to local.

## SYNTAX

```yaml
ConvertTo-LocalTime [-Datetime] <DateTime> [-UTCOffset] <TimeSpan>
[-DaylightSavingTime] [<CommonParameters>]
```

## DESCRIPTION

It can be tricky sometimes to see a time in a foreign location and try to figure out what that time is locally. This command attempts to simplify this process. In addition to the remote time, you need the base UTC offset for the remote location. You can use Get-Timezone or Get-TZData to help. See examples.

The parameter for DaylightSavingTime is to indicate that the remote location is observing DST. You can use this with the location's standard UTC offset, or you can specify an offset that takes DST into account.

## EXAMPLES

### Example 1

```powershell
PS C:\> ConvertTo-LocalTime "3/15/2019 7:00AM" 8:00:00

Thursday, March 14, 2019 7:00:00 PM
```

Convert a time that is in Singapore to local (Eastern) time.

### Example 2

```powershell
PS C:\> Get-TimeZone -ListAvailable | where-object id -match hawaii


Id                         : Hawaiian Standard Time
DisplayName                : (UTC-10:00) Hawaii
StandardName               : Hawaiian Standard Time
DaylightName               : Hawaiian Daylight Time
BaseUtcOffset              : -10:00:00
SupportsDaylightSavingTime : False

PS C:\> ConvertTo-LocalTime "10:00AM" -10:00:00

Thursday, March 14, 2019 4:00:00 PM
```

In this example, the user if first determining the UTC offset for Hawaii. Then 10:00AM in say Honolulu, is converted to local time which in this example is in the Eastern Time zone.

## PARAMETERS

### -Datetime

Enter a non-local date time

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -UTCOffset

Enter the location's' UTC Offset. You can use Get-Timezone to discover it.

```yaml
Type: TimeSpan
Parameter Sets: (All)
Aliases: offset

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -DaylightSavingTime

Indicate that the foreign location is using Daylight Saving Time

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: dst

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### DateTime

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Get-TimeZone]()

[Get-Date]()

[Get-MyTimeInfo](Get-MyTimeInfo.md)

[Get-TZList](Get-TZList.md)

[ConvertFrom-UTCTime](ConvertFrom-UTCTime.md)

[ConvertTo-UTCTime](ConvertTo-UTCTime.md)
