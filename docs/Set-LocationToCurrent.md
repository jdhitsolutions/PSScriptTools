---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version:
schema: 2.0.0
---

# Set-LocationToFile

## SYNOPSIS

Change script editor terminal location.

## SYNTAX

```yaml
Set-LocationToFile [<CommonParameters>]
```

## DESCRIPTION

This command will only be available if you import the PSScriptTools module into an integrated PowerShell terminal in Visual Studio Code or the PowerShell ISE. It is designed to set the location of the terminal to the same directory as the active file. Run the command or its aliases in the integrated terminal. Use the aliases sd or jmp.

## EXAMPLES

### Example 1

```powershell
PS D:\> sd
PS C:\Scripts\Foo\>
```

Use the sd alias in the integrated terminal window to change location to the directory of the active file in Visual Studio Code or the PowerShell ISE. This will also clear the host.

## PARAMETERS

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### None

## NOTES

## RELATED LINKS

[Set-Location]()
