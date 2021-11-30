---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version:
schema: 2.0.0
---

# Get-FileExtensionInfo

## SYNOPSIS

Get a report of files based on their extension.

## SYNTAX

```yaml
Get-FileExtensionInfo [[-Path] <String>] [-Recurse] [-Hidden] [-IncludeFiles] [<CommonParameters>]
```

## DESCRIPTION

This command will search a given directory and produce a report of all files based on their file extension. This command is only available in PowerShell 7.

## EXAMPLES

### Example 1

```powershell
PS C:\> Get-FileExtensionInfo c:\work

   Path: C:\work [THINKP1]

Extension Count TotalSize Smallest   Average  Largest
--------- ----- --------- --------   -------  -------
              1         0        0         0        0
.bat          1       122      122       122      122
.bmp          2     14113     4509    7056.5     9604
.csv          7    188085      107  26869.29   129351
.db           3     18432     6144      6144     6144
.gif          1      7110     7110      7110     7110
.htm          1      2586     2586      2586     2586
.html         8    580178     1060  72522.25   238054
.jdh          1        92       92        92       92
.jpb          1      9604     9604      9604     9604
.jpg          2     23827     9604   11913.5    14223
.json         8    366166      546  45770.75   310252
.log          1      6323     6323      6323     6323
.md           2      4031      389    2015.5     3642
.pdf          1     80704    80704     80704    80704
.png          4     47598     1071   11899.5    22700
.ps1          5      2713       64     542.6     1530
.ps1xml       2      5765     2794    2882.5     2971
.psd1         1      7696     7696      7696     7696
.reg          1      8802     8802      8802     8802
.txt         27    332297        7   12307.3    72047
.xml         10  67920544     1584 6792054.4 58504746
.zip          1  13493443 13493443  13493443 13493443
```

The extension with the largest total size will be highlighted in color.

## PARAMETERS

### -Hidden

Include files in hidden folders

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

### -IncludeFiles

Add the corresponding collection of files. You can access these items by the Files property.

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

Specify the root directory path to search

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

### -Recurse

Recurse through all folders.

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

### FileExtensionInfo

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Get-FolderSizeInfo](Get-FolderSizeInfo.md)
