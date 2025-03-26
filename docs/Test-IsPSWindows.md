---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version: https://jdhitsolutions.com/yourls/c102e6
schema: 2.0.0
---

# Test-IsPSWindows

## SYNOPSIS

Test if running PowerShell on a Windows platform.

## SYNTAX

```yaml
Test-IsPSWindows [<CommonParameters>]
```

## DESCRIPTION

PowerShell Core introduced the $IsWindows variable. However, it is not available on Windows PowerShell. Use this command to perform a simple test if the computer is either running Windows or using the Desktop PSEdition.

## EXAMPLES

### Example 1

```powershell
PS C:\> Test-IsPSWindows
True
```

## PARAMETERS

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Boolean

## NOTES

Learn more about PowerShell: https://jdhitsolutions.com/yourls/newsletter

## RELATED LINKS
