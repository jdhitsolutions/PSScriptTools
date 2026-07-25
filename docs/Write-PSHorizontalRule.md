---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version: https://jdhitsolutions.com/yourls/3c2bd6
schema: 2.0.0
---

# Write-PSHorizontalRule

## SYNOPSIS

Write a horizontal rule line.

## SYNTAX

```yaml
Write-PSHorizontalRule [[-Width] <Int32>] [-LineWeight <psRuleWeight>] [-Style <String>]
[-Title <String>] [-Alignment <psRuleAlignment>] [-TitleStyle <psRuleTextStyle[]>]
[<CommonParameters>]
```

## DESCRIPTION

This command is used to write a horizontal rule line in the console. The rule line is colored using ANSI. You can specify any ANSI or PSStyle foreground sequence as the style. The default is a thin line, but you can create a thick like using the LineWeight parameter. The default line length is the console width.

Optionally, you can insert a title or caption. By default, the caption will be set to the left, but you can adjust the alignment and style.

## EXAMPLES

### Example 1

```powershell
PS C:\> Write-PSHorizontalRule
```

Write a thin green line the width of the PowerShell console.

### Example 2

```powershell
PS C:\> Write-PSHorizontalRule -Title (Get-Date) -Style $PSStyle.Foreground.Magenta
-TitleStyle italic -Width 50
```

Create a 50 character line with the current date time as an italicized title. The color will be magenta.

### Example 3

```powershell
PS C:\> Write-PSHorizontalRule -Title $env:Computername -Style "`e[38;5;130m"
-TitleStyle bold,blink -LineWeight Thick -Alignment Center
```

Create a brown thick line with the computer name blinking in bold and centered.

## PARAMETERS

### -Alignment

Specify the title alignment. This will have no effect unless you specify a title. Centered text is approximate and might shorten the line by a few characters.

```yaml
Type: psRuleAlignment
Parameter Sets: (All)
Aliases:
Accepted values: Left, Center, Right

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LineWeight

Specify the line weight.

```yaml
Type: psRuleWeight
Parameter Sets: (All)
Aliases: Weight
Accepted values: Thin, Thick

Required: False
Position: Named
Default value: Thin
Accept pipeline input: False
Accept wildcard characters: False
```

### -Style

Specify an ANSI or $PSStyle.Foreground setting for the line color. The default is BrightGreen.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: BrightGreen
Accept pipeline input: False
Accept wildcard characters: False
```

### -Title

Specify an optional caption or title.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Caption

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TitleStyle

Specify an optional text style for the title. This will have no effect without a title. The default is none. You can specify multiple value to combine them. The Underline style is intentionally omitted.

```yaml
Type: psRuleTextStyle[]
Parameter Sets: (All)
Aliases:
Accepted values: none, bold, faint, italic, blink, reverse

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Width

How long do you want the line in character spacing? The value is NOT a percentage. The default is the full window width.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### String

## NOTES

This command has an alias of pshr.

Learn more about PowerShell: http://jdhitsolutions.com/yourls/newsletter

## RELATED LINKS

[Show-ANSISequence](Show-ANSISequence)

[Format-BorderBox](Format-BorderBox)
