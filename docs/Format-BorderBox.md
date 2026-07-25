---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version: https://jdhitsolutions.com/yourls/d06a7d
schema: 2.0.0
---

# Format-BorderBox

## SYNOPSIS

Display text in a lined border box.

## SYNTAX

```yaml
Format-BorderBox [-Text] <String[]> [[-Title] <String>] [[-BorderColor] <String>]
[<CommonParameters>]
```

## DESCRIPTION

Use this command to display a block of text in a colored lined border box. You can use ANSI or PSStyle to specify the line color. It is recommended that the lines of text are trimmed of extra spaces.

This command will not run in the Windows PowerShell ISE.

## EXAMPLES

### Example 1

```powershell
PS C:\> Get-WindowsVersionString  | Format-BorderBox -Title "OS Information"

╭──OS Information─────────────────────────────────────────────────────────────╮
│ CADENZA Microsoft Windows 11 Pro Version Professional (OS Build 26200.8894) │
╰─────────────────────────────────────────────────────────────────────────────╯
```

Display Windows version information in a lined box. The default border color is bright green. Note that the border may not be displayed properly in PowerShell help.

### Example 2

```powershell
PS C:\> (pswho -AsString).split("`n").Trim() | fbx -Title PSWho -bc "`e[38;5;192m"

╭──PSWho────────────────────────────────────────────────────────────╮
│ User            : Cadenza\jeff                                    │
│ Elevated        : True                                            │
│ Computername    : CADENZA                                         │
│ OperatingSystem : Microsoft Windows 11 Pro [ARM 64-bit Processor] │
│ OSVersion       : 10.0.26200                                      │
│ PSVersion       : 7.6.4                                           │
│ Edition         : Core                                            │
│ PSHost          : ConsoleHost                                     │
│ WSMan           : 3.0                                             │
│ ExecutionPolicy : RemoteSigned                                    │
│ Culture         : English (United States)                         │
╰───────────────────────────────────────────────────────────────────╯
```

The command needs an array of trimmed strings. This example is using command and parameter aliases.

## PARAMETERS

### -BorderColor

Specify an ANSI or PSStyle sequence for the border color. The default is bright green.

```yaml
Type: String
Parameter Sets: (All)
Aliases: bc

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Text

Enter the text to be displayed in the box. You can enter an array of strings including blank lines. It is recommended that you trim lines of extra spaces.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Title

Enter an optional title.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String[]

## OUTPUTS

### String

## NOTES

This command has an alias of fbx.

Learn more about PowerShell: http://jdhitsolutions.com/yourls/newsletter

## RELATED LINKS

[Add-Border](Add-Border.md)

[Write-PSHorizontalRule](Write-PSHorizontalRule)
