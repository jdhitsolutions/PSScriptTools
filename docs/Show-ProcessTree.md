---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version: https://jdhitsolutions.com/yourls/6073d5
schema: 2.0.0
---

# Show-ProcessTree

## SYNOPSIS

Display a graphical process tree.

## SYNTAX

```yaml
Show-ProcessTree [-ID] <Int32> [-IncludeUserName] [<CommonParameters>]
```

## DESCRIPTION

This is a wrapper function for Get-ProcessTree. It will display the tree in a graphical format. This command uses ANSI sequences and requires PowerShell 7.,

## EXAMPLES

### Example 1

```powershell
PS C:\> Show-ProcessTree $pid

+WindowsTerminal -> ID: 18244 StartTime: 7/21/2026 9:26:26 AM
 │
 └────:pwsh -> ID: 14680 StartTime: 7/21/2026 10:17:56 AM
```

Show the process tree for the current PowerShell process in a graphical format. The output will be styled with color.

### Example 2

```powershell
PS C:\> Get-Process pwsh | where si -eq 0 | Show-ProcessTree -IncludeUserName

+services -> ID: 2000 StartTime: 7/21/2026 8:58:18 AM []
 │
 └────:sshd -> ID: 5492 StartTime: 7/21/2026 8:58:20 AM [NT AUTHORITY\SYSTEM]
      │
      └────:sshd -> ID: 14088 StartTime: 7/22/2026 9:12:50 AM [NT AUTHORITY\SYSTEM]
            │
            └────:sshd -> ID: 25856 StartTime: 7/22/2026 9:12:54 AM [Cadenza\jeff]
                  │
                  └────:cmd -> ID: 13512 StartTime: 7/22/2026 9:12:54 AM [Cadenza\jeff]
                        │
                        └────:pwsh -> ID: 7916 StartTime: 7/22/2026 9:12:54 AM [Cadenza\jeff]
```

Output can include the process user name.

## PARAMETERS

### -ID

Specify a process ID.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: ProcessID, PID

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -IncludeUserName

Include the process owner.

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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Int32

## OUTPUTS

### String

## NOTES

This command has an alias of spt.

Learn more about PowerShell: http://jdhitsolutions.com/yourls/newsletter

## RELATED LINKS

[Get-ProcessTree](Get-ProcessTree.md)
