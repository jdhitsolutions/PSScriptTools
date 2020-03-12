---
external help file: PSScriptTools-help.xml
Module Name: psscripttools
online version:
schema: 2.0.0
---

# Get-GitSize

## SYNOPSIS

Get the size of .git folder.

## SYNTAX

```yaml
Get-GitSize [[-Path] <String>] [<CommonParameters>]
```

## DESCRIPTION

When using git, it creates a hidden folder for change tracking.
Because the file is hidden it is easy to overlook how large it might become.
The command uses a formatting file to display a default view.
There is an additonal table view called MB that you can use.

## EXAMPLES

### EXAMPLE 1

```powershell
PS C:\Scripts\PiedPiper> Get-GitSize

Path                                          Files          SizeKB
----                                          -----          ------
C:\scripts\PiedPiper                            751       6859.9834
```

Get the size of the .git folder from the current path.

### EXAMPLE 2

```powershell
PS C:\> Get-ChildItem c:\scripts -Directory | Get-GitSize | Sort-Object -property Size -descending | Select-Object -first 5 -property Computername,Name,Files,Size

Computername Name           Files      Size
------------ ----           -----      ----
WIN10DSK2    PSAutoLab        526 193760657
WIN10DSK2    DevOps-Courses    29  53298180
WIN10DSK2    PSScriptTools    751   7024623
WIN10DSK2    PSGUI             32   6705894
WIN10DSK2    DscWorkshop       24   5590511
```

Get the directories under C:\Scripts that have a .git folder and sort on the Size property in descending order.
Then select the first 5 directories and use the specified properties.

### EXAMPLE 3

```powershell
PS S:\PSReleaseTools> Get-GitSize | Format-Table -view mb

Path                                          Files          SizeMB
----                                          -----          ------
C:\scripts\PSReleaseTools                       440          3.0588
```

Get the git folder size and format using the MB table view.

## PARAMETERS

### -Path

The path to the parent folder, not the .git folder.

```yaml
Type: String
Parameter Sets: (All)
Aliases: pspath

Required: False
Position: 1
Default value: current location
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### [System.String]

## OUTPUTS

### gitSize

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

This is a variation of code posted at https://gist.github.com/jdhitsolutions/cbdc7118f24ba551a0bb325664415649

## RELATED LINKS

[Get-ChildItem]()

[Measure-Object]()
