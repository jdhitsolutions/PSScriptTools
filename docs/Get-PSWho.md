---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version: http://bit.ly/31SF1ne
schema: 2.0.0
---

# Get-PSWho

## SYNOPSIS

Get PowerShell user summary information.

## SYNTAX

```yaml
Get-PSWho [-AsString] [<CommonParameters>]
```

## DESCRIPTION

This command will provide a summary of relevant information for the current user in a PowerShell session. You might use this to troubleshoot an end-user problem running a script or command.

The default behavior is to write an object to the pipeline, but you can use the -AsString parameter to force the command to write a string. This makes it easier to use in your scripts with Write-Verbose.

## EXAMPLES

### EXAMPLE 1

```powershell
PS C:\> Get-PSWho

User            : Desk01\Jeff
Elevated        : False
Computername    : Desk01
OperatingSystem : Microsoft Windows 10 Pro [64-bit]
OSVersion       : 10.0.19042
PSVersion       : 5.1.19041.906
Edition         : Desktop
PSHost          : ConsoleHost
WSMan           : 3.0
ExecutionPolicy : RemoteSigned
Culture         : English (United States)
```

### EXAMPLE 2

```powershell
PS /home/jhicks> Get-PSWho

User            : jeff
Elevated        : False
Computername    : Desk01
OperatingSystem : Linux 5.4.72-microsoft-standard-WSL2 #1 SMP Wed Oct 28 23:40:43 UTC 2020
OSVersion       : Ubuntu 20.04.2 LTS
PSVersion       : 7.1.3
Edition         : Core
PSHost          : ConsoleHost
WSMan           : 3.0
ExecutionPolicy : Unrestricted
Culture         : Invariant Language (Invariant Country)
```

### EXAMPLE 3

```powershell
PS C:\> Get-PSWho

User            : DESK11\Jeff
Elevated        : True
Computername    : DESK11
OperatingSystem : Microsoft Windows 11 Pro [64-bit]
OSVersion       : 10.0.22623
PSVersion       : 7.3.3
Edition         : Core
PSHost          : ConsoleHost
WSMan           : 3.0
ExecutionPolicy : RemoteSigned
Culture         : English (United States)

```

### EXAMPLE 4

```powershell
PS C:\> Get-PSWho -asString | Set-Content c:\test\who.txt
```

## PARAMETERS

### -AsString

Write the summary object as a string. This can be useful when you want to save the information in a log file.

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

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### PSWho

### System.String

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Test-IsElevated](Test-IsElevated.md)

[Get-CimInstance]()

[Get-ExecutionPolicy]()

[$PSVersionTable]()

[Get-Host]()
