---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version: http://bit.ly/2O8y50B
schema: 2.0.0
---

# Save-GitSetup

## SYNOPSIS

Download the latest 64bit version of Git for Windows.

## SYNTAX

```yaml
Save-GitSetup [[-Path] <String>] [-Passthru] [<CommonParameters>]
```

## DESCRIPTION

Non-Windows platforms have package management that make it easy to install newer versions of git.
This command is for Windows platforms.
You can run this command to download the latest 64bit version of Git for Windows.
You will need to manually install it.

## EXAMPLES

### Example 1

```powershell
C:\> Save-GitSetup -Path c:\work -Passthru

    Directory: C:\work

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a---          12/28/2020  7:29 PM       48578904 Git-2.29.2.3-64-bit.exe
```

## PARAMETERS

### -Passthru

Show the downloaded file.

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

Specify the location to store the downloaded file.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: $env:TEMP
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### None

### System.IO.FileInfo

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[git.exe]()
