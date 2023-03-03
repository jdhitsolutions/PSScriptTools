---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version: https://bit.ly/3nkqnjm
schema: 2.0.0
---

# Select-Before

## SYNOPSIS

Select objects before a given datetime.

## SYNTAX

```yaml
Select-Before -InputObject <PSObject> [-Before] <DateTime> [-Property <String>]
[<CommonParameters>]
```

## DESCRIPTION

Select-Before is a simplified version of Select-Object. The premise is that you can pipe a collection of objects to this command and select objects before a given datetime, based on a property, like LastWriteTime, which is the default.

## EXAMPLES

### Example 1

```powershell
PS C:\> Get-ChildItem c:\work -file | Select-Before "11/1/2022"


    Directory: C:\work

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a---          10/10/2022  2:09 PM           8862 Book1.xlsx
-a---          10/30/2022 10:48 AM              0 dummy.dat
-a---          10/13/2022  9:35 AM         447743 key1013.pdf
-a---           10/6/2022  4:03 PM           2986 labsummary.format.ps1xml
-a---          10/11/2022 12:33 PM           1678 prun.format.ps1xml
-a---          10/10/2022  6:49 PM           1511 w.format.ps1xml

```

Select all objects that have been modified before 11/1/2022. This example is using the default -Property value of LastWriteTime.

### Example 2

```powershell
PS C:\> Get-Process | before (Get-Date).AddMinutes(-10) -Property StartTime

 NPM(K)    PM(M)      WS(M)     CPU(s)      Id  SI ProcessName
 ------    -----      -----     ------      --  -- -----------
     33    30.21      46.19       0.81    9952   2 ApplicationFrameHost
     75   102.42     126.08       4.89   16048   2 Box
     23    25.27      33.83       0.33    5320   0 Box.Desktop.UpdateService
     30    46.92      60.98       0.91   17384   2 BoxUI
     31    39.82       4.34       0.56   26992   2 Calculator
...
```

Get all processes where the StartTime property value is before the last 10 minutes. This example is using the "before" alias.

## PARAMETERS

### -Before

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
Default value: LastWritetime
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

[Select-After](Select-After.md)

[Select-Object]()
