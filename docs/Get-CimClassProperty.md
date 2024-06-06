---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version:
schema: 2.0.0
---

# Get-CimClassProperty

## SYNOPSIS

Get the properties of a CIM class.

## SYNTAX

### property (Default)

```yaml
Get-CimClassProperty [-ClassName] <String> [-Namespace <String>] [-Property <String>]
 [-CimSession <CimSession>] [<CommonParameters>]
```

### key

```yaml
Get-CimClassProperty [-ClassName] <String> [-Namespace <String>] [-KeyOnly] [-CimSession <CimSession>] [<CommonParameters>]
```

## DESCRIPTION

This command is an alternative to Get-CimClass to make it easier to get information about properties of a WMI/CIM class. The default behavior is to query classes on the local host, but you can query a remote computer using the CimSession parameter. You can specify a computer name, or an existing CIMSession if you need alternate credentials.

## EXAMPLES

### Example 1

```powershell
PS C:\> Get-CimClassProperty Win32_ace

   Class: Root/Cimv2:Win32_ACE

Property                ValueType Flags
--------                --------- -----
AccessMask              UInt32    NullValue
AceFlags                UInt32    NullValue
AceType                 UInt32    NullValue
GuidInheritedObjectType String    NullValue
GuidObjectType          String    NullValue
TIME_CREATED            UInt64    NullValue
Trustee                 Instance  NullValue
```

The default is to get all properties. Key properties, if defined, will be highlighted in the output.

### Example 2

```powershell
PS C:\> Get-CimClassProperty Win32_OperatingSystem -Property *memory*

   Class: Root/Cimv2:Win32_OperatingSystem

Property               ValueType Flags
--------               --------- -----
FreePhysicalMemory     UInt64    ReadOnly, NullValue
FreeVirtualMemory      UInt64    ReadOnly, NullValue
MaxProcessMemorySize   UInt64    ReadOnly, NullValue
TotalVirtualMemorySize UInt64    ReadOnly, NullValue
TotalVisibleMemorySize UInt64    ReadOnly, NullValue
```

You can use wildcards to filter properties.

### Example 3

```powershell
PS C:\> Get-CimClassProperty win32_process -KeyOnly

   Class: Root/Cimv2:Win32_Process

Property ValueType Flags
-------- --------- -----
Handle   String    Key, ReadOnly, NullValue
```

You can limit the results to key properties only.

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
Specify a CIM Class

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

### -KeyOnly
Only show Key properties

```yaml
Type: SwitchParameter
Parameter Sets: key
Aliases:

Required: False
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

## NOTES

## RELATED LINKS

[Get-CimMember](Get-CimMember.md)

[Get-CimClass]()