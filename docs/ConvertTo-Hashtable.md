---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version: http://bit.ly/31SG9Y2
schema: 2.0.0
---

# ConvertTo-Hashtable

## SYNOPSIS

Convert an object into a hashtable.

## SYNTAX

```yaml
ConvertTo-Hashtable [-InputObject] <Object> [-NoEmpty] [-Exclude <String[]>]
[-Alphabetical] [<CommonParameters>]
```

## DESCRIPTION

This command will take an object and create a hashtable based on its properties. You can have the hashtable exclude some properties as well as properties that have no value.

## EXAMPLES

### EXAMPLE 1

```powershell
PS C:\> Get-Process -id $pid |
Select-Object name,id,handles,workingset |
ConvertTo-Hashtable

Name                           Value
----                           -----
WorkingSet                     418377728
Name                           powershell_ise
Id                             3456
Handles                        958
```

### EXAMPLE 2

```powershell
PS C:\> $hash = Get-Service spooler |
ConvertTo-Hashtable -Exclude CanStop,CanPauseAndContinue -NoEmpty
PS C:\> $hash

Name                           Value
----                           -----
ServiceType                    Win32OwnProcess, InteractiveProcess
ServiceName                    spooler
ServiceHandle                  SafeServiceHandle
DependentServices              {Fax}
ServicesDependedOn             {RPCSS, http}
Name                           spooler
Status                         Running
MachineName                    .
RequiredServices               {RPCSS, http}
DisplayName                    Print Spooler
```

This created a hashtable from the Spooler service object, skipping empty properties and excluding CanStop and CanPauseAndContinue.

### EXAMPLE 3

```powershell
PS C:\> Get-Service bits |
Select-Object Name,Displayname,Status,
@{Name="Computername";Expression={$_.Machinename}} |
ConvertTo-Hashtable -Alphabetical

Name                           Value
----                           -----
Computername                   .
DisplayName                    Background Intelligent Transfer Service
Name                           bits
Status                         Running
```

Convert an object to a hashtable and order the properties alphabetically.

## PARAMETERS

### -InputObject

A PowerShell object to convert to a hashtable.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -NoEmpty

Do not include object properties that have no value.

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

### -Exclude

An array of property names to exclude from the hashtable.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Alphabetical

Create a hashtable with property names arranged alphabetically.

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

### System.Object

## OUTPUTS

### System.Collections.Specialized.OrderedDictionary

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

This was originally described at: http://jdhitsolutions.com/blog/2013/01/convert-powershell-object-to-hashtable-revised

## RELATED LINKS

[About_Hash_Tables]()

[Get-Member]()
