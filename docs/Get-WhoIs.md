---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version: https://jdhitsolutions.com/yourls/a244fa
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
PS C:\> Get-WhoIs 208.67.222.222 | Select-Object -Property *

IP                     : 208.67.222.222
Name                   : OPENDNS-NET-1
RegisteredOrganization : Cisco OpenDNS, LLC
City                   : San Jose
StartAddress           : 208.67.216.0
EndAddress             : 208.67.223.255
NetBlocks              : 208.67.216.0/21
Updated                : 12/14/2021 8:28:33 PM
```

### Example 2

```powershell
PS C:\> '1.1.1.1','8.8.8.8','208.67.222.222'| Get-WhoIs | Select Name,IP,RegisteredOrganization

Name          IP             RegisteredOrganization
----          --             ----------------------
APNIC-1       1.1.1.1        Asia Pacific Network Information Centre
GOGL          8.8.8.8        Google LLC
OPENDNS-NET-1 208.67.222.222 Cisco OpenDNS, LLC
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

Learn more about PowerShell: https://jdhitsolutions.com/yourls/newsletter

## RELATED LINKS

[Invoke-RestMethod]()
