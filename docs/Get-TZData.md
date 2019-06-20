---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version:
schema: 2.0.0
---

# Get-TZData

## SYNOPSIS

Get time zone details

## SYNTAX

```yaml
Get-TZData [-TimeZoneArea] <String> [-Raw] [<CommonParameters>]
```

## DESCRIPTION

This command uses a free and publicly available REST API offered by http://worldtimeapi.org to get information about a time zone. You can use Get-TZList to find an area and this command to display the details. The time zone area name is case-sensitive. The default is to write a custom object to the pipeline, but you also have an option of seeing the raw data that is returned from the API. On PowerShell Core, the raw data will be slightly different.

Note that if the site is busy you may get an error. If that happens, wait a minute and try again.

## EXAMPLES

### Example 1

```powershell
PS C:\> Get-TZData Australia/Hobart

PS C:\> Get-TZData Australia/Hobart

Timezone                        Label        Offset     DST                  Time
--------                        -----        ------     ---                  ----
Australia/Hobart                AEDT       11:00:00    True  3/16/2019 5:35:46 AM
```

Get time zone information for Hobart.

### Example 2

```powershell
PS C:\> Get-TZData Asia/Tokyo -Raw


week_number  : 11
utc_offset   : +09:00
unixtime     : 1552674997
timezone     : Asia/Tokyo
dst_until    :
dst_from     :
dst          : False
day_of_year  : 75
day_of_week  : 6
datetime     : 2019-03-16T03:36:37.829505+09:00
abbreviation : JST
```

Get time zone information for Tokyo as a raw format.

### Example 3

```powershell
PS C:\> Get-TZList Antarctica | Get-TZData | Sort-Object Offset

Timezone                        Label        Offset     DST                  Time
--------                        -----        ------     ---                  ----
Antarctica/Rothera               -03      -03:00:00   False  3/15/2019 3:39:59 PM
Antarctica/Palmer                -03      -03:00:00   False  3/15/2019 3:39:59 PM
Antarctica/Troll                 +00       00:00:00   False  3/15/2019 6:40:00 PM
Antarctica/Syowa                 +03       03:00:00   False  3/15/2019 9:39:59 PM
Antarctica/Mawson                +05       05:00:00   False 3/15/2019 11:39:59 PM
Antarctica/Vostok                +06       06:00:00   False 3/16/2019 12:40:00 AM
Antarctica/Davis                 +07       07:00:00   False  3/16/2019 1:39:58 AM
Antarctica/Casey                 +08       08:00:00   False  3/16/2019 2:39:58 AM
Antarctica/DumontDUrville        +10       10:00:00   False  3/16/2019 4:39:58 AM
Antarctica/Macquarie             +11       11:00:00   False  3/16/2019 5:39:58 AM
```

Get all time zone areas in Antarctica and pipe them to Get-TZData to retrieve the details.

### Example 4

```powershell
PS C:\> Get-TZData Europe/Rome | ConvertTo-LocalTime -Datetime "3/15/2019 4:00PM"

Friday, March 15, 2019 11:00:00 AM
```

Convert the datetime in Rome to local time, which in this example is Eastern time.

## PARAMETERS

### -Raw

Return raw, unformatted data. Due to the way PowerShell Core automatically wants to format date time strings, raw output had to be slightly adjusted.

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

### -TimeZoneArea

Enter a timezone location like Pacific/Auckland. It is case sensitive. Use Get-TZList to retrieve a list of areas.

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

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

## OUTPUTS

### PSCustomObject

### TimeZoneData

## NOTES

Learn more about PowerShell:http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Get-TZList](Get-TZList.md)

