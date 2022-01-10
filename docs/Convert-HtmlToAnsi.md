---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version:
schema: 2.0.0
---

# Convert-HtmlToAnsi

## SYNOPSIS

Convert an HTML color code to ANSI.

## SYNTAX

```yaml
Convert-HtmlToAnsi [-HtmlCode] <String> [<CommonParameters>]
```

## DESCRIPTION

This simple function is designed to convert an HTML color code like #ff5733 into an ANSI escape sequence. To use the resulting value you still need to construct an ANSI string with the escape character and the closing [0m.

## EXAMPLES

### Example 1

```powershell
PS C:\> Convert-HtmlToAnsi  "#ff5733"

[38;2;255;87;51m
```

### Example 2

```powershell
PS C:\> "Running processes: `e$(cha "#ff337d")$((Get-Process).count)`e[0m"

Running processes: 306
```

The number of processes will be displayed in color. This example is using the cha alias for Convert-HtmlToAnsi.

## PARAMETERS

### -HtmlCode

Specify an HTML color code like #13A10E. You need to include the # character.

```yaml
Type: String
Parameter Sets: (All)
Aliases: code

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

## OUTPUTS

### System.String

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS
