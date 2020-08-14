---
external help file: PSScriptTools-help.xml
Module Name: psscripttools
online version: https://bit.ly/3crxxg9
schema: 2.0.0
---

# Remove-MergedBranch

## SYNOPSIS

Removed merged git branches.

## SYNTAX

```yaml
Remove-MergedBranch [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

When using git you may create a number of branches. Presumably you merge these branches into the main or master branch. The development or patching branch remains. You can use git to remove branches. Or use this command to remove all merged branches other than master and the current branch. You must be in the root of your project to run this command.

## EXAMPLES

### Example 1

```powershell
PS C:\MyProject> Remove-MergedBranch

Remove merged branch from MyProject?
2.1.1
[Y] Yes  [N] No  [S] Suspend  [?] Help (default is "Y"): n

Remove merged branch from MyProject?
dev1
[Y] Yes  [N] No  [S] Suspend  [?] Help (default is "Y"): y
Deleted branch dev1 (was 75f6ab8).

Remove merged branch from MyProject?
dev2
[Y] Yes  [N] No  [S] Suspend  [?] Help (default is "Y"): y
Deleted branch dev2 (was 75f6ab8).

Remove merged branch from MyProject?
patch-254
[Y] Yes  [N] No  [S] Suspend  [?] Help (default is "Y"): n
PS C:\MyProject>
```

By default you will be prompted to remove each branch.

### Example 2

```powershell
PS C:\MyProject> Remove-MergedBranch -force
Deleted branch 2.1.1 (was 75f6ab8).
Deleted branch patch-254 (was 75f6ab8).
```

Remove all branches with no prompting.

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

### -Force

Remove all merged branches except current and master with no prompting.

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

### String

## NOTES

Learn more about PowerShell:
http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[git.exe]()

[Get-GitSize](Get-GitSize.md)
