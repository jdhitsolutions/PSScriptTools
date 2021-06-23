---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version: https://bit.ly/3gQclWl
schema: 2.0.0
---

# ConvertTo-TitleCase

## SYNOPSIS

Convert a string to title case.

## SYNTAX

```yaml
ConvertTo-TitleCase [-Text] <String> [<CommonParameters>]
```

## DESCRIPTION

This command is a simple function to convert a string to title or proper case.

## EXAMPLES

### Example 1

```powershell
PS C:\> ConvertTo-TitleCase "working summary"

Working Summary
```

### Example 2

```powershell
PS C:\> "art deco","jack frost","al fresco" | ConvertTo-TitleCase

Art Deco
Jack Frost
Al Fresco
```

## PARAMETERS

### -Text

Text to convert to title case.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

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

## RELATED LINKS
