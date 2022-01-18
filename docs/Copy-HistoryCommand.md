---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version:
schema: 2.0.0
---

# Copy-HistoryCommand

## SYNOPSIS

Copy a history command line to the clipboard.

## SYNTAX

```yanml
Copy-HistoryCommand [[-ID] <Int32[]>] [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

You can use this command to copy the commandline from a given PowerShell
history item to the clipboard.The default item will the be last history
item. Once copied, you can paste into your following prompt to edit and/or
re-run.

Linux platforms require the xclip utility to be in the path.

Lee Holmes has a similar function called Copy-History in the PowerShell
Cookbook that lets you copy a range of history commands to the clipboard.

## ExampleS

### Example 1

```powershell
PS C:\> Copy-HistoryCommand
```

Copy the last command to the clipboard.

### Example 2

```powershell
PS C:\> Copy-HistoryCommand 25 -passthru
get-process -computername $computer | sort ws -Descending | select -first 3
```

Copy the command from history item 25 to the clipboard and also pass it to the pipeline.

### Example 3

```powershell
PS C:\> Copy-HistoryCommand (100..110)
```

Copy history items 100 through 110 to the clipboard.

### Example 4

```powershell
PS C:\> $c = [scriptblock]::Create($(Copy-HistoryCommand 25 -passthru))
PS C:\> &$c

Handles  NPM(K)    PM(K)      WS(K) VM(M)   CPU(s)     Id  SI ProcessName
-------  ------    -----      ----- -----   ------     --  -- -----------
  10414   12744   488164     461596 ...76            3128   0 dns
    581      67   171868     141620 ...82            3104   0 MsMpEng
    678      48   118132      89572   840            7180   0 ServerManager
```

This copies the command from history item 25 and turns it into a scriptblock.

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

The history ID number. The default is the last command.

```yaml
Type: Int32[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: $(Get-History).Count
Accept pipeline input: False
Accept wildcard characters: False
```

### -Passthru

Use this parameter if you also want to see the command as well as copy it to the clipboard.

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

### -WhatIf

Shows what would happen if the cmdlet runs. The cmdlet is not run.

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

### Int

## OUTPUTS

### None

### System.String

## NOTES

Learn more about PowerShell:
http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Get-History]()

[Set-Clipboard]()

[Out-Copy](Out-Copy.md)
