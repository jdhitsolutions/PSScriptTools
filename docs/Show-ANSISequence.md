---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version: https://bit.ly/3Ix5s77
schema: 2.0.0
---

# Show-ANSISequence

## SYNOPSIS

Display ANSI escape sequences.

## SYNTAX

### basic (Default)

```yaml
Show-ANSISequence [-Basic] [-AsString] [<CommonParameters>]
```

### foreback

```yaml
Show-ANSISequence [-Foreground] [-Background] [-Type <String>] [-AsString]
[<CommonParameters>]
```

### RGB

```yaml
Show-ANSISequence [-RGB <Int32[]>] [-AsString] [<CommonParameters>]
```

## DESCRIPTION

This script is designed to make it easy to see ANSI escape sequences and how they will display in your PowerShell session. Use the -AsString parameter to write simple strings to the pipeline which makes it easier to copy items to the clipboard.

The escape character will depend on whether you are running Windows PowerShell or PowerShell 7.x. For best results, you need to run this command in a PowerShell session and host that supports ANSI escape sequences.

## EXAMPLES

### Example 1

```powershell
PS C:\> Show-ANSISequence

*******************
* Basic Sequences *
*******************
`e[9mCrossedOut`e[0m
`e[7mReverse`e[0m
`e[6mRapidBlink`e[0m
`e[5mSlowBlink`e[0m
`e[4mUnderline`e[0m
`e[3mItalic`e[0m
`e[2mFaint`e[0m
`e[1mBold`e[0m
```

The output will be formatted using the corresponding ANSI escape sequence as seen in PowerShell 7.x.

### Example 2

```powershell
PS C:\> Show-ANSISequence -Foreground -Type simple

**************
* Foreground *
**************

`e[30mHello`e[0m    `e[31mHello`e[0m    `e[32mHello`e[0m
`e[34mHello`e[0m    `e[35mHello`e[0m    `e[36mHello`e[0m
`e[90mHello`e[0m    `e[91mHello`e[0m    `e[92mHello`e[0m
`e[94mHello`e[0m    `e[95mHello`e[0m    `e[96mHello`e[0m
```

### Example 3

```powershell
PS C:\> Show-ANSISequence -RGB 225,100,50

`e[38;2;225;100;50m256 Color (R:225)(G:100)(B:50)`e[0m
```

Show an RGB ANSI sequence. The output will be formatted using the sequence.

### Example 4

```powershell
PS C:\> Show-ANSISequence -RGB 225,100,50 -AsString | Set-Clipboard
```

Repeat the previous example but write the output as a plain string and copy it to the clipboard.

## PARAMETERS

### -Basic

Display basic ANSI settings. This is the default output.

```yaml
Type: SwitchParameter
Parameter Sets: basic
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Foreground

Display foreground ANSI format settings. If you use -Type without specifying -Foreground or -Background, -Foreground will be used by default.

```yaml
Type: SwitchParameter
Parameter Sets: foreback
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Background

Display background ANSI format settings.

```yaml
Type: SwitchParameter
Parameter Sets: foreback
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Type

You can display simple ANSI, 8-bit, or all sequences. Valid values are All,Simple and 8bit.

```yaml
Type: String
Parameter Sets: foreback
Aliases:

Required: False
Position: Named
Default value: All
Accept pipeline input: False
Accept wildcard characters: False
```

### -RGB

Display an RGB ANSI sequence.
You must pass an array of values for Red,Blue, and Green.
Each value must be between 0 and 255.

```yaml
Type: Int32[]
Parameter Sets: RGB
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AsString

Show the value as an unformatted string.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.String

## Notes

Learn more about ANSI sequences at https://en.wikipedia.org/wiki/ANSI_escape_code

Learn more about PowerShell: https://jdhitsolutions.com/yourls/newsletter

## RELATED LINKS

[Write-ANSIProgress](Write-ANSIProgress.md)

[New-ANSIBar](New-ANSIBar.md)
