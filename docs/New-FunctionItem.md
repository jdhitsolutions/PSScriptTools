---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version: https://bit.ly/2UuSKlN
schema: 2.0.0
---

# New-FunctionItem

## SYNOPSIS

Create a function item from the console

## SYNTAX

```powershell
New-FunctionItem [-Name] <String> [-Scriptblock] <ScriptBlock>
[[-Description] <String>] [-Passthru] [-WhatIf]  [-Confirm]
[<CommonParameters>]
```

## DESCRIPTION

You can use this function to create a quick function definition directly from the console. This command does not write anything to the pipeline unless you use -Passthru.

## EXAMPLES

### EXAMPLE 1

```powershell
PS C:\> New-FunctionItem -name ToTitle -scriptblock {param([string]$Text)
(Get-Culture).TextInfo.ToTitleCase($text.toLower())} -passthru

CommandType     Name                   Version    Source
-----------     ----                   -------    ------
Function        ToTitle
```

### EXAMPLE 2

```powershell
PS C:\> {Get-Date -format g | Set-Clipboard} | New-FunctionItem -name Copy-Date
```

## PARAMETERS

### -Name

What is the name of your function?

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Scriptblock

What is your function's scriptblock?

```yaml
Type: ScriptBlock
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Description

You can specify an optional description. This only lasts for as long as your function is loaded.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Passthru

Show the newly created function.

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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### Scriptbloclk

## OUTPUTS

### None

### System.Management.Automation.FunctionInfo

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Show-FunctionItem](Show-FunctionItem.md)
