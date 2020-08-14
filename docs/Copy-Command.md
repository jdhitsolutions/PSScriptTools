---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version: http://bit.ly/31Ty8Sm
schema: 2.0.0
---

# Copy-Command

## SYNOPSIS

Copy a PowerShell command.

## SYNTAX

```yaml
Copy-Command [-Command] <String> [[-NewName] <String>] [-IncludeDynamic]
[-AsProxy] [-UseForwardHelp] [<CommonParameters>]
```

## DESCRIPTION

This command will copy a PowerShell command, including parameters and help to a new user-specified command. You can use this to create a "wrapper" function or to easily create a proxy function. The default behavior is to create a copy of the command complete with the original comment-based help block.

For best results, run this in the PowerShell ISE or Visual Studio code, the copied command will be opened in a new tab or file.

## EXAMPLES

### EXAMPLE 1

```powershell
PS C:\> Copy-Command Get-Process Get-MyProcess
```

Create a copy of Get-Process called Get-MyProcess.

### EXAMPLE 2

```powershell
PS C:\> Copy-Command Get-Eventlog -asproxy -useforwardhelp
```

Create a proxy function for Get-Eventlog and use forwarded help links.

### EXAMPLE 3

```powershell
PS C:\> Copy-Command Get-ADComputer Get-MyADComputer -includedynamic
```

Create a wrapper function for Get-ADComputer called Get-MyADComputer. Due to the way the Active Directory cmdlets are written, most parameters appear to be dynamic so you need to include dynamic parameters otherwise there will be no parameters in the final function.

## PARAMETERS

### -Command

The name of a PowerShell command, preferably a cmdlet but that is not a requirement. You can specify an alias and it will be resolved.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NewName

Specify a name for your copy of the command. If no new name is specified, the original name will be used.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IncludeDynamic

The command will only copy explicitly defined parameters unless you specify to include any dynamic parameters as well. If you copy a command and it seems to be missing parameters, re-copy and include dynamic parameters.

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

### -AsProxy

Create a traditional proxy function.

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

### -UseForwardHelp

By default the copy process will create a comment-based help block with the original command's help which you can then edit to meet your requirements. Or you can opt to retain the forwarded help links to the original command.

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

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### [system.string[]]

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Get-Command]()
