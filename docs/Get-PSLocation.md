---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version: https://github.com/jdhitsolutions/PSScriptTools/blob/master/docs/Get-PSLocation.md
schema: 2.0.0
---

# Get-PSLocation

## SYNOPSIS

Get common location values.

## SYNTAX

```yaml
Get-PSLocation
```

## DESCRIPTION

This command will write an object to the pipeline that displays the values of common file locations. You might find this helpful when scripting cross-platform.

## EXAMPLES

### EXAMPLE 1

```powershell
PS C:\> get-pslocation

Temp       : C:\Users\Jeff\AppData\Local\Temp\
Home       : C:\Users\Jeff\Documents
Desktop    : C:\Users\Jeff\Desktop
PowerShell : C:\Users\Jeff\Documents\WindowsPowerShell
```

Results on a Windows system.

### EXAMPLE 2

```powershell
PS C:\> get-pslocation

Temp       : /tmp/
Home       : /home/jeff
Desktop    :
PowerShell : /home/jeff/.config/powershell
```

Results on a Linux system running PowerShell Core.

## PARAMETERS

## INPUTS

### None

## OUTPUTS

### System.Object

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Get-Location]()
