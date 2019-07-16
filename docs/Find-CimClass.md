---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version: https://github.com/jdhitsolutions/PSScriptTools/blob/master/docs/Find-CimClass.md
schema: 2.0.0
---

# Find-CimClass

## SYNOPSIS

Search CIM for a class

## SYNTAX

```yaml
Find-CimClass [-Classname] <String> [-Exclude <String>] [-Computername <String>] [<CommonParameters>]
```

## DESCRIPTION

This function is designed to search an entire CIM repository for a class name. Sometimes, you may have a guess about a class name but not know the full name or even the correct namespace. Find-CimClass will recursively search for a given classname. You can use wildcards and search remote computers.

## EXAMPLES

### Example 1

```powershell
PS C:\> find-cimclass -Classname *protection*


   NameSpace: Root/CIMV2/mdm/dmmap

CimClassName                        CimClassMethods      CimClassProperties
------------                        ---------------      ------------------
MDM_AppLocker_EnterpriseDataProt... {}                   {InstanceID, ParentID, Policy}
MDM_AppLocker_EnterpriseDataProt... {}                   {InstanceID, ParentID, Policy}
MDM_EnterpriseDataProtection        {}                   {InstanceID, ParentID, Status}
MDM_EnterpriseDataProtection_Set... {}                   {AllowAzureRMSForEDP, AllowUserDecryption, DataRecoveryCert...
MDM_Policy_Config01_DataProtecti... {}                   {AllowDirectMemoryAccess, InstanceID, LegacySelectiveWipeID...
MDM_Policy_Result01_DataProtecti... {}                   {AllowDirectMemoryAccess, InstanceID, LegacySelectiveWipeID...
MDM_Reporting_EnterpriseDataProt... {}                   {InstanceID, LogCount, Logs, ParentID...}
MDM_Reporting_EnterpriseDataProt... {}                   {InstanceID, Logs, ParentID, StartTime...}
MDM_WindowsAdvancedThreatProtection {}                   {InstanceID, Offboarding, Onboarding, ParentID}
MDM_WindowsAdvancedThreatProtect... {}                   {GroupIds, InstanceID, ParentID, SampleSharing...}
MDM_WindowsAdvancedThreatProtect... {}                   {Criticality, Group, IdMethod, InstanceID...}
MDM_WindowsAdvancedThreatProtect... {}                   {InstanceID, LastConnected, OnboardingState, OrgId...}


   NameSpace: Root/Microsoft/SecurityClient

CimClassName                        CimClassMethods      CimClassProperties
------------                        ---------------      ------------------
ProtectionTechnologyStatus          {}                   {PackedXml, SchemaVersion, Enabled, Name...}
...
```

### Example 2

```powershell
PS C:\> find-cimclass -Classname *volume* -Exclude "win32_Perf*"
```

Search for any class with 'volume' in the name but exclude anything that starts with 'win32_Perf'.

## PARAMETERS

### -Classname

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
