---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version: https://bit.ly/32DadcG
schema: 2.0.0
---

# ConvertTo-ASCIIArt

## SYNOPSIS

Convert text to ASCII art.

## SYNTAX

```yaml
ConvertTo-ASCIIArt [-Text] <String> [[-Font] <String>] [<CommonParameters>]
```

## DESCRIPTION

This command can be used to transform a string of text into ASCII art. ConvertTo-ASCIIArt utilizes the web service at https://artii.herokuapp.com which allows you to transform text. You might use this to create headers for your scripts or PowerShell profile.

Expect a period of trial and error to find a good font that works with your text. The shorter your text, the better.

## EXAMPLES

### Example 1

```powershell
PS C:\> ConvertTo-ASCIIArt -text PScriptTools -Font cybermedium
___  ____ ____ ____ _ ___  ___ ___ ____ ____ _    ____
|__] [__  |    |__/ | |__]  |   |  |  | |  | |    [__
|    ___] |___ |  \ | |     |   |  |__| |__| |___ ___]
```

Convert the string 'PSScriptTools' with the cybermedium font. The font parameter supports auto-completion so you can tab-complete to see all possible options.

### Example 2

```powershell
PS C:\> ConvertTo-ASCIIArt -Text $env:COMPUTERNAME -Font ogre |
Out-File c:\scripts\computername-art.txt
```

Convert the computer name to ASCII art and save the results to a text file. Later you can use Get-Content to display the "artistic" version of the computer name.

## PARAMETERS

### -Font

Specify a font from https://artii.herokuapp.com/fonts_list. Font names are case-sensitive. You can use tab-completion to cycle through the list.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: big
Accept pipeline input: False
Accept wildcard characters: False
```

### -Text

Enter a short string of text to convert.

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

This command has an alias of cart.

Learn more about PowerShell: https://jdhitsolutions.com/yourls/newsletter

## RELATED LINKS
