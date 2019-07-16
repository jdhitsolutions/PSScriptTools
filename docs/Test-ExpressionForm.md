---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version: https://github.com/jdhitsolutions/PSScriptTools/blob/master/docs/Test-ExpressionForm.md
schema: 2.0.0
---

# Test-ExpressionForm

## SYNOPSIS

Display a graphical test form for Test-Expression.

## SYNTAX

```yaml
Test-ExpressionForm [<CommonParameters>]
```

## DESCRIPTION

This command will display a WPF-based form that you can use to enter in testing information. Testing intervals are in seconds. All of the values are then passed to the Test-Expression command. Results will be displayed in the form.

When you close the form, the last result object will be passed to the pipeline, including all metadata, the scriptblock and arguments.

## EXAMPLES

### Example 1

```powershell
PS C:\> test-expressionform
```

Launch the form.

## PARAMETERS

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/
This command was first explained at https://github.com/jdhitsolutions/Test-Expression/blob/master/docs/Test-ExpressionForm.md

## RELATED LINKS

[Test-Expression](./Test-Expression)

[Measure-Command]()
