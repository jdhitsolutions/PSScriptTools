---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version: https://jdhitsolutions.com/yourls/98f4be
schema: 2.0.0
---

# Import-PSScriptToolsTypeExtension

## SYNOPSIS

Import a custom type extension file

## SYNTAX

```yaml
Import-PSScriptToolsTypeExtension [[-TypeName] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Use this command to import a PSScriptTools type extension file. This will add functionality to output of commands like Get-Process and Measure-Object. You can pipe output from Get-PSScriptToolsTypeExtension to this command.

## EXAMPLES

### Example 1

```powershell
PS C:\> Import-PSScriptToolsTypeExtension
```

Import all available custom type extensions.

### Example 2

```powershell
PS C:\> Import-PSScriptToolsTypeExtension -typename *file*
```

Import all custom type extensions that have "file" in the name.

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

### -TypeName

The TypeName of the custom type extension set

```yaml
Type: String
Parameter Sets: (All)
Aliases: Type

Required: False
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: True
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

### System.String

## OUTPUTS

### None

## NOTES

Learn more about PowerShell: https://jdhitsolutions.com/yourls/newsletter

## RELATED LINKS

[Get-PSScriptToolsTypeExtension](Get-PSScriptToolsTypeExtension.md)
