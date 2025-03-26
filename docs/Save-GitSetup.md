---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version: https://jdhitsolutions.com/yourls/42ce51
schema: 2.0.0
---

# Save-GitSetup

## SYNOPSIS

Download the latest 64bit version of Git for Windows.

## SYNTAX

```yaml
Save-GitSetup [[-Path] <String>] [-PassThru] [<CommonParameters>]
```

## DESCRIPTION

Non-Windows platforms have package management that make it easy to install newer versions of git.
This command is for Windows platforms. You can run this command to download the latest 64bit version of Git for Windows. You will need to manually install it.

## EXAMPLES

### Example 1

```powershell
C:\> Save-GitSetup -Path c:\work -PassThru

    Directory: C:\work

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a---           3/26/2025 10:50 AM       70287136 Git-2.49.0-64-bit.exe
```

## PARAMETERS

### -PassThru

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

Learn more about PowerShell: https://jdhitsolutions.com/yourls/newsletter

## RELATED LINKS

[git.exe]()
