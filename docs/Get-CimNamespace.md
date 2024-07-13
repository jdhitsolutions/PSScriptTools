---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version:
schema: 2.0.0
---

# Get-CimNamespace

## SYNOPSIS

Enumerate WMI/CIM namespaces.

## SYNTAX

```
Get-CimNamespace [[-Namespace] <String>] [-TopLevelOnly] [-CimSession <CimSession>] [<CommonParameters>]
```

## DESCRIPTION

You can use this command to enumerate all WMI/CIM namespaces on a computer starting from ROOT. The default behavior is to recursively enumerate on the local machine, but you can query a remote computer. If you need to support alternate credentials, create a CIMSession and pass it to the command.

## EXAMPLES

### Example 1

```powershell
PS C:\> Get-CimNamespace

Root\subscription
Root\subscription\ms_41d
Root\subscription\ms_409
Root\DEFAULT
Root\DEFAULT\ms_41d
Root\DEFAULT\ms_409
Root\CIMV2
Root\CIMV2\mdm
Root\CIMV2\mdm\dmmap
...
```

Output is written to the pipeline as it is discovered.

### Example 2

```powershell
PS C:\> Get-CimNamespace -Namespace root\cimv2 -TopLevelOnly
root\cimv2\mdm
root\cimv2\Security
root\cimv2\vs
root\cimv2\ms_41d
root\cimv2\power
root\cimv2\ms_409
root\cimv2\TerminalServices
root\cimv2\NV
```

Only get top-level namespaces under the specified namespace.

## PARAMETERS

### -CimSession
Specify a CimSession object.

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

### -Namespace
Specify the root namespace to query.
The default is Root.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TopLevelOnly
Only list the top-level namespaces under the specified namespace.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

## OUTPUTS

### System.String

## NOTES

Learn more about PowerShell:
http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Get-CimMember](Get-CimMember.md)

[Get-CimClassMethod](Get-CimClassMethod.md)

[Get-CimClassProperty](Get-CimClassProperty.md)