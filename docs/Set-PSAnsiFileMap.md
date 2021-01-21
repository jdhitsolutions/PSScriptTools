---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version: https://bit.ly/394kL8m
schema: 2.0.0
---

# Set-PSAnsiFileMap

## SYNOPSIS

Modify or add a PSAnsiFileEntry

## SYNTAX

```yaml
Set-PSAnsiFileMap [-Description] <String> [-Pattern <String>] [-Ansi <String>]
[-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Use this command to modify an existing entry in the global $PSAnsiFileMap variable or add a new entry. If modifying, you must specify a regular expression pattern or an ANSI escape sequence. If you are adding a new entry, you need to supply both values.

## EXAMPLES

### Example 1

```powershell
PS C:\> Set-PSAnsiFileMap Temporary -Ansi "`e[38;5;190m"
```

Update the ANSI pattern for temporary files. This change will not persist unless you export the map.

### Example 2

```powershell
PS C:\> Set-PSAnsiFileMap -Description "Config" -Pattern "\.(yml)$" -Ansi "`e[38;5;25m"ge
```

Add a new PSAnsiFileMap entry. This change will not persist unless you export the map.

## PARAMETERS

### -Ansi

Specify an ANSI escape sequence. You only need to define the opening sequence.

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

Specify the file map entry.
If it is a new entry it will be added.

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

Display the updated map.

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

### -Pattern

Specify a regular expression pattern for the file name.

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

[Get-PSAnsiFileMap](Get-PSAnsiFileMap.md)

[Remove-PSAnsiFileEntry](Remove-PSAnsiFileEntry.md)

[Export-PSAnsiFileMap](Export-PSAnsiFileMap.md)
