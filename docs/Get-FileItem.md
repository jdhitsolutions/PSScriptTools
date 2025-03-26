---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version: https://jdhitsolutions.com/yourls/986690
schema: 2.0.0
---

# Get-FileItem

## SYNOPSIS

A PowerShell version of the Where CLI command.

## SYNTAX

### Default (Default)

```yaml
Get-FileItem [-Pattern] <String[]> [-Regex] [-Full] [-Quiet] [-First]
[<CommonParameters>]
```

### Path

```yaml
Get-FileItem [-Pattern] <String[]> [-Regex] [-Path <String[]>] [-Recurse]
[-Full] [-Quiet] [-First] [<CommonParameters>]
```

## DESCRIPTION

This is an enhanced, PowerShell version of the WHERE command from the traditional CLI which will find files in %PATH% that match a particular pattern.

## EXAMPLES

### Example 1

```powershell
PS C:\> Get-FileItem notepad.exe
C:\Windows\notepad.exe
C:\Windows\System32\notepad.exe
C:\Windows\System32\notepad.exe
C:\Windows\notepad.exe
C:\Users\Jeff\AppData\Local\Microsoft\WindowsApps\notepad.exe
```

Find notepad.exe in %PATH% and return the complete file name. This is the default behavior.

### Example 2

```powershell
PS C:\> PSWhere foo.exe -Quiet
False
```

Search for foo.exe and return $True if found. This command is using the PSWhere alias.

### Example 3

```powershell
PS C:\> Get-FileItem "^\d+\S+\.txt" -Regex -Path c:\scripts -full

    Directory: C:\Scripts

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a---          10/28/2021  9:36 AM          30145 1000FemaleNames.txt
-a---           12/5/2007  2:19 PM          29618 1000MaleNames.txt
-a---            6/2/2010 11:02 AM          31206 1000names.txt
-a---            6/3/2010  8:52 AM           3154 100names.txt
-a---           5/28/2014  1:38 PM           1601 100NewUsers.txt
-a---           2/17/2015  4:47 PM           2300 2015.txt
-a---            2/7/2011  1:37 PM          78542 2500names.txt
```

Find all TXT files in C:\Scripts that start with a number and display full file information.

## PARAMETERS

### -Pattern

The name of the file to find. Separate multiple entries with a comma.
Wildcards are allowed. You can also specify a regular expression pattern by including the -REGEX parameter.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Regex

Indicates that the pattern is a regular expression.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Path

The folders to search other than %PATH%.

```yaml
Type: String[]
Parameter Sets: Path
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Recurse

Used with -Path to indicate a recursive search.

```yaml
Type: SwitchParameter
Parameter Sets: Path
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Full

Write the full file object to the pipeline. The default is just the full name.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Quiet

Returns True if a match is made. This parameter will override -Full.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -First

Stop searching after the pattern is found. Don't search any more paths.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### String

## OUTPUTS

### String

### Boolean

### System.IO.FileInfo

## NOTES

Learn more about PowerShell: https://jdhitsolutions.com/yourls/newsletter

## RELATED LINKS

[Get-ChildItem]()

[Where.exe]()
