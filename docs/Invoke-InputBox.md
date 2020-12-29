---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version: http://bit.ly/31UtHXQ
schema: 2.0.0
---

# Invoke-InputBox

## SYNOPSIS

Launch a graphical input box.

## SYNTAX

### plain (Default)

```yaml
Invoke-InputBox [-Title <String>] [-Prompt <String>]
[-BackgroundColor <String>] [<CommonParameters>]
```

### secure

```yaml
Invoke-InputBox [-Title <String>] [-Prompt <String>] [-AsSecureString]
[-BackgroundColor <String>] [<CommonParameters>]
```

## DESCRIPTION

Use this command as a graphical replacement for Read-Host. The command will write either a string or a secure string to the pipeline. You can customize the prompt, title and background color.

This command requires a Windows platform.

## EXAMPLES

### EXAMPLE 1

```powershell
PS C:\> $name = Invoke-Inputbox -prompt "Enter a user name" -title "New User"
```

Display an graphical inputbox with a given prompt and title. The entered value will be saved to $name.

### EXAMPLE 2

```powershell
PS C:\> $pass = Invoke-Inputbox -prompt "Enter a new password"
-title "New User" -asSecureString -background red
```

Get a secure string value from the user. This example also changes the form background to red.

## PARAMETERS

### -AsSecureString

Use to mask the entry and return a secure string.

```yaml
Type: SwitchParameter
Parameter Sets: secure
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -BackgroundColor

Set the form background color. You can use a value like 'red' or a '#c0c0c0'.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: White
Accept pipeline input: False
Accept wildcard characters: False
```

### -Prompt

Enter a prompt. No more than 50 characters.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: "Please enter a value"
Accept pipeline input: False
Accept wildcard characters: False
```

### -Title

Enter the title for the input box. No more than 25 characters.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: "User Input"
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.String

### System.Security.SecureString

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Read-Host]()

[New-WPFMessageBox](New-WPFMessageBox.md)
