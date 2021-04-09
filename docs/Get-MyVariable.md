---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version: http://bit.ly/31PAvFT
schema: 2.0.0
---

# Get-MyVariable

## SYNOPSIS

Get all user-defined variables.

## SYNTAX

```yaml
Get-MyVariable [[-Scope] <String>] [-NoTypeInformation] [<CommonParameters>]
```

## DESCRIPTION

This function will return all variables not defined by PowerShell or by this function itself. The default is to return all user-created variables from the global scope but you can also specify a scope such as script, local, or a number 0 through 5. The command will also display the value type for each variable. If you want to suppress this output use the -NoTypeInformation switch.


## EXAMPLES

### EXAMPLE 1

```powershell
PS C:\> Get-MyVariable

NName Value                  Type
---- -----                  ----
a    bits                   ServiceController
dt   10/22/2020 10:49:38 AM DateTime
foo  123                    Int32
r    {1, 2, 3, 4...}        Object[]
...
```

Depending on the value and how PowerShell chooses to display it, you may not see the type.

### EXAMPLE 2

```powershell
PS C:\> Get-MyVariable | Select-Object name,type

Name Type
---- ----
a    ServiceController
dt   DateTime
foo  Int32
r    Object[]
```

### EXAMPLE 3

```powershell
PS C:\> Get-MyVariable | Export-Clixml myvar.xml
PS C:\> import-clixml .\myvar.xml |
ForEach-Object {set-variable -Name $_.name -Value $_.value}
```

You can then import this XML file in another session to restore these variables.

### EXAMPLE 4

```powershell
PS C:\> function foo {
     c:\scripts\Get-MyVariable2.ps1;
     $a=4;$b=2;$c=$a*$b;
     Get-MyVariable -notypeinformation -scope 1 -verbose;
     $c
     }

PS C:\> foo
VERBOSE: Getting system defined variables
VERBOSE: Found 49
VERBOSE: Getting current variables in 1 scope
VERBOSE: Found 27
VERBOSE: Filtering variables

Name                           Value
----                           -----
a                              4
b                              2
c                              8
VERBOSE: Finished getting my variables
8
```

This sample function dot sources the script with this function. Within the function, Get-MyVariable is called specifying scope 1, or the parent scope. Scope 0 would be the scope of the Get-MyVariable function. Here's the result.

### EXAMPLE 5

```powershell
PS C:\> Get-MyVariable | where {$_.type -eq "Scriptblock"} |
Select-Object name,value

Name                               Value
----                               -----
bigp                               ps | where {$_.ws -gt 100mb}
dirt                               Param(\[string\]$Path=$env:temp) Get-C...
disk                               Param (\[string\]$computername=$env:co...
run                                gsv | where {$_.status -eq "running"}
up                                 Param(\[string\]$computername=$env:com...
```

 Get all my variables that are scriptblocks.

## PARAMETERS

### -Scope

The scope to query. The default is the Global scope but you can also specify Local, Script, Private or a number between 0 and 3 where 0 is the current scope, 1 is the parent scope, 2 is the grandparent scope, and so on.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: Global
Accept pipeline input: False
Accept wildcard characters: False
```

### -NoTypeInformation

If specified, suppress the type information for each variable value.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Management.Automation.PSVariable

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

An earlier version of this function is described at http://jdhitsolutions.com/blog/2012/05/get-my-variable-revisited

## RELATED LINKS

[Get-Variable]()

[About_Variables]()

[About_Scope]()
