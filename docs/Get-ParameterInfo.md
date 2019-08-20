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
Get-ParameterInfo [-Command] <String> [-Parameter <String>] [<CommonParameters>]
```

## DESCRIPTION

Using Get-Command, this function will return information about parameters for any loaded cmdlet or function. The common parameters like Verbose and ErrorAction are omitted. Get-ParameterInfo returns a custom object with the most useful information an administrator might need to know. See examples.

## EXAMPLES

### EXAMPLE 1

```powershell
PS C:\> get-parameterinfo get-service


Name                            : Name
Aliases                         : ServiceName
Mandatory                       : False
Position                        : 0
ValueFromPipeline               : True
ValueFromPipelineByPropertyName : True
Type                            : System.String[]
IsDynamic                       : False
ParameterSet                    : Default

Name                            : ComputerName
Aliases                         : Cn
Mandatory                       : False
Position                        : Named
ValueFromPipeline               : False
ValueFromPipelineByPropertyName : True
Type                            : System.String[]
IsDynamic                       : False
ParameterSet                    : __AllParameterSets

Name                            : DependentServices
Aliases                         : DS
Mandatory                       : False
Position                        : Named
ValueFromPipeline               : False
ValueFromPipelineByPropertyName : False
Type                            : System.Management.Automation.SwitchParameter
IsDynamic                       : False
ParameterSet                    : __AllParameterSets

Name                            : RequiredServices
Aliases                         : SDO,ServicesDependedOn
Mandatory                       : False
Position                        : Named
ValueFromPipeline               : False
ValueFromPipelineByPropertyName : False
Type                            : System.Management.Automation.SwitchParameter
IsDynamic                       : False
ParameterSet                    : __AllParameterSets

Name                            : DisplayName
Aliases                         :
Mandatory                       : True
Position                        : Named
ValueFromPipeline               : False
ValueFromPipelineByPropertyName : False
Type                            : System.String[]
IsDynamic                       : False
ParameterSet                    : DisplayName

Name                            : Include
Aliases                         :
Mandatory                       : False
Position                        : Named
ValueFromPipeline               : False
ValueFromPipelineByPropertyName : False
Type                            : System.String[]
IsDynamic                       : False
ParameterSet                    : __AllParameterSets

Name                            : Exclude
Aliases                         :
Mandatory                       : False
Position                        : Named
ValueFromPipeline               : False
ValueFromPipelineByPropertyName : False
Type                            : System.String[]
IsDynamic                       : False
ParameterSet                    : __AllParameterSets

Name                            : InputObject
Aliases                         :
Mandatory                       : False
Position                        : Named
ValueFromPipeline               : True
ValueFromPipelineByPropertyName : False
Type                            : System.ServiceProcess.ServiceController[]
IsDynamic                       : False
ParameterSet                    : InputObject
```

Return parameter information for Get-Service

### EXAMPLE 2

```powershell
PS C:\> get-parameterinfo mkdir  | Select Name,Type,Position,parameterset

Name           Type                                         Position ParameterSet
----           ----                                         -------- ------------
Path           System.String[]                                     0 pathSet
Path           System.String[]                                     0 nameSet
Name           System.String                                   Named nameSet
Value          System.Object                                   Named __AllParameterSets
Force          System.Management.Automation.SwitchParameter    Named __AllParameterSets
Credential     System.Management.Automation.PSCredential       Named __AllParameterSets
UseTransaction System.Management.Automation.SwitchParameter    Named __AllParameterSets
```

Get selected parameter information for the mkdir command.

### EXAMPLE 3

```powershell
PS C:\> get-parameterinfo get-ciminstance | sort parameterset | format-table -GroupBy ParameterSet -Property Name,Mandatory,Alias,Position,Type

   ParameterSet: __AllParameterSets

Name                Mandatory Alias Position Type
----                --------- ----- -------- ----
OperationTimeoutSec     False       Named    System.UInt32


   ParameterSet: CimInstanceComputerSet

Name         Mandatory Alias Position Type
----         --------- ----- -------- ----
ResourceUri      False       Named    System.Uri
InputObject       True       0        Microsoft.Management.Infrastructure.CimInstance
ComputerName     False       Named    System.String[]


   ParameterSet: CimInstanceSessionSet

Name        Mandatory Alias Position Type
----        --------- ----- -------- ----
CimSession       True       Named    Microsoft.Management.Infrastructure.CimSession[]
InputObject      True       0        Microsoft.Management.Infrastructure.CimInstance
ResourceUri     False       Named    System.Uri...
```

Get all parameters from Get-CimInstance and display details as a formatted table.

### Example 4

```powershell
PS C:\> Get-ParameterInfo -Command Get-Counter -Parameter computername


Name                            : computername
Aliases                         : Cn
Mandatory                       : False
Position                        : Named
ValueFromPipeline               : False
ValueFromPipelineByPropertyName : False
Type                            : System.String[]
IsDynamic                       : False
ParameterSet                    : __AllParameterSets
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

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### [string]

## OUTPUTS

### custom object

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Get-Command]()
