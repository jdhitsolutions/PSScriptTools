---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version: https://jdhitsolutions.com/yourls/8721e0
schema: 2.0.0
---

# Remove-Runspace

## SYNOPSIS

Remove a runspace from your session.

## SYNTAX

### id (Default)

```yaml
Remove-Runspace [-ID] <Int32> [-WhatIf] [-Confirm] [<CommonParameters>]
```

### runspace

```yaml
Remove-Runspace [-Runspace] <Runspace> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

When working with PowerShell, you may discover that some commands and scripts can leave behind runspaces. You may even deliberately be creating additional runspaces. These runspaces will remain until you exit your PowerShell session. Or use this command to cleanly close and dispose of runspaces. You cannot remove any runspace with an availability of Busy or that is already closing.

This command does not write anything to the pipeline.

## EXAMPLES

### Example 1

```powershell
PS C:\> Remove-Runspace -id 18 -WhatIf
What if: Performing the operation "Remove-Runspace" on target "18 - Runspace18".
```

Show what would have happened to remove runspace with an ID of 18.

### Example 2

```powershell
PS C:\> Get-Runspace | where ID -gt 1 | Remove-Runspace
```

Get all runspaces with an ID greater than 1, which is typically your session, and remove the runspace.

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

### -ID

The runspace ID number.

```yaml
Type: Int32
Parameter Sets: id
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Runspace

A runspace presumably piped into this command using Get-Runspace.

```yaml
Type: Runspace
Parameter Sets: runspace
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -WhatIf

Shows what would happen if the cmdlet runs.
The cmdlet is not run.

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

### System.Management.Automation.Runspaces.Runspace

## OUTPUTS

### None

## NOTES

Learn more about PowerShell: https://jdhitsolutions.com/yourls/newsletter

## RELATED LINKS

[Get-Runspace]()
