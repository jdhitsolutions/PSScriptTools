---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version: https://jdhitsolutions.com/yourls/650472
schema: 2.0.0
---

# Get-MyVariable

## SYNOPSIS

Get all user-defined variables.

## SYNTAX

```yaml
Get-MyVariable [[-Scope] <String>] [-IncludeTypeInformation] [<CommonParameters>]
```

## DESCRIPTION

This function will return all variables not defined by PowerShell or by this function itself. The default is to return all user-created variables from the global scope but you can also specify a scope such as script, local, or a number 0 through 5. The command will also display the value type for each variable.

Beginning with version 3.1.0, you can opt in and include a script property that shows the variable type name. This is a breaking change from the previous -NoTypeInformation parameter.

## EXAMPLES

### Example 1

```powershell
PS C:\> Get-MyVariable

Name                           Value
----                           -----
dt                             10/29/2025 2:19:40 PM
j                              {AarSvc_9521e3b, ADPSvc, ALG, AppIDSvc…}
n                              foo
PSSamplePath                   C:\scripts\PSScriptTools\Samples
PSSpecialChar                  {[DarkShade, ▓], [Section, §], [DownTriangle, ▼]…
var                            123
...
```

Get all variables defined by the user in the global scope.

### Example 2

```powershell
PS C:\> Get-MyVariable -IncludeTypeInformation | Select-Object Name,Type,Value

Name          Type      Value
----          ----      -----
dt            DateTime  10/29/2025 2:19:40 PM
j             Object[]  {AarSvc_9521e3b, ADPSvc, ALG, AppIDSvc…}
n             String    foo
PSSamplePath  String    C:\scripts\PSScriptTools\Samples
PSSpecialChar Hashtable {[DarkShade, ▓], [Section, §], [DownTriangle, ▼], [Blac…
var           Int32     123
```

Get user defined variable and show the corresponding type name.

### Example 3

```powershell
PS C:\> Get-MyVariable | Export-Clixml MyVar.xml
PS C:\> Import-Clixml .\MyVar.xml | ForEach-Object {Set-Variable -Name $_.name -Value $_.value}
```

You can then import this XML file in another session to restore these variables.

### Example 4

```powershell
PS C:\> function foo {
     c:\scripts\Get-MyVariable2.ps1;
     $a=4;$b=2;$c=$a*$b;
     Get-MyVariable  -scope 1 -verbose;
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

### Example 5

```powershell
PS C:\> Get-MyVariable | where {$_.type -eq "Scriptblock"} | Select-Object name,value

Name                               Value
----                               -----
bigp                               ps | where {$_.ws -gt 100mb}
dirt                               Param(\[string\]$Path=$env:temp) Get-C...
disk                               Param (\[string\]$computername=$env:co...
run                                gsv | where {$_.status -eq "running"}
up                                 Param(\[string\]$computername=$env:com...
```

 Get all my variables that are script blocks.

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

### -IncludeTypeInformation

Add a script property that displays the corresponding type name of the variable. This parameter was added in version 3.1.0.

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

### None

## OUTPUTS

### System.Management.Automation.PSVariable

## NOTES

Learn more about PowerShell: https://jdhitsolutions.com/yourls/newsletter

## RELATED LINKS

[Get-Variable]()

[About_Variables]()

[About_Scope]()
