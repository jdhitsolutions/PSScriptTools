---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version: https://jdhitsolutions.com/yourls/078584
schema: 2.0.0
---

# Get-CimClassListing

## SYNOPSIS

A faster way to list CIM classes in a given namespace.

## SYNTAX

```yaml
Get-CimClassListing [[-Namespace] <String>] [[-Exclude] <String>] [[-CimSession] <CimSession>]
 [<CommonParameters>]
```

## DESCRIPTION

This command is a faster alternative to Get-CimClass. It will only list the class name and not the entire class object. You may find this useful when all you need is the class name. The command will filter out system properties that start with __.

## EXAMPLES

### Example 1

```powershell
PS C:\> Get-CimClassListing -Namespace Root\RSOP


   Namespace: Root/RSOP

ClassName
---------
CIM_ClassCreation
CIM_ClassDeletion
CIM_ClassIndication
CIM_ClassModification
CIM_Error
CIM_Indication
CIM_InstCreation
CIM_InstDeletion
CIM_InstIndication
CIM_InstModification
MSFT_ExtendedStatus
MSFT_WmiError
RsopLoggingModeProvider
RsopPlanningModeProvider
```

CimSystemProperties are excluded.

### Example 2

```powershell
PS C:\> Get-CimClassListing -Namespace Root\RSOP -Exclude cim*


   Namespace: Root/RSOP

ClassName
---------
MSFT_ExtendedStatus
MSFT_WmiError
RsopLoggingModeProvider
RsopPlanningModeProvider
```

You can exclude classnames using wildcards.

## PARAMETERS

### -CimSession

Specify a computer name or an existing CimSession object.

```yaml
Type: CimSession
Parameter Sets: (All)
Aliases: CN

Required: False
Position: 2
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Exclude

Enter a pattern for class names to EXCLUDE from the results.
You can use wildcards.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: True
```

### -Namespace

Specify the class namespace beginning with ROOT.

```yaml
Type: String
Parameter Sets: (All)
Aliases: NS

Required: False
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### Microsoft.Management.Infrastructure.CimSession

## OUTPUTS

### cimClassListing

## NOTES

Learn more about PowerShell: https://jdhitsolutions.com/yourls/newsletter

## RELATED LINKS

[Get-CimClass]()

[Get-CimClassMember](Get-CimClassMember.md)

[Find-CimClass](Find-CimClass.md)
