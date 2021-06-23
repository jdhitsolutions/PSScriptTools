---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version: https://bit.ly/3qqnX5p
schema: 2.0.0
---

# Show-FunctionItem

## SYNOPSIS

Show a function in written form.

## SYNTAX

```yaml
Show-FunctionItem [-Name] <String> [<CommonParameters>]
```

## DESCRIPTION

This command will display a loaded function as it might look in a code editor. You could use this command to export a loaded function to a file.

## EXAMPLES

### EXAMPLE 1

```powershell
PS C:\> Show-FunctionItem prompt

Function Prompt {

"PS $($executionContext.SessionState.Path.CurrentLocation)$('\>' * ($nestedPromptLevel + 1)) ";
# .Link
# https://go.microsoft.com/fwlink/?LinkID=225750
# .ExternalHelp System.Management.Automation.dll-help.xml

} #close prompt
```

### EXAMPLE 2

```powershell
PS C:\> Show-FunctionItem Copy-Zip | Out-File c:\Scripts\copy-zip.ps1
```

Here's how you can save or export a function you might have created on-the-fly to a file.

## PARAMETERS

### -Name

What is the name of your function?

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### String

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[New-FunctionItem](New-FunctionItem.md)
