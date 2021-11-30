---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version:
schema: 2.0.0
---

# New-PSDynamicParameterForm

## SYNOPSIS

Launch a WPF front-end to New-PSDynamicParameter.

## SYNTAX

```yaml
New-PSDynamicParameterForm [<CommonParameters>]
```

## DESCRIPTION

This function will launch a WPF form that you can use to enter values for the New-PSDynamicParameter function. The resulting PowerShell code is copied to the clipboard so that you can paste it into your scripting editor. Mandatory settings are indicated with an asterisk. There should be tool tip help for every setting.

If you import the PSScriptTools module in the PowerShell ISE, you will get a menu shortcut under Add-Ins. If you import the module in VS Code using the integrated PowerShell terminal, it will a a new command.

## EXAMPLES

### Example 1

```powershell
PS C:\> New-PSDynamicParameterForm
```

## PARAMETERS

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### None

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[New-PSDynamicParameter](New-PSDynamicParameter.md)

[about_Functions_Advanced_Parameters]()
