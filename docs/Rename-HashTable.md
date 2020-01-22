---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version:
schema: 2.0.0
---

# Rename-HashTable

## SYNOPSIS

Rename a hashtable key.

## SYNTAX

### Pipeline (Default)

```yaml
Rename-HashTable [-InputObject] <Object> [-Key] <String> [-NewKey] <String> [-Passthru] [-Scope <String>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Name

```yaml
Rename-HashTable [-Name] <String> [-Key] <String> [-NewKey] <String> [-Passthru] [-Scope <String>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

This command will rename a key in an existing hashtable or ordered dictionary.
You can either pipe a
hashtable object to this command or you can specify a variable name for a pre-defined hashtable.
If you use this option, specify the variable name without the $.

This command will create a temporary copy of the hashtable, create the new key and copy the value from the old key, before removing the old key.
The temporary hashtable is then set as the new value for your original variable.

This command does not write anything to the pipeline when you use a variable name unless you use -Passthru.
If you pipe a hashtable to this command, the newhashtable will automatically be written to the pipeline.

You might find this command useful when building a hashtable that you intend to use with splatting where you need to align key names with parameter names.

## EXAMPLES

### EXAMPLE 1

```powershell
PS C:\>Rename-Hashtable -name MyHash -key Name -newKey Computername
```

### EXAMPLE 2

```powershell
PS C:\> $newhash = Get-Service spooler | ConvertTo-HashTable | Rename-HashTable -Key Machinename -NewKey Computername
```

This command uses the ConvertTo-Hashtable command from the PSScriptTools module to turn an object into a hashtable.
The Machinename key is then renamed to Computername.

## PARAMETERS

### -Name

The variable name of your hash table.
DO NOT include the $.

```yaml
Type: String
Parameter Sets: Name
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -InputObject

A piped in hashtable object

```yaml
Type: Object
Parameter Sets: Pipeline
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Key

The name of the existing hashtable key you want to rename.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NewKey

The new name of the hashtable key.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Passthru

Write the revised hashtable back to the pipeline. If you pipe a variable to this command, passthru will happen automatically.

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

### -Scope

The scope where your variable is defined.
The default is the global scope.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Global
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

### hashtable

## OUTPUTS

None
Hashtable

## NOTES
Learn more about PowerShell:
http://jdhitsolutions.com/blog/essential-powershell-resources/

This code was first described at http://jdhitsolutions.com/blog/2013/01/rename-hashtable-key-revised

## RELATED LINKS

[About_hash_tables]()

[ConvertTo-Hashtable]()

[Join-Hashtable]()