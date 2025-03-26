---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version: https://bit.ly/3nb3b74
schema: 2.0.0
---

# Trace-Message

## SYNOPSIS

Create a graphical trace window.

## SYNTAX

### message (Default)

```yaml
Trace-Message [[-Message] <String>] [<CommonParameters>]
```

### init

```yaml
Trace-Message [-Title <String>] [-BackgroundColor <String>] [-Width <Int32>]
[-Height <Int32>] [<CommonParameters>]
```

## DESCRIPTION

Trace-Message is designed to be used with script or function. Its purpose is to create a graphical trace window using Windows Presentation Foundation. Inside the function or script, you can use this command to send messages to the window. When finished, you have an option to save the output to a text file.

There are 3 steps to using this function. First, in your code, you need to create a boolean global variable called TraceEnabled. When the value is $True, the Trace-Message command will run. When set to false, the command will be ignored. Second, you need to initialize a form, specifying the title and dimensions. The form will automatically include some pre-defined metadata. Finally, you can send trace messages to the window. All messages are prepended with a timestamp.

This command is not optimized for performance and is intended for development purposes. When your code is finished, you can set $TraceEnabled to $False. If you need to troubleshoot, you can set it to $True.

## EXAMPLES

### Example 1

```powershell
PS C:\> Trace-Message -title "Troubleshooting Log" -width 600
```

This command will initialize a trace window with the given title and width. It is assumed you have set $TraceEnabled to $True. This is a command you would normally run in your code and not from the console.

### Example 2

```powershell
PS C:\> Trace-Message -message "Starting MyCommand"
```

This example is a continuation of the previous example. The message text will be appended to the graphical form, prepended with a timestamp.

## PARAMETERS

### -BackgroundColor

Specify a background color for the trace window. You can use console colors like "Cyan" or HTML color codes.

```yaml
Type: String
Parameter Sets: init
Aliases:

Required: False
Position: Named
Default value: "#FFFFF8DC",
Accept pipeline input: False
Accept wildcard characters: False
```

### -Height

Specify the Width of the trace window.

```yaml
Type: Int32
Parameter Sets: init
Aliases:

Required: False
Position: Named
Default value: 500
Accept pipeline input: False
Accept wildcard characters: False
```

### -Message

Specify a message to write to the trace window.

```yaml
Type: String
Parameter Sets: message
Aliases:

Required: $True
Position: 0
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Title

Specify a title for the trace window.

```yaml
Type: String
Parameter Sets: init
Aliases:

Required: False
Position: Named
Default value: "Trace Messages"
Accept pipeline input: False
Accept wildcard characters: False
```

### -Width

Specify the Width of the trace window.

```yaml
Type: Int32
Parameter Sets: init
Aliases:

Required: False
Position: Named
Default value: 800
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

## OUTPUTS

### None

## NOTES

Look at $PSSamplePath\Get-Status.ps1 for a demonstration of this command in a function. The buttons have key accelerators of Q and S.

Learn more about PowerShell: https://jdhitsolutions.com/yourls/newsletter

## RELATED LINKS

[Write-Verbose]()
