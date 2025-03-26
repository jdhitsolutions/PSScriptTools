---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version: https://jdhitsolutions.com/yourls/98d08a
schema: 2.0.0
---

# ConvertTo-LexicalTimespan

## SYNOPSIS

Convert a timespan to lexical time.

## SYNTAX

```yaml
ConvertTo-LexicalTimespan [-Timespan] <TimeSpan> [<CommonParameters>]
```

## DESCRIPTION

Convert a timespan into a lexical version that you can insert into an XML document.

## EXAMPLES

### Example 1

```powershell
PS C:\> ConvertTo-LexicalTimespan (New-Timespan -Days 7)

P7D
```

You can insert this value into an XML document where you need to represent a time-span.

## PARAMETERS

### -Timespan

Enter a timespan object

```yaml
Type: TimeSpan
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

### System.TimeSpan

## OUTPUTS

### String

## NOTES

Learn more about PowerShell: https://jdhitsolutions.com/yourls/newsletter

## RELATED LINKS

[ConvertFrom-LexicalTimespan](ConvertFrom-LexicalTimespan.md)
