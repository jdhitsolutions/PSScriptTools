---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version: https://bit.ly/2GU4iIK
schema: 2.0.0
---

# Get-DirectoryInfo

## SYNOPSIS

Get directory information.

## SYNTAX

```yaml
Get-DirectoryInfo [[-Path] <String>] [-Depth <Int32>] [<CommonParameters>]
```

## DESCRIPTION

This command is designed to provide quick access to top-level directory information. The default behavior is to show the total number of files in the immediate directory. Although the command will also capture the total file size in the immediate directory. You can use the Depth parameter to recurse through a specified number of levels.

The command output will use a wide format by default. However, other wide views are available. See Examples.

## EXAMPLES

### Example 1

```powershell
PS C:\> Get-DirectoryInfo


   Path: C:\


gemfonts [15]                   PerfLogs [0]
Pluralsight [17]                Presentations [1]
Program Files [0]               Program Files (x86) [0]
Ruby27-x64 [3]                  Scripts [3652]
Thunderbird [0]                 Training [3]
Users [0]                       Windows [38]
Windows.old [0]                 Windows10Upgrade [23]
work [13]
```

The default output will use ANSI escape sequences.

### Example 2

```powershell
PS C:\> Get-DirectoryInfo -Path D:\ | Format-Wide -View sizemb

   Path: D:\


autolab [0MB]                                            backtemp [0MB]
Backup [0.01MB]                                          Backups [140.49MB]
bovine320 [0MB]                                          Databases [0MB]
Exports [0MB]                                            iso [16137.65MB]
JDHIT [35.58MB]                                          Logitech [0MB]
OneDrive [0MB]                                           rip [60.99MB]
temp [10.67MB]                                           video [83.56MB]
VMDisks [68053MB]                                        VMs [0MB]
```

Using one of the alternate Format-Wide views. Other views are size and sizekb.

### Example 3

```powershell
PS C:\> Get-DirectoryInfo D:\Autolab\ -Depth 2 |
Format-Table -GroupBy parent -Property Name,File* -wrap


   Parent: D:\Autolab

Name                   FileCount    FileSize
----                   ---------    --------
Configurations                 0           0
Hotfixes                       0           0
ISOs                           6 16838768742
MasterVirtualHardDisks         3 22326280192
Resources                      0           0
VMVirtualHardDisks             0           0


   Parent: D:\Autolab\Configurations

Name                                  FileCount FileSize
----                                  --------- --------
Implement-Windows-Server-DHCP-2016            7    65126
Jason-DSC-Env                                 7    66933
microsoft-powershell-implementing-jea         7    65462
MultiRole                                     7    65820
MultiRole-Server-2016                         7    62063
PowerShellLab                                 7    83541
SingleServer                                  4    15784
SingleServer2012R2                            4    15937
SingleServer2012R2-GUI                        4    16005
SingleServer-GUI-2016                         4    16397
SingleServer-GUI-2019                         4    15845
Windows10                                     4    20695


   Parent: D:\Autolab\Configurations\PowerShellLab

Name      FileCount FileSize
----      --------- --------
PostSetup         5    15275
```

Here's an example using the DirectoryStat object with different formatting.

## PARAMETERS

### -Depth

The Depth parameter determines the number of subdirectories to recursively query.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Path

Specify the top-level path.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### DirectoryStat

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Get-ChildItem]()
