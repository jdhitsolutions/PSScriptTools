---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version: http://bit.ly/2RCoWQ6
schema: 2.0.0
---

# Get-FolderSizeInfo

## SYNOPSIS

Get folder size information.

## SYNTAX

```yaml
Get-FolderSizeInfo [-Path] <String[]> [-Hidden] [<CommonParameters>]
```

## DESCRIPTION

This command is an alternative to discovering the size of a folder, or at least an easier method. Use the -Hidden parameter to include hidden files in the output. The measurement will include all files in all sub-folders.

Note that this command has been optimized for performance, but if you have a lot of files to count that will take time.

## EXAMPLES

### Example 1

```powershell
PS C:\> Get-FolderSizeInfo -Path d:\temp

Computername    Path                                                TotalFiles     TotalSize
------------    ----                                                ----------     ---------
BOVINE320       D:\temp                                                     48     121824451
```

### Example 2

```powershell
PS C:\> Get-FolderSizeInfo -Path d:\temp -hidden

Computername    Path                                                TotalFiles     TotalSize
------------    ----                                                ----------     ---------
BOVINE320       D:\temp                                                    146     125655552
```

Include hidden files.

### Example 3

```powershell
PS C:\> Get-ChildItem d:\ -Directory | Get-FolderSizeInfo | Where-Object TotalSize -gt 1MB | Sort-Object TotalSize -Descending | Format-Table -View mb

Computername    Path                                                TotalFiles   TotalSizeMB
------------    ----                                                ----------   -----------
BOVINE320       D:\VMDisks                                                  18   114873.7246
BOVINE320       D:\ISO                                                      17    42526.8204
BOVINE320       D:\SQLServer2017Media                                        1      710.8545
BOVINE320       D:\officeViewers                                             4      158.9155
BOVINE320       D:\Temp                                                     48      116.1809
BOVINE320       D:\Sysinternals                                            153       59.6169
BOVINE320       D:\blog                                                     41       21.9948
BOVINE320       D:\BackTemp                                                  2       21.6734
BOVINE320       D:\rip                                                       3       11.1546
BOVINE320       D:\logs                                                    134        3.9517
BOVINE320       D:\2016                                                      5        1.5608
```

Get the top level directories from D and pipe them to Get-FolderSizeInfo. Items with a total size of greater an 1MB are sorted on the total size and then formatted as a table using a built-in view called MB which formats the total size in MB. There is also a view called GB.

### Example 4

```powershell
PS C:\> Get-Childitem c:\work -Directory | Get-FolderSizeInfo -Hidden | Where-Object {$_.totalsize -ge 2mb} | Format-Table -view name


   Path: C:\work

Name                    TotalFiles      TotalKB
----                    ----------      -------
A                               20    5843.9951
keepass                         15     5839.084
PowerShellBooks                 26    4240.3779
sunday                          47   24540.6523
```

Get all sub-folders under C:\work greater than 2MB in size and display using the Name table view.

## PARAMETERS

### -Hidden

Include hidden directories.

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

### -Path

Enter a file system path like C:\Scripts.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: PSPath

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String[]

## OUTPUTS

### FolderSizeInfo

## NOTES

Learn more about PowerShell:
http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Test-EmptyFolder]()

[Get-ChildItem]()

[Measure-Object]()
