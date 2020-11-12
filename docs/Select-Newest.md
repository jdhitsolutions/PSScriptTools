---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version: http://bit.ly/36x3YIG
schema: 2.0.0
---

# Select-Newest

## SYNOPSIS

Select the newest X number of objects after a given datetime.

## SYNTAX

```yaml
Select-Newest -InputObject <PSObject> [-Newest] <Int32> [-Property <String>]
[<CommonParameters>]
```

## DESCRIPTION

Select-Newest is a variation on Select-Object. It is designed to make it easier to select X number of objects based on a datetime property. The default property value is LastWriteTime.

## EXAMPLES

### Example 1

```powershell
PS C:\> Get-ChildItem c:\work -file | Select-Newest 1


    Directory: C:\work

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a---           11/4/2020 11:36 AM           5008 ipperf.csv
```

Get the newest file in the Work folder. This example is using the default -Property parameter value of LastWriteTime.

### Example 2

```powershell
PS C:\> Get-Process | newest 10 -Property starttime

 NPM(K)    PM(M)      WS(M)     CPU(s)      Id  SI ProcessName
 ------    -----      -----     ------      --  -- -----------
     15     5.34      12.85       0.09   25208   0 WmiPrvSE
      7     1.31       5.95       0.02   10552   0 svchost
     35   128.28     136.05       8.62    3376   0 esrv_svc
     98    47.31      40.01       0.48   24496   2 firefox
     99    48.46      46.07       0.53   22064   2 firefox
     13     3.41      16.19       0.77   33136   2 notepad
     14     6.78      10.96       0.06   31784   0 svchost
     69   110.45     150.37       4.28    8848   2 pwsh
      5     2.52       4.52       0.02   34024   2 cmd
     10     2.06       9.00       0.12   25384   2 OpenConsole

```

Get the 10 most recent processes based on the StartTime property. This example is using the "newest" alias.

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

### -Newest

Enter the number of newest items to select.

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

[Select-Oldest](Select-Oldest.md)

[Select-Object]()
