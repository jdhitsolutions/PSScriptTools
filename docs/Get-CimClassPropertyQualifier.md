---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version:
schema: 2.0.0
---

# Get-CimClassPropertyQualifier

## SYNOPSIS

Get the property qualifiers of a CIM class.

## SYNTAX

```yaml
Get-CimClassPropertyQualifier [-ClassName] <String> [-Property <String>] [-Namespace <String>]
 [-CimSession <CimSession>] [<CommonParameters>]
```

## DESCRIPTION

This command is an alternative to Get-CimClass to make it easier to get information about property qualifiers of a WMI/CIM class. The default behavior is to query classes on the local host, but you can query a remote computer using the CimSession parameter. You can specify a computer name, or an existing CIMSession if you need alternate credentials.

## EXAMPLES

### Example 1

```powershell
PS C:\> Get-CimClassPropertyQualifier -ClassName Win32_Service -Property Name

   Property: Root/Cimv2:Win32_Service [Name]

Name Value CimType Flags
---- ----- ------- -----
key  True  Boolean DisableOverride, ToSubclass
read True  Boolean EnableOverride, ToSubclass
```

The default behavior is to show all qualifiers for all properties, but you are most likely to filter to subset of properties. The Property parameter supports wildcards.

## PARAMETERS

### -CimSession
Specify a computer name or an existing CimSession object.

```yaml
Type: CimSession
Parameter Sets: (All)
Aliases: CN

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -ClassName
Specify a CIM Class.

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

### -Namespace
Specify the class namespace beginning with Root\

```yaml
Type: String
Parameter Sets: (All)
Aliases: NS

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Property
Specify a property name. Wildcards are permitted.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: True
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

## OUTPUTS

### cimClassPropertyQualifier

## NOTES

## RELATED LINKS

[Get-CimClassProperty](Get-CimClassProperty.md)

[Get-CimClass]()
