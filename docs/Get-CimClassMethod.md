---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version:
schema: 2.0.0
---

# Get-CimClassMethod

## SYNOPSIS

Get the methods of a CIM class.

## SYNTAX

```yaml
Get-CimClassMethod [-ClassName] <String> [-Method <String>] [-Namespace <String>] [-CimSession <CimSession>] [<CommonParameters>]
```

## DESCRIPTION

This command is an alternative to Get-CimClass to make it easier to get information about methods of a WMI/CIM class. The default behavior is to query classes on the local host, but you can query a remote computer using the CimSession parameter. You can specify a computer name, or an existing CIMSession if you need alternate credentials.

## EXAMPLES

### Example 1

```powershell
PS C:\> Get-CimClassMethod Win32_ComputerSystem

   Class: Root/Cimv2:Win32_ComputerSystem

Name                    ResultType Parameters
----                    ---------- ----------
JoinDomainOrWorkgroup   UInt32     {Name, Password, UserName, AccountOU…}
Rename                  UInt32     {Name, Password, UserName}
SetPowerState           UInt32     {PowerState, Time}
UnjoinDomainOrWorkgroup UInt32     {Password, UserName, FUnjoinOptions}
```

The default is to show all methods.

### Example 2

```powershell
PS C:\> Get-CimClassMethod Win32_ComputerSystem -Name Rename | Select-Object -ExpandProperty Parameters

Name     CimType Qualifiers ReferenceClassName
----     ------- ---------- ------------------
Name      String {ID, In}
Password  String {ID, In}
UserName  String {ID, In}
```

You can get a single method by name.

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

### -Method
Specify a method name.
Wildcards are permitted.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Name

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: True
```

### -Namespace
Specify the class namespace beginning with ROOT

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

## OUTPUTS

### CimClassMethod

## NOTES

## RELATED LINKS

[Get-CimMember](Get-CimMember.md)

[Get-CimClass]()
