---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version: 
schema: 2.0.0
---

# Add-Border

## SYNOPSIS

Create a text border around a string.

## SYNTAX

### single (Default)

```yaml
Add-Border [-Text] <String> [-Character <String>] [-InsertBlanks] [-Tab <Int32>] [<CommonParameters>]
```

### block

```yaml
Add-Border [-TextBlock] <String[]> [-Character <String>] [-InsertBlanks] [-Tab <Int32>] [<CommonParameters>]
```

## DESCRIPTION

This command will create a character or text based border around a line of text.
You might use this to create a formatted text report or to improve the display of information to the screen.

## EXAMPLES

### EXAMPLE 1

```powershell
PS C:\> add-border "PowerShell Wins!"

********************
* PowerShell Wins! *
********************
```

### EXAMPLE 2

```powershell
PS C:\> add-border "PowerShell Wins!" -tab 1

     ********************
     * PowerShell Wins! *
     ********************
```

Note that this EXAMPLE may not format properly in the console.

### EXAMPLE 3

```powershell
PS C:\> add-border "PowerShell Wins!" -character "-" -insertBlanks

--------------------
-                  -
- PowerShell Wins! -
-                  -
--------------------
```

### EXAMPLE 4

```powershell
PS C:\> add-border -textblock (get-service win* | out-string).trim()

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
Aliases:

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
Aliases:

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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.String

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS
