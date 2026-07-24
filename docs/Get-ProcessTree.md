---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version: https://jdhitsolutions.com/yourls/4925b0
schema: 2.0.0
---

# Get-ProcessTree

## SYNOPSIS

Get a process tree.

## SYNTAX

```yaml
Get-ProcessTree [-ID] <Int32> [-IncludeUserName] [<CommonParameters>]
```

## DESCRIPTION

This command will display a process tree for a given process ID. The command will display a list of processes in order from parent to child. In other words, the oldest parent process will be listed first. The last process in the output will be the process you queried.

This command requires PowerShell 7.

## EXAMPLES

### Example 1

```powershell
PS C:\> Get-ProcessTree $pid

NPM(K)  PM(K)  WS(K) CPU(s)    Id SI ProcessName                 StartTime
------  -----  ----- ------    -- -- -----------                 ---------
    39 183136 250092 146.75 18244  1 WindowsTerminal  7/21/2026 9:26:26 AM
   156 274552 434676  76.81 14680  1 pwsh            7/21/2026 10:17:56 AM
```

### Example 2

```powershell
PS C:\> Get-ProcessTree 7916 -IncludeUserName

 WS(K) CPU(s)    Id UserName            ProcessName            StartTime
 ----- ------    -- --------            -----------            ---------
 14708  11.48  2000                     services    7/21/2026 8:58:18 AM
 11432   0.12  5492 NT AUTHORITY\SYSTEM sshd        7/21/2026 8:58:20 AM
 13408   0.03 14088 NT AUTHORITY\SYSTEM sshd        7/22/2026 9:12:50 AM
 13668   0.03 25856 Cadenza\jeff        sshd        7/22/2026 9:12:54 AM
 10328   0.05 13512 Cadenza\jeff        cmd         7/22/2026 9:12:54 AM
104060   1.45  7916 Cadenza\jeff        pwsh        7/22/2026 9:12:54 AM
```

Get the process tree including the user name.

### Example 3

```powershell
PS C:\> gpt $pid | Select ID,ProcessName,HandleCount,Path

   Id ProcessName HandleCount Path
   -- ----------- ----------- ----
12828 Code               1105 C:\Users\jeff\AppData\Local\Programs\Microsoft VS Code\Code.exe
27332 Code                286 C:\Users\jeff\AppData\Local\Programs\Microsoft VS Code\Code.exe
20736 pwsh               1168 C:\Program Files\PowerShell\7\pwsh.exe
```

This example is run from an integrated VSCode terminal using the command alias, gpt. You can use any process property.

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

### PSProcessTree

### PSProcessTree#User

## NOTES

This command has an alias of gpt.

Learn more about PowerShell: http://jdhitsolutions.com/yourls/newsletter

## RELATED LINKS

[Show-ProcessTree](Show-ProcessTree.md)
