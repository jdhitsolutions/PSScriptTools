---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version: https://jdhitsolutions.com/yourls/1e55c2
schema: 2.0.0
---

# Get-PSLocation

## SYNOPSIS

Get common location values.

## SYNTAX

```yaml
Get-PSLocation [<CommonParameters>]
```

## DESCRIPTION

This command will write an object to the pipeline that displays the values of common file locations. You might find this helpful when scripting cross-platform.

## EXAMPLES

### Example 1

```powershell
PS C:\> Get-PSLocation

Temp       : C:\Users\Jeff\AppData\Local\Temp\
Home       : C:\Users\Jeff\Documents
Desktop    : C:\Users\Jeff\Desktop
PowerShell : C:\Users\Jeff\Documents\WindowsPowerShell
PSHome     : C:\Windows\System32\WindowsPowerShell\v1.0
```

Results on a Windows system.

### Example 2

```powershell
PS C:\> Get-PSLocation

Temp       : /tmp/
Home       : /home/jeff
Desktop    :
PowerShell : /home/jeff/.config/powershell
PSHome     : /opt/microsoft/powershell/7
```

Results on a Linux system running PowerShell.

## PARAMETERS

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### PSLocation

## NOTES

Learn more about PowerShell: https://jdhitsolutions.com/yourls/newsletter

## RELATED LINKS

[Get-Location]()

[Set-Location]()
