---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version: https://jdhitsolutions.com/yourls/0b8283
schema: 2.0.0
---

# Get-TZData

## SYNOPSIS

Get time zone details.

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

Timezone                        Label        Offset     DST                  Time
--------                        -----        ------     ---                  ----
Australia/Hobart                AEDT       11:00:00    True  3/27/2025 2:44:24 AM```

Get time zone information for Hobart.

### Example 2

```powershell
PS C:\> Get-TZData Asia/Tokyo -Raw

week_number  : 13
utc_offset   : +09:00
unixtime     : 1743003902
timezone     : Asia/Tokyo
dst_until    :
dst_from     :
dst          : False
day_of_year  : 86
day_of_week  : 4
datetime     : 2025-03-27T00:45:02.000000+09:00
abbreviation : JST
```

Get time zone information for Tokyo as a raw format.

### Example 3

```powershell
PS C:\> Get-TZList Antarctica | Get-TZData | Sort-Object Offset

Timezone                        Label        Offset     DST                 Time
--------                        -----        ------     ---                 ----
Antarctica/Palmer                -03      -03:00:00   False …26/2025 12:45:23 PM
Antarctica/Rothera               -03      -03:00:00   False …26/2025 12:45:23 PM
Antarctica/Troll                 +00       00:00:00   False 3/26/2025 3:45:23 PM
Antarctica/Mawson                +05       05:00:00   False 3/26/2025 8:45:23 PM
Antarctica/Vostok                +05       05:00:00   False 3/26/2025 8:45:23 PM
Antarctica/Davis                 +07       07:00:00   False …26/2025 10:45:23 PM
Antarctica/Casey                 +08       08:00:00   False …26/2025 11:45:23 PM
Antarctica/Macquarie            AEDT       11:00:00    True 3/27/2025 2:45:23 AM
```

Get all time zone areas in Antarctica and pipe them to Get-TZData to retrieve the details.

### Example 4

```powershell
PS C:\> Get-TZData Europe/Rome | ConvertTo-LocalTime -Datetime "3/15/2020 4:00PM"

Saturday, March 15, 2025 11:00:00 AM
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

Learn more about PowerShell:https://jdhitsolutions.com/yourls/newsletter

## RELATED LINKS

[Get-TZList](Get-TZList.md)
