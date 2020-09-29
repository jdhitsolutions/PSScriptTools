---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version: https://github.com/jdhitsolutions/PSScriptTools/blob/master/docs/Copy-PSFunction.md
schema: 2.0.0
---

# Copy-PSFunction

## SYNOPSIS

Copy a local PowerShell function to a remote session.

## SYNTAX

```yaml
Copy-PSFunction [-Name] <String[]> -Session <PSSession> [-Force] [<CommonParameters>]
```

## DESCRIPTION

This command is designed to solve the problem when you want to run a function loaded locally on a remote computer. Copy-PSFunction will copy a PowerShell function that is loaded in your current PowerShell session to a remote PowerShell session. The remote session must already be created. The copied function only exists remotely for the duration of the remote PowerShell session.

If the function relies on external or additional files, you will have to copy them to the remote session separately.

## EXAMPLES

### Example 1

```powershell
PS C:\> "Get-LastBoot","Get-DiskFree" | Copy-PSFunction -session $S
```

Copy the local functions Get-LastBoot and Get-DiskFree to a previously created PSSession saved as $S. You could then run the function remotely using Invoke-Command.

## PARAMETERS

### -Force

Overwrite an existing function with the same name. The default behavior is to skip existing functions.

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

### -Name

Enter the name of a local function.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Session

Specify an existing PSSession.

```yaml
Type: PSSession
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String[]

## OUTPUTS

### Deserialized.System.Management.Automation.FunctionInfo

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Copy-Item]()
