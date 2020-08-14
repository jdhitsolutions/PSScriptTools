---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version: http://bit.ly/31XfFER
schema: 2.0.0
---

# Get-ParameterInfo

## SYNOPSIS

Retrieve command parameter information.

## SYNTAX

```yaml
Get-ParameterInfo [-Command] <String> [-Parameter <String>]
[<CommonParameters>]
```

## DESCRIPTION

Using Get-Command, this function will return information about parameters for any loaded cmdlet or function. The common parameters like Verbose and ErrorAction are omitted. Get-ParameterInfo returns a custom object with the most useful information an administrator might need to know. See examples.

## EXAMPLES

### EXAMPLE 1

```powershell
PS C:\> Get-ParameterInfo Get-Service


   ParameterSet: Default


Name                            : Name
Aliases                         : ServiceName
Mandatory                       : False
IsDynamic                       : False
Position                        : 0
Type                            : System.String[]
ValueFromPipeline               : True
ValueFromPipelineByPropertyName : True



   ParameterSet: __AllParameterSets


Name                            : ComputerName
Aliases                         : Cn
Mandatory                       : False
IsDynamic                       : False
Position                        : Named
Type                            : System.String[]
ValueFromPipeline               : False
ValueFromPipelineByPropertyName : True

Name                            : DependentServices
Aliases                         : DS
Mandatory                       : False
IsDynamic                       : False
Position                        : Named
Type                            : System.Management.Automation.SwitchParameter
ValueFromPipeline               : False
ValueFromPipelineByPropertyName : False
...
```

Return parameter information for Get-Service using the default list view.

### EXAMPLE 2

```powershell
PS C:\> Get-ParameterInfo mkdir |
Select-Object Name,Type,Position,parameterset

Name           Type                                 Position ParameterSet
----           ----                                 -------- ------------
Path           System.String[]                             0 pathSet
Path           System.String[]                             0 nameSet
Name           System.String                           Named nameSet
Value          System.Object                           Named __AllParameterSets
Force          System.Management.Automation.Switch...  Named __AllParameterSets
Credential     System.Management.Automation.PSCred...  Named __AllParameterSets
UseTransaction System.Management.Automation.Switch...  Named __AllParameterSets
```

Get selected parameter information for the mkdir command.

### EXAMPLE 3

```powershell
PS C:\> Get-ParameterInfo Test-WSMan | Sort Parameterset | Format-Table


   ParameterSet: __AllParameterSets

Name                  Aliases Mandatory Position Type
----                  ------- --------- -------- ----
CertificateThumbprint         False     Named    System.String
Credential            cred,c  False     Named    System.Management.Automati...
ComputerName          cn      False     0        System.String
Authentication        auth,am False     Named    Microsoft.WSMan.Management....


   ParameterSet: ComputerName

Name            Aliases Mandatory Position Type
----            ------- --------- -------- ----
UseSSL                  False     Named    System.Management.Automation.Swit...
Port                    False     Named    System.Int32
ApplicationName         False     Named    System.String
```

Get all parameters from Test-WSMan and display details as a formatted table. The object type from Get-ParameterInfo has a default table view.

### Example 4

```powershell
PS C:\> Get-ParameterInfo -Command Get-Counter -Parameter computername

   ParameterSet: __AllParameterSets


Name                            : computername
Aliases                         : Cn
Mandatory                       : False
IsDynamic                       : False
Position                        : Named
Type                            : System.String[]
ValueFromPipeline               : False
ValueFromPipelineByPropertyName : False
```

Get details on the Computername parameter of the Get-Counter cmdlet.

## PARAMETERS

### -Command

The name of a cmdlet or function. The parameter has an alias of Name.

```yaml
Type: String
Parameter Sets: (All)
Aliases: name

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -Parameter

{{Fill Parameter Description}}

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

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### [string]

## OUTPUTS

### PSParameterInfo

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Get-Command]()
