---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version: https://jdhitsolutions.com/yourls/3adc9c
schema: 2.0.0
---

# Set-ConsoleTitle

## SYNOPSIS

Set the console title text.

## SYNTAX

```yaml
Set-ConsoleTitle [-Title] <String> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Use this command to modify the text displayed in the title bar of your PowerShell console window.
This command is intended for use in a traditional PowerShell console. It will not work in consoles that are part of the PowerShell ISE or Visual Studio Code. It should work in a PowerShell session running in Windows Terminal.

## EXAMPLES

### Example 1

```powershell
PS C:\> Set-ConsoleTitle $env:computername
```

Set the console title to the computer name.

### Example 2

```powershell
PS C:\> if (Test-IsAdministrator) {
    Set-ConsoleTitle "Admin: PS $($PSVersionTable.PSVersion)"
    }
```

Modify the console title if running as Administrator

## PARAMETERS

### -Confirm

Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Title

Enter the title for the console window.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf

Shows what would happen if the cmdlet runs. The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.

For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### None

## NOTES

Learn more about PowerShell: https://jdhitsolutions.com/yourls/newsletter

## RELATED LINKS

[Set-ConsoleColor](Set-ConsoleColor.md)
