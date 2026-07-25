---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version: https://jdhitsolutions.com/yourls/f713ea
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

Use this command to find the path to the PowerShell executable, or engine that is running your current session. The default is to provide the path only. But you can also get detailed information

## EXAMPLES

### Example 1

```powershell
PS C:\> Get-PowerShellEngine
C:\WINDOWS\System32\WindowsPowerShell\v1.0\powershell.exe
```

### Example 2

```powershell
PS C:\> Get-PowerShellEngine -detail

Path           : C:\Program Files\PowerShell\7\pwsh.exe
FileVersion    : 7.5.0.500
PSVersion      : 7.5.0
ProductVersion : 7.5.0 SHA: 99dab561892364d82d4965068f7f8b175e768b1b+99dab561892364d82d4965068f7...
Edition        : Core
Host           : ConsoleHost
Culture        : en-US
Platform       : Win32NT
```

This result is from running in a PowerShell 7 session on Windows 11.

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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.String

### PSEngine

## NOTES

Learn more about PowerShell: https://jdhitsolutions.com/yourls/newsletter

## RELATED LINKS

[$PSVersionTable]()

[$Host]()

[Get-Process]()

[Get-PSWho](Get-PSWho.md)
