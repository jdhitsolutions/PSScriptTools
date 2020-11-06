---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version:
schema: 2.0.0
---

# Select-After

## SYNOPSIS

Select objects after a given datetime.

## SYNTAX

```yaml
Select-After -InputObject <PSObject> [-After] <DateTime> [-Property <String>]
[<CommonParameters>]
```

## DESCRIPTION

Select-After is a simplified version of Select-Object. The premise is that you can pipe a collection of objects to this command and select objects after a given datetime, based on a property, like LastWriteTime, which is the default.

## EXAMPLES

### Example 1

```powershell
PS C:\> Get-Childitem c:\work -file | Select-After "11/1/2020"


    Directory: C:\work

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a---           11/4/2020 11:36 AM           5008 ipperf.csv
```

Select all objects that have been modified after 11/1/2020. This example is using the default -Property value of LastWriteTime.

### Example 2

```powershell
PS C:\> Get-Process | After (Get-Date).AddMinutes(-10) -Property StartTime

 NPM(K)    PM(M)      WS(M)     CPU(s)      Id  SI ProcessName
 ------    -----      -----     ------      --  -- -----------
      8     1.49       7.17       0.00   33248   0 SearchFilterHost
     12     2.46      12.99       0.02   15328   0 SearchProtocolHost
      8     2.60       8.58       0.03    9756   0 svchost
     76    20.27      39.93       2.14   22976   0 svchost
      8     1.53       7.29       0.00   29752   0 svchost
```

Get all processes where the StartTime property value is within the last 10 minutes. This example is using the "after" alias.

## PARAMETERS

### -After

Enter the cutoff date.

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -InputObject

A piped in object.

```yaml
Type: PSObject
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Property

Enter the property name to use for the datetime sort. It needs to be a datetime object.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: LastWriteTime
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Management.Automation.PSObject

## OUTPUTS

### System.Object

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Select-Before](Select-Before.md)

[Select-Object]()
