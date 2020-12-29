---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version:
schema: 2.0.0
---

# Remove-PSAnsiFileEntry

## SYNOPSIS

Remove a PSAnsiFileMap entry.

## SYNTAX

```yaml
Remove-PSAnsiFileEntry [-Description] <String> [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Use this command to remove an entry from the global $PSAnsiFileMap variable. The change will not be persistent unless you export the map to a file.

## EXAMPLES

### Example 1

```powershell
PS C:\> Remove-PSAnsiFileEntry Samples
```

Remove a PSAnsiFileMap entry with a description of 'Samples'. The change will not be persistent unless you export the map to a file.

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

### -Description

Specify the description of the entry to remove.

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

### -Passthru

Display the updated PSAnsiFileMap.

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

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### PSAnsiFileEntry

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Set-PSAnsiFileMapEntry](Set-PSAnsiFileMapEntry.md)

[Get-PSAnsiFileMapEntry](Get-PSAnsiFileMapEntry.md)
