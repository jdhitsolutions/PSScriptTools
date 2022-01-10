---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version: https://bit.ly/3FbzOu3
schema: 2.0.0
---

# Get-LastModifiedFile

## SYNOPSIS

Get files based on last modified data.

## SYNTAX

```yaml
Get-LastModifiedFile [[-Filter] <String>] [[-Path] <String>]
[-Interval <String>] [-IntervalCount <Int32>] [-Recurse] [<CommonParameters>]
```

## DESCRIPTION

This command is designed to make it easier to identify last modified files. You can specify by an interval such as 3 months or 24 hours.

## EXAMPLES

### Example 1

```powershell
PS C:\> Get-LastModifiedFile -Path c:\work

    Directory: C:\work

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a---          11/30/2021  1:52 PM           2010 a.txt
-a---          11/30/2021  1:52 PM           5640 b.txt
```

The default behavior is to find all files modified in the last 24 hours.

### Example 2

```powershell
PS C:\> Get-LastModifiedFile -Path c:\scripts -Filter *.ps1 -Interval Months -IntervalCount 6

    Directory: C:\Scripts

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a---          11/19/2021  2:36 PM           1434 calendar-prompt.ps1
-a---          10/11/2021 11:26 AM           1376 ChangeOSCaption.ps1
-a---           8/27/2021  8:06 AM           2754 Check-ModuleUpdate.ps1
-a---           9/17/2021  9:23 AM           1822 CleanJobs.ps1
-a---           7/14/2021 10:36 AM            436 Clear-Win11Recommended.ps1
-a---          10/18/2021  5:24 PM           5893 ComingSoon.ps1
-a---          10/25/2021  5:23 PM           4966 Configure-PSVirtualMachine.ps1
...
```

Get all .ps1 files in C:\Scripts that have been modified in the last 6 months.

## PARAMETERS

### -Filter

Specify a file filter like *.ps1.

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

### -Interval

Specify the search interval based on the last write time.

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: Hours, Minutes, Days, Months, Years

Required: False
Position: Named
Default value: Hours
Accept pipeline input: False
Accept wildcard characters: False
```

### -IntervalCount

Specify the number of intervals.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: ic

Required: False
Position: Named
Default value: 24
Accept pipeline input: False
Accept wildcard characters: False
```

### -Path

Specify the folder to search.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: current location
Accept pipeline input: False
Accept wildcard characters: False
```

### -Recurse

Recurse from the specified path.

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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.IO.FileInfo

## NOTES

This command was first described at https://jdhitsolutions.com/blog/powershell/8622/finding-modified-files-with-powershell/

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Get-ChildItem]()

[Get-DirectoryInfo](Get-DirectoryInfo.md)

[Get-FolderSizeInfo](Get-FolderSizeInfo.md)
