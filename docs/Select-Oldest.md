---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version: https://bit.ly/2IyQPqx
schema: 2.0.0
---

# Select-Oldest

## SYNOPSIS

Select the oldest X number of objects before a given datetime.

## SYNTAX

```yaml
Select-Oldest -InputObject <PSObject> [-Oldest] <Int32> [-Property <String>]
[<CommonParameters>]
```

## DESCRIPTION

Select-Oldest is a variation on Select-Object. It is designed to make it easier to select X number of objects based on a datetime property. The default property value is LastWriteTime.

## EXAMPLES

### Example 1

```powershell
PS C:\> Get-ChildItem c:\work -file | Select-oldest 1


    Directory: C:\work

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a---           10/6/2020  4:03 PM           2986 labsummary.format.ps1xml

```

Get the oldest file in the Work folder. This example is using the default -Property parameter value of LastWriteTime.

### Example 2

```powershell
PS C:\> Get-Process | where-object name -notmatch "idle|System" |
oldest 10 -Property starttime

 NPM(K)    PM(M)      WS(M)     CPU(s)      Id  SI ProcessName
 ------    -----      -----     ------      --  -- -----------
     16     8.43      99.83       2.27     204   0 Registry
      3     1.03       1.12       0.44     712   0 smss
     30     2.23       5.67       4.23     816   0 csrss
     11     1.52       6.65       0.02    1592   0 wininit
     11     6.55      11.63      25.33    1676   0 services
      7     1.10       3.27       0.09    1696   0 LsaIso
     28     9.81      24.70      29.61    1704   0 lsass
      4     0.81       3.31       0.00    1824   0 svchost
     26    13.48      30.38      22.62    1852   0 svchost
      6     1.91       4.15       0.11    1876   0 fontdrvhost
```

Get the oldest 10 processes that don't include Idle or System. This example is using the "oldest" alias.

## PARAMETERS

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

### -Oldest

Enter the number of Oldest items to select.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Property

Enter the property name to select on. It must be a datetime object.

```yaml
Type: String
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

### System.Management.Automation.PSObject

## OUTPUTS

### System.Object

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Select-Newest](Select-Newest.md)

[Select-Object]()
