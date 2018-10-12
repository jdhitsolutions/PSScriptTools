---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version:
schema: 2.0.0
---

# Join-Hashtable

## SYNOPSIS

Combine two hashtables into one.

## SYNTAX

```yaml
Join-Hashtable [[-First] <Hashtable>] [[-Second] <Hashtable>] [-Force] [<CommonParameters>]
```

## DESCRIPTION

This command will combine two hashtables into a single hashtable. Normally this is as easy as $hash1+$hash2. But if there are duplicate keys, this will fail. Join-Hashtable will test for duplicate keys. If any of the keys from the first,
or primary hashtable are found in the secondary hashtable, you will be prompted for which to keep. Or you can use -Force which will always keep the conflicting key from the first hashtable.

The original hashtables will not be modified.

## EXAMPLES

### EXAMPLE 1

```powershell
PS C:\> $a=@{Name="Jeff";Count=3;Color="Green"}
PS C:\> $b=@{Computer="HAL";Enabled=$True;Year=2020;Color="Red"}
PS C:\> join-hashtable $a $b
Duplicate key Color
A Green
B Red
Which key do you want to KEEP \[AB\]?: A

Name                           Value
----                           -----
Year                           2020
Name                           Jeff
Enabled                        True
Color                          Green
Computer                       HAL
Count                          3
```

### EXAMPLE 2

```powershell
PS C:\>$c = join-hashtable $a $b -force
PS C:\> $c

Name                           Value
----                           -----
Year                           2020
Name                           Jeff
Enabled                        True
Color                          Green
Computer                       HAL
Count                          3
```

## PARAMETERS

### -First

The primary hashtable. If there are any duplicate keys and you use -Force, values from this hashtable will be kept.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Second

The secondary hashtable.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Force

Do not prompt for conflicts. Always keep the key from the first hashtable.

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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### [hashtable]

## OUTPUTS

### [hashtable]

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[About_Hash_Tables]()
