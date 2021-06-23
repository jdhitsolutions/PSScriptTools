---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version: https://bit.ly/3xOCRFb
schema: 2.0.0
---

# Get-PSSessionInfo

## SYNOPSIS

Get details about the current PowerShell session

## SYNTAX

```yaml
Get-PSSessionInfo [<CommonParameters>]
```

## DESCRIPTION

This command will provide a snapshot of the current PowerShell session. The Runtime and Memory properties are defined by script so if you save the result to a variable, you will get current values everytime you look at the variable.

## EXAMPLES

### Example 1

```powershell
PS C:\> Get-PSSessionInfo

ProcessID   : 1112
Command     : "C:\Program Files\PowerShell\7\pwsh.exe" -noprofile
Host        : ConsoleHost
Started     : 4/9/2021 9:36:13 AM
PSVersion   : 7.1.3
Elevated    : True
Parent      : System.Diagnostics.Process (WindowsTerminal)
Runtime     : 00:31:26.2716486
MemoryMB    : 129
```

The Memory value is in MB. If running in a PowerShell console session, the Elevated value will be displayed in color.

### Example 2

```powershell
PS /home> Get-PSSessionInfo

ProcessID   : 71
Command     : pwsh
Host        : ConsoleHost
Started     : 04/09/2021 09:38:55
PSVersion   : 7.1.3
Elevated    : False
Parent      : System.Diagnostics.Process (bash)
Runtime     : 00:30:07.1669248
MemoryMB    : 133
```

The result from a Linux host.

## PARAMETERS

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### PSSessionInfo

## NOTES

This command has an alias of gsin.

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Get-Host]()

[Get-Process]()
