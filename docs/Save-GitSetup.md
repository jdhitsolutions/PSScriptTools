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
Save-GitSetup [[-Path] <String>] [-ARM64] [-PassThru] [<CommonParameters>]
```

## DESCRIPTION

Non-Windows platforms have package management that make it easy to install newer versions of git.
This command is for Windows platforms where tools like winget are not an option. You can run this command to download the latest 64bit or ARM64 standalone setup file of Git for Windows. You will need to manually install it.

## EXAMPLES

### Example 1

```powershell
PS C:\> Save-GitSetup -Path c:\work -PassThru

    Directory: C:\work

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a---            7/8/2026 11:49 AM       65449488 Git-2.55.0.2-64-bit.exe
```

```powershell
PS C:\> Save-GitSetup -Path D:\temp -ARM64 -Verbose
VERBOSE: [11:53:49.2899082 BEGIN  ] Starting Test-IsPSWindows
VERBOSE: [11:53:49.2901318 END    ] Ending Test-IsPSWindows
VERBOSE: Getting latest version of git from https://git-scm.com/install/windows
VERBOSE: WebRequest: v1.1 GET https://git-scm.com/install/windows
VERBOSE: WebResponse: 200 OK with text/html payload
VERBOSE: Downloading ARM64
VERBOSE: Found download link https://github.com/git-for-windows/git/releases/download/v2.55.0.windows.2/Git-2.55.0.2-arm64.exe
VERBOSE: Downloading D:\temp\Git-2.55.0.2-arm64.exe from https://github.com/git-for-windows/git/releases/download/v2.55.0.windows.2/Git-2.55.0.2-arm64.exe
VERBOSE: WebRequest: v1.1 GET https://github.com/git-for-windows/git/releases/download/v2.55.0.windows.2/Git-2.55.0.2-arm64.exe output to D:\temp\Git-2.55.0.2-arm64.exe
VERBOSE: WebResponse: 200 OK with application/octet-stream payload with body size 60.31 MB (63,236,912 bytes)
VERBOSE: File Name: Git-2.55.0.2-arm64.exe
VERBOSE: Download complete
```

Downloading the ARM64 setup file.

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

### -ARM64
Download the ARM64 standalone version

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

### None

### System.IO.FileInfo

## NOTES

Learn more about PowerShell: https://jdhitsolutions.com/yourls/newsletter

## RELATED LINKS

[git.exe]()
