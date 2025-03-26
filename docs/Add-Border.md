---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version: https://jdhitsolutions.com/yourls/44067f
schema: 2.0.0
---

# Add-Border

## SYNOPSIS

Create a text border around a string.

## SYNTAX

### single (Default)

```yaml
Add-Border [-Text] <String> [-Character <String>] [-InsertBlanks]
[-Tab <Int32>] [-ANSIBorder <String>] [-ANSIText <String>] [<CommonParameters>]
```

### block

```yaml
Add-Border [-TextBlock] <String[]> [-Character <String>] [-InsertBlanks]
[-Tab <Int32>] [-ANSIBorder <String>] [-ANSIText <String>] [<CommonParameters>]
```

## DESCRIPTION

This command will create a character or text-based border around a line of text. You might use this to create a formatted text report or to improve the display of information to the screen.

## EXAMPLES

### Example 1

```powershell
PS C:\> Add-Border "PowerShell Wins!"

********************
* PowerShell Wins! *
********************
```

### Example 2

```powershell
PS C:\> Add-Border "PowerShell Wins!" -tab 1

     ********************
     * PowerShell Wins! *
     ********************
```

Note that this example may not format properly in all consoles.

### Example 3

```powershell
PS C:\> Add-Border "PowerShell Wins!" -character "-" -insertBlanks

--------------------
-                  -
- PowerShell Wins! -
-                  -
--------------------
```

### Example 4

```powershell
PS C:\> Add-Border -TextBlock (Get-Service win* | Out-String).trim()

**********************************************************************
* Status   Name               DisplayName                            *
* ------   ----               -----------                            *
* Stopped  WinDefend          Windows Defender Antivirus Service     *
* Running  WinHttpAutoProx... WinHTTP Web Proxy Auto-Discovery Se... *
* Running  Winmgmt            Windows Management Instrumentation     *
* Stopped  WinRM              Windows Remote Management (WS-Manag... *
**********************************************************************
```

Create a border around the output of a Get-Service command.

### Example 5

```powershell
PS C:\> Add-Border -Text $t -ANSIBorder "$([char]0x1b)[38;5;47m"
-ANSIText "$([char]0x1b)[93m" -InsertBlanks


*******************
*                 *
* I am the walrus *
*                 *
*******************
```

This will write a color version of the text and border. You would this type of ANSI syntax for Windows PowerShell. In PowerShell 7, you can use the same syntax or the much easier "`e[38;5;47m".

### Example 6

```powershell
PS C:\> Add-Border -TextBlock (Get-PSWho -AsString ).trim() -ANSIBorder
"`e[38;5;214m" -Character ([char]0x25CA) -ANSIText "`e[38;5;225m"

◊◊◊◊◊◊◊◊◊◊◊◊◊◊◊◊◊◊◊◊◊◊◊◊◊◊◊◊◊◊◊◊◊◊◊◊◊◊◊◊◊◊◊◊◊◊◊◊◊◊◊◊◊◊◊
◊ User            : BOVINE320\Jeff                    ◊
◊ Elevated        : True                              ◊
◊ Computername    : BOVINE320                         ◊
◊ OperatingSystem : Microsoft Windows 10 Pro [64-bit] ◊
◊ OSVersion       : 10.0.18363                        ◊
◊ PSVersion       : 7.0.1                             ◊
◊ Edition         : Core                              ◊
◊ PSHost          : ConsoleHost                       ◊
◊ WSMan           : 3.0                               ◊
◊ ExecutionPolicy : RemoteSigned                      ◊
◊ Culture         : English (United States)           ◊
◊◊◊◊◊◊◊◊◊◊◊◊◊◊◊◊◊◊◊◊◊◊◊◊◊◊◊◊◊◊◊◊◊◊◊◊◊◊◊◊◊◊◊◊◊◊◊◊◊◊◊◊◊◊◊
```

This example requires PowerShell 7 because of the way the escape sequence is defined. The border character is a diamond. Depending on how you are viewing this help content, it may not display properly.

## PARAMETERS

### -Text

A single line of text that will be wrapped in a border.

```yaml
Type: String
Parameter Sets: single
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -TextBlock

A multi-line block of text. You might want to trim blank lines from the beginning, end or both.

```yaml
Type: String[]
Parameter Sets: block
Aliases: tb

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Character

The character to use for the border. It must be a single character.

```yaml
Type: String
Parameter Sets: (All)
Aliases: border

Required: False
Position: Named
Default value: *
Accept pipeline input: False
Accept wildcard characters: False
```

### -InsertBlanks

Insert blank lines before and after the text. The default behavior is to create a border box close to the text. See examples.

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

### -Tab

Insert X number of tabs.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -ANSIBorder

Enter an ANSI escape sequence to color the border characters.

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

### -ANSIText

Enter an ANSI escape sequence to color the text.

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

### None

## OUTPUTS

### System.String

## NOTES

Learn more about PowerShell: https://jdhitsolutions.com/yourls/newsletter

## RELATED LINKS

[New-ANSIBar](New-ANSIBar.md)
