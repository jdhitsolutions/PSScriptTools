---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version: http://bit.ly/31Ut7JE
schema: 2.0.0
---

# Get-WhoIs

## SYNOPSIS

Lookup WhoIS data for a given IPv4 address.

## SYNTAX

```yaml
Get-WhoIs [-IPAddress] <String> [<CommonParameters>]
```

## DESCRIPTION

This command queries the ARIN database to lookup WhoIs information for a given IPv4 address.

## EXAMPLES

### Example 1

```powershell
PS C:\> get-whois 208.67.222.222 | Select-Object -Property *


IP                     : 208.67.222.222
Name                   : OPENDNS-NET-1
RegisteredOrganization : Cisco OpenDNS, LLC
City                   : San Francisco
StartAddress           : 208.67.216.0
EndAddress             : 208.67.223.255
NetBlocks              : 208.67.216.0/21
Updated                : 3/2/2012 8:03:18 AM
```

### Example 2

```powershell
PS C:\> '1.1.1.1','8.8.8.8','208.67.222.222'| get-whois

Name            IP             RegisteredOrganization                  NetBlocks       Updated
----            --             ----------------------                  ---------       -------
APNIC-1         1.1.1.1        Asia Pacific Network Information Centre 1.0.0.0/8       7/30/2010 8:23:43 AM
LVLT-GOGL-8-8-8 8.8.8.8        Google LLC                              8.8.8.0/24      3/14/2014 3:52:05 PM
OPENDNS-NET-1   208.67.222.222 Cisco OpenDNS, LLC                      208.67.216.0/21 3/2/2012 8:03:18 AM
```

## PARAMETERS

### -IPAddress

Enter a valid IPV4 address to lookup with WhoIs. It is assumed all of the octets are less than 254.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

## OUTPUTS

### WhoIsResult

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Invoke-RestMethod]()
