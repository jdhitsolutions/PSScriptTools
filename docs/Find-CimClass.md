---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version: http://bit.ly/31SEzp2
schema: 2.0.0
---

# Find-CimClass

## SYNOPSIS

Search CIM for a class.

## SYNTAX

```yaml
Find-CimClass [-ClassName] <String> [-Exclude <String>]
[-Computername <String>] [<CommonParameters>]
```

## DESCRIPTION

This function is designed to search an entire CIM repository for a class name. Sometimes, you can guess a CIM/WMI class name but not know the full name or even the correct namespace. Find-CimClass will recursively search for a given class name in all namespaces. You can use wildcards and search remote computers.

This command requires a Windows platform.

## EXAMPLES

### Example 1

```powershell
PS C:\> Find-CimClass -ClassName *protection*


   NameSpace: Root/CIMV2/mdm/dmmap

CimClassName                        CimClassMethods      CimClassProperties
------------                        ---------------      ------------------
MDM_AppLocker_EnterpriseDataProt... {}                   {InstanceID, Parent...
MDM_AppLocker_EnterpriseDataProt... {}                   {InstanceID, Parent...
MDM_EnterpriseDataProtection        {}                   {InstanceID, Parent...
MDM_EnterpriseDataProtection_Set... {}                   {AllowAzureRMSForED...
MDM_Policy_Config01_DataProtecti... {}                   {AllowDirectMemoryA...
MDM_Policy_Result01_DataProtecti... {}                   {AllowDirectMemoryA...
MDM_Reporting_EnterpriseDataProt... {}                   {InstanceID, LogCou...
MDM_Reporting_EnterpriseDataProt... {}                   {InstanceID, Logs, ...
MDM_WindowsAdvancedThreatProtection {}                   {InstanceID, Offboa...
MDM_WindowsAdvancedThreatProtect... {}                   {GroupIds, Instance...
MDM_WindowsAdvancedThreatProtect... {}                   {Criticality, Grou ...
MDM_WindowsAdvancedThreatProtect... {}                   {InstanceID, LastCo...


   NameSpace: Root/Microsoft/SecurityClient

CimClassName                        CimClassMethods      CimClassProperties
------------                        ---------------      ------------------
ProtectionTechnologyStatus          {}                   {PackedXml, SchemaV...
...
```

### Example 2

```powershell
PS C:\> Find-CimClass -ClassName *volume* -Exclude "win32_Perf*"
```

Search for any class with 'volume' in the name but exclude anything that starts with 'win32_Perf'.

## PARAMETERS

### -ClassName

Enter the name of a CIM/WMI class. Wildcards are permitted.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: True
```

### -Computername

Enter the name of a computer to search.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: localhost
Accept pipeline input: False
Accept wildcard characters: False
```

### -Exclude

Enter a pattern for class names to EXCLUDE from the results. You can use wildcards or regular expressions.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### Microsoft.Management.Infrastructure.CimClass

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources

## RELATED LINKS

[Get-CimClass]()
