---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version: https://bit.ly/3sKBrcR
schema: 2.0.0
---

# Get-PSAnsiFileMap

## SYNOPSIS

Display the PSAnsiFileMap

## SYNTAX

```yaml
Get-PSAnsiFileMap [<CommonParameters>]
```

## DESCRIPTION

Use this command to display the PSAnsiFileMap global variable. The Ansi pattern will be shown using the pattern.

## EXAMPLES

### Example 1

```powershell
PS C:\> Get-PSAnsiFileMap

Description  Pattern                     ANSI
-----------  -------                     ----
PowerShell   \.((ps(d|m)?1)|(ps1xml))$   `e[38;2;252;127;12m`e[38;2;252;127;12m
Text         \.((txt)|(log)|(htm(l)?))$  `e[38;2;58;120;255m`e[38;2;58;120;255m
...
```

The  output will display the ANSI sequence using the sequence itself. The escape character will be based on the version of PowerShell you are using. This example shows output from PowerShell 7.

## PARAMETERS

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### PSAnsiFileEntry

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Set-PSAnsiFileMap](Set-PSAnsiFilemap.md)
