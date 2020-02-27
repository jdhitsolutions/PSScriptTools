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
C:\> Save-GitSetup -Verbose -Path c:\work -Passthru
VERBOSE: Getting latest version of git from https://git-scm.com/download/win
VERBOSE: GET https://git-scm.com/download/win with 0-byte payload
VERBOSE: received -byte response of content type text/html
VERBOSE: Found download link https://github.com/git-for-windows/git/releases/download/v2.25.0.windows.1/Git-2.25.0-64-bit.exe
VERBOSE: Downloading c:\work\Git-2.25.0-64-bit.exe from https://github.com/git-for-windows/git/releases/download/v2.25.0.windows.1/Git-2.25.0-64-bit.exe
VERBOSE: GET https://github.com/git-for-windows/git/releases/download/v2.25.0.windows.1/Git-2.25.0-64-bit.exe with 0-byte payload
VERBOSE: received 46476880-byte response of content type application/octet-stream
VERBOSE: Download complete


    Directory: C:\work

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a---           1/23/2020  4:31 PM       46476880 Git-2.25.0-64-bit.exe
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

Learn more about PowerShell:
http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[git.exe]()
