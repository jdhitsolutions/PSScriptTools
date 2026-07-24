---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version: https://jdhitsolutions.com/yourls/7f73b9
schema: 2.0.0
---

# New-ANSIHyperlink

## SYNOPSIS

Create an ANSI string with a hyperlink.

## SYNTAX

```yaml
New-ANSIHyperlink [-DisplayText] <String> [-Link] <String> [-Style <String>] [-AsString] [<CommonParameters>]
```

## DESCRIPTION

In PowerShell 7, you can use $PSStyle.FormatHyperLink() to create a string with a hyperlink. This method is based on an underlying ANSI escape sequence. This command uses that same sequence so that you can create a hyperlinked string in Windows PowerShell. The command also makes it easier to add other styling. By default, the link will have a solid underline.

Optionally, you can use AsString to see a text version of the string with escape sequence markers.

## EXAMPLES

### Example 1

```powershell
PS C:\> New-ANSIHyperlink "powershell.org" -Link "https://powershell.org"
powershell.org
```

The output will be an underlined string with a clickable link, assuming you are using a terminal that supports it.

### Example 2

```powershell
PS C:> New-ANSIHyperlink "powershell.org" -Link "https://powershell.org" -Style "`e[3;93m"
```

The string will be styled in yellow and italicized.

### Example 3

```powershell
PS C:\> New-ANSIHyperlink "powershell.org" -Link "https://powershell.org" -AsString
`e]8;;https://powershell.org`e\`e[4mpowershell.org`e[0m`e]8;;`e\`e[0m
```

Display a plaintext version of the string with escape sequences indicated. The indicated escape character will depend if you are running Windows PowerShell or PowerShell 7.

### Example 4

```powershell
PS C:\> Get-Command -module PSIntro | Foreach-Object {
    $h = Get-Help $_.Name
    $link = $h.relatedLinks.NavigationLink | Where uri | First 1 |
    New-ANSIHyperlink -DisplayText $_.Name -style "`e[3;38;5;45m"
    [PSCustomObject]@{
    Name = $link
        Synopsis = $h.Synopsis
    }
 }

Name              Synopsis
----              --------
Add-PSIntro       Add Start-PSIntro to your PowerShell profile.
Get-ModuleStatus  Get key module status
Get-ProfileStatus Get the status of PowerShell profile scripts for the current host.
Get-PSIntro       Display a PowerShell welcome screen
New-PSProfile     Create a new PowerShell profile script.
Start-PSTutorial  Start an interactive PowerShell tutorial
```

Go through the help for every command in the PSIntro module and write custom output where the command name is a clickable link to the online help content.

## PARAMETERS

### -AsString

Display the ANSI string as a plain text string.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DisplayText

The text to display in the link. Do not include any ANSI sequences.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Text,LinkText

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Link

The URL link. This should be an http://, https://, or file:// link. The command will not validate the link.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Url,Uri

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Style

Specify an optional ANSI style sequence. The command will automatically use a solid underline. You don't need to include the closing reset.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

## OUTPUTS

### string

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/yourls/newsletter

## RELATED LINKS
