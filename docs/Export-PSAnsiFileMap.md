---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version:
schema: 2.0.0
---

# Export-PSAnsiFileMap

## SYNOPSIS

Export a PSAnsiFileMap to a file.

## SYNTAX

```yaml
Export-PSAnsiFileMap [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

The PSScriptTools module includes a JSON file that is automatically imported as the global PSAnsiFileMap variable. This variable is used for the custom ANSI formatted table view, among other module commands. If you wish to customize the file map, you can use the Set-PSAnsiFileMap command. These changes are not permanent and will be overwritten the next time you import the PSScriptTools module. To use your customized settings, you need to export your modified $PSAnsiFileMap object with this command.

The command will export the settings to a JSON file called psansifilemap.json in the root of $HOME. The next time you import the PSScriptTools module, it will use this file if found. To revert to the default file map either rename or delete the file in $HOME.

## EXAMPLES

### Example 1

```powershell
PS C:\>Export-PSAnsiFileMap -Passthru

    Directory: C:\Users\Jeff

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a---          12/28/2020  1:02 PM           1631 psansifilemap.json
```

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

### -Passthru

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

### None

### System.IO.FileInfo

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Get-PSAnsiFileMap](Get-PSAnsiFileMap.md)

[Set-PSAnsiFileMap](Set-PSAnsiFileMap.md)
