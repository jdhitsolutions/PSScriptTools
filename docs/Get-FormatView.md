---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version: https://bit.ly/3dw2Nwo
schema: 2.0.0
---

# Get-FormatView

## SYNOPSIS

Get defined format views.

## SYNTAX

```yaml
Get-FormatView [[-TypeName] <String>] [[-PowerShellVersion] <Version>] [<CommonParameters>]
```

## DESCRIPTION

PowerShell's formatting system includes custom views that display objects in different ways. Unfortunately, this information is not readily available to a typical PowerShell user. Get-FormatView displays the available views for a given object type. You might get additional views when importing modules such as the PSScriptTools module. The result is there might be different views depending on if you use Format-Table, or Format-List. If you only see a single defined view, that is the default for that type of control.

## EXAMPLES

### Example 1

```powershell
PS C:\> Get-FormatView system.diagnostics.process


   Type: System.Diagnostics.Process

Format    Name
------    ----
Table     process
Table     Priority
Table     StartTime
Wide      process
Table     WS
```

The default view should be the first one listed for each format type. With this information, you can now run a command like `Get-Process | Format-Table -view Priority`. The WS view is added when you import the PSScriptTools module.

### Example 2

```powershell
PS C:\> (Get-Service bits).gettype() | Get-FormatView


   Type: System.ServiceProcess.ServiceController

Format    Name
------    ----
Table     service
List      System.ServiceProcess.ServiceController
Table     service
Table     Ansi
```

You can pipe a type name to the command.

### Example 3

```powershell
PS C:\> Get-FormatView | Where-Object Format -eq Table |
Group-Object typename | Where-Object count -gt 1  | Select-Object Name,
@{Name="Names";Expression = {$_.group.name}}

Name                                            Names
----                                            -----
FolderSizeInfo                                  {default, MB, GB, KB...}
gitsize                                         {mb, default}
ModuleCommand                                   {default, verb}
System.Diagnostics.Process                      {process, Priority, StartTime..
System.IO.DirectoryInfo                         {children, ansi}
System.IO.FileInfo                              {children, ansi}
System.Management.Automation.AliasInfo          {CommandInfo, AliasInfo, opti..
System.Management.Automation.ApplicationInfo    {CommandInfo, ApplicationInfo}
System.Management.Automation.ExternalScriptInfo {CommandInfo, ExternalScriptI..
System.Management.Automation.FilterInfo         {CommandInfo, FilterInfo}
System.Management.Automation.FunctionInfo       {CommandInfo, FunctionInfo}
System.Management.Automation.ScriptInfo         {CommandInfo, ScriptInfo}
System.ServiceProcess.ServiceController         {service, service, Ansi}
```

This example expression is getting all Table format views for types that have more than 1 defined. If a type only has a single view, that is the default which you are seeing already. The output you see here shows additional table views for different object types.

## PARAMETERS

### -TypeName

Specify a typename such as System.Diagnostics.Process.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: *
Accept pipeline input: True (ByValue)
Accept wildcard characters: True
```

### -PowerShellVersion

Specify the version of PowerShell this cmdlet gets for the formatting data. Enter a two-digit number separated by a period.

```yaml
Type: Version
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: your current PowerShell version
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### PSFormatView

## NOTES

This command relies on data provided by Get-FormatData. Some object types might be stored in PowerShell in unexpected ways. This command should have an alias of gfv.

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Get-FormatData]()

[Get-Member]()
