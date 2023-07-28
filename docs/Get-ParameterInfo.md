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
PS C:\>  Get-ParameterInfo Export-Clixml

   ParameterSet: __AllParameterSets

Name            Aliases         Mandatory    Position    Type
----            -------         ---------    --------    ----
Depth                           False        Named       System.Int32
InputObject                     True         Named       System.Management.Automation.PSObject
Force                           False        Named       System.Management.Automation.SwitchParamet…
NoClobber       NoOverwrite     False        Named       System.Management.Automation.SwitchParamet…
Encoding                        False        Named       System.Text.Encoding

   ParameterSet: ByLiteralPath

Name            Aliases         Mandatory    Position    Type
----            -------         ---------    --------    ----
LiteralPath     PSPath,LP       True         Named       System.String

   ParameterSet: ByPath

Name            Aliases         Mandatory    Position    Type
----            -------         ---------    --------    ----
Path                            True         0           System.String
```

Return parameter information for Export-Clixml using the default table view.

### EXAMPLE 2

```powershell
PS C:\> Get-ParameterInfo mkdir | Select-Object Name,Type,Position,parameterset

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
PS C:\> Get-ParameterInfo Test-WSMan | Format-List

   ParameterSet: __AllParameterSets

Name                            : ComputerName
Aliases                         : cn
Mandatory                       : False
IsDynamic                       : False
Position                        : 0
Type                            : System.String
ValueFromPipeline               : True
ValueFromPipelineByPropertyName : False

Name                            : Authentication
Aliases                         : auth,am
Mandatory                       : False
IsDynamic                       : False
Position                        : Named
Type                            : Microsoft.WSMan.Management.AuthenticationMecha
                                  nism
ValueFromPipeline               : False
ValueFromPipelineByPropertyName : False

Name                            : Credential
Aliases                         : cred,c
Mandatory                       : False
IsDynamic                       : False
Position                        : Named
Type                            : System.Management.Automation.PSCredential
ValueFromPipeline               : False
ValueFromPipelineByPropertyName : True

Name                            : CertificateThumbprint
Aliases                         :
Mandatory                       : False
IsDynamic                       : False
Position                        : Named
Type                            : System.String
ValueFromPipeline               : False
ValueFromPipelineByPropertyName : False


   ParameterSet: ComputerName

Name                            : Port
Aliases                         :
Mandatory                       : False
IsDynamic                       : False
Position                        : Named
Type                            : System.Int32
ValueFromPipeline               : False
ValueFromPipelineByPropertyName : False

Name                            : UseSSL
Aliases                         :
Mandatory                       : False
IsDynamic                       : False
Position                        : Named
Type                            : System.Management.Automation.SwitchParameter
ValueFromPipeline               : False
ValueFromPipelineByPropertyName : False

Name                            : ApplicationName
Aliases                         :
Mandatory                       : False
IsDynamic                       : False
Position                        : Named
Type                            : System.String
ValueFromPipeline               : False
ValueFromPipelineByPropertyName : False

```

Get all parameters from Test-WSMan and display details as a list.

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

### System.String

## OUTPUTS

### PSParameterInfo

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Get-Command]()

[Get-CommandSyntax](Get-CommandSyntax.md)
