---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version: https://bit.ly/2Uy3Vu5
schema: 2.0.0
---

# Test-IsElevated

## SYNOPSIS

Test if the current user is running elevated.

## SYNTAX

```yaml
Test-IsElevated [<CommonParameters>]
```

## DESCRIPTION

This command will test if the current session is running elevated, or as Administrator. On Windows platforms, the command uses the NET Framework to determine if the user is running as Administrator. On non-Windows systems, the command is checking the user's UID value.

## EXAMPLES

### Example 1

```powershell
PS C:\> Test-IsElevated
True
```

## PARAMETERS

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### Boolean

## NOTES

Learn more about PowerShell: https://jdhitsolutions.com/yourls/newsletter

## RELATED LINKS

[Get-PSWho](Get-PSWho.md)
