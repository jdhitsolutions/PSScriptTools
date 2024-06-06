---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version:
schema: 2.0.0
---

# Get-CimMember

## SYNOPSIS

Get information about CIM class members

## SYNTAX

### property (Default)

```yaml
Get-CimMember [[-ClassName] <String>] [-Property <String>] [-Namespace <String>] [-CimSession <CimSession>] [<CommonParameters>]
```

### method

```yaml
Get-CimMember [[-ClassName] <String>] -Method <String> [-Namespace <String>] [-CimSession <CimSession>] [<CommonParameters>]
```

## DESCRIPTION

This is a wrapper function that will invoke Get-CimClassProperty or Get-CimClassMethod based on the parameter set used. The default is to show all properties for a given class.

## EXAMPLES

### Example 1

```powershell
PS C:\> Get-CimMember -ClassName win32_volume

   Class: Root/Cimv2:Win32_Volume

Property                     ValueType   Flags
--------                     ---------   -----
Access                       UInt16      ReadOnly, NullValue
Automount                    Boolean     ReadOnly, NullValue
Availability                 UInt16      ReadOnly, NullValue
BlockSize                    UInt64      ReadOnly, NullValue
BootVolume                   Boolean     ReadOnly, NullValue
Capacity                     UInt64      ReadOnly, NullValue
Caption                      String      ReadOnly, NullValue
Compressed                   Boolean     ReadOnly, NullValue
...
```

The default is to show all properties for a given class.

### Example 2

```powershell
PS C:\> Get-CimMember -ClassName win32_Volume -Property q*

   Class: Root/Cimv2:Win32_Volume

Property         ValueType Flags
--------         --------- -----
QuotasEnabled    Boolean   ReadOnly, NullValue
QuotasIncomplete Boolean   ReadOnly, NullValue
QuotasRebuilding Boolean   ReadOnly, NullValue
```

You can filter the output by property name using wildcards.

### Example 3

```powershell
PS C:\> Get-CimMember -ClassName win32_bios -Method *
WARNING: No methods found for Root\Cimv2:WIN32_BIOS
```

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

The name of a CIM class.

```yaml
Type: String
Parameter Sets: (All)
Aliases: CimClassName

Required: False
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Method
Specify a method name.
Wildcards are permitted.

```yaml
Type: String
Parameter Sets: method
Aliases: Name

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Namespace
Specify the class namespace beginning with ROOT.

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
Specify a property name.
Wildcards are permitted.

```yaml
Type: String
Parameter Sets: property
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

### CimClassProperty

### CimClassMethod

## NOTES

## RELATED LINKS

[Get-CimClassProperty](Get-CimClassProperty.md)

[Get-CimClassMethod](Get-CimClassMethod.md)
