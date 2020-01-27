---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version: http://bit.ly/31SKmLm
schema: 2.0.0
---

# Get-PowerShellEngine

## SYNOPSIS

Get the path to the current PowerShell engine.

## SYNTAX

```yaml
Get-PowerShellEngine [-Detail]
```

## DESCRIPTION

Use this command to find the path to the PowerShell executable, or engine that is running your current session. 
The default is to provide the path only. But you can also get detailed information

## EXAMPLES

### EXAMPLE 1

```powershell
PS C:\> Get-PowerShellEngine
```

C:\WINDOWS\System32\WindowsPowerShell\v1.0\powershell.exe

### EXAMPLE 2

```powershell
PS C:\> Get-PowerShellEngine -detail


Path           : C:\WINDOWS\System32\WindowsPowerShell\v1.0\powershell.exe
FileVersion    : 10.0.15063.0 (WinBuild.160101.0800)
PSVersion      : 5.1.15063.502
ProductVersion : 10.0.15063.0
Edition        : Desktop
Host           : Visual Studio Code Host
Culture        : en-US
Platform       :
```

Result from running in the Visual Studio Code integrated PowerShell terminal

### EXAMPLE 3

```powershell
PS C:\> Get-PowerShellEngine -detail


Path           : C:\Program Files\PowerShell\7-preview\pwsh.exe
FileVersion    : 7.0.0.0
PSVersion      : 7.0.0-rc.2
ProductVersion : 7.0.0-rc.2 SHA: d99b325861d3c15271367a0cece3037d76230e34
Edition        : Core
Host           : ConsoleHost
Culture        : en-US
Platform       : Win32NT
```

Result from running in a PowerShell 7 release candidate session on Windows 10

## PARAMETERS

### -Detail

Include additional information. Not all properties may have values depending on operating system and PowerShell version.

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

## INPUTS

## OUTPUTS

### [string]

### [PSCustomObject]

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[$PSVersionTable]()

[$Host]()

[Get-Process]()
