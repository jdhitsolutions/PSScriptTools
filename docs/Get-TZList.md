---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version: http://bit.ly/31SFp5a
schema: 2.0.0
---

# Get-TZList

## SYNOPSIS

Get a list of time zone areas

## SYNTAX

### zone (Default)

```yaml
Get-TZList [-TimeZoneArea] <String> [<CommonParameters>]
```

### all

```yaml
Get-TZList [-All] [<CommonParameters>]
```

## DESCRIPTION

This command uses a free and publicly available REST API offered by http://worldtimeapi.org to get a list of time zone areas. You can get a list of all areas or by geographic location. Use Get-TZData to then retrieve details. You must have http access to the Internet for this command to work. Note that if the site is busy you may get an error. If that happens, wait a minute and try again.

## EXAMPLES

### Example 1

```powershell
PS C:\> Get-TZList -all

Africa/Abidjan
Africa/Accra
Africa/Algiers
Africa/Bissau
Africa/Cairo
...
```

Get a list of all time zone areas.

### Example 2

```powershell
PS C:\> Get-TZList Atlantic

Atlantic/Azores
Atlantic/Bermuda
Atlantic/Canary
Atlantic/Cape_Verde
Atlantic/Faroe
Atlantic/Madeira
Atlantic/Reykjavik
Atlantic/South_Georgia
Atlantic/Stanley
```

Get all time zone areas in the Atlantic region.

## PARAMETERS

### -All

Get a list of all timezone areas

```yaml
Type: SwitchParameter
Parameter Sets: all
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TimeZoneArea

Specify a time zone region.

```yaml
Type: String
Parameter Sets: zone
Aliases:
Accepted values: Africa, America, Antarctica, Asia, Atlantic, Australia, Europe, Indian, Pacific

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

### string

## NOTES

    Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Get-TZData](Get-TZData.md)
