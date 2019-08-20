---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version: http://bit.ly/31LsDoS
schema: 2.0.0
---

# New-CustomFileName

## SYNOPSIS

Create a custom file name based on a template.

## SYNTAX

```yaml
New-CustomFileName [-Template] <String> [-Case <String>] [<CommonParameters>]
```

## DESCRIPTION

This command will generate a custom file name based on a template string that you provide. You can create a template string using any of these variables. Most of these should be self-explanatory

- %username
- %computername
- %year  - 4 digit year
- %yr  - 2 digit year
- %monthname - The abbreviated month name
- %month  - The month number
- %dayofweek - The full name of the week day
- %day
- %hour
- %minute
- %seconds
- %time  - A compact string of HourMinuteSecond
- %string - A random string
- %guid

You can also insert a random number using %### with a # character for each digit. If you want a 2 digit random number use %##. If you want 6 digits, use %######.

The command will attempt to preserve case for any non pattern string, but you should separate it from other placeholder patterns with one of these characters: - ( ) [ ] or a . Using an underscore will not work.

Another option, is to turn the entire name into upper or lower case.

## EXAMPLES

### EXAMPLE 1

```powershell
PS C:\> New-CustomFileName %computername_%day%monthname%yr-%time.log
COWPC_28Nov18-142138.log
```

### EXAMPLE 2

```powershell
PS C:\> New-CustomFileName %dayofweek-%####.dat
Tuesday-3128.dat
```

Create a custom file name using the day of the week and a 4 digit random number.

### EXAMPLE 3

```powershell
PS C:\> New-CustomFileName %username-%string.tmp -Case Upper
JEFF-Z0XUXMFS.TMP
```

Create an upper case custom file name. The %string placeholder will be replaced with a random 8 character string.

### EXAMPLE 4

```powershell
PS C:\> Join-Path c:\work (New-CustomFilename "%Year%Monthname-LOG-%computername[%username].txt" -case lower)
c:\work\2018nov-log-bovine320[jeff].txt
```

Create a lower case filename using Join-Path. This command does not create the file, it only generates a name for you to use.

### EXAMPLE 5

```powershell
PS C:\> 1..10 | foreach-object {
    $file = New-Item (Join-Path c:\work\data (New-CustomFileName %string-%####.dat))
    $stream =$file.open("OpenOrCreate")
    $stream.Seek((Get-Random -minimum 250 -Maximum 2KB), "Begin") | Out-Null
    $stream.WriteByte(0)
    $stream.Close()
    $file
}

    Directory: C:\work\data

Mode                LastWriteTime         Length Name
----                -------------         ------ ----
-a----        3/15/2019   4:46 PM            976 rcphz2nj-6431.dat
-a----        3/15/2019   4:46 PM           1797 viz32er5-0526.dat
-a----        3/15/2019   4:46 PM           1775 k2mukuv4-8267.dat
-a----        3/15/2019   4:46 PM            666 0encqdlt-8753.dat
-a----        3/15/2019   4:46 PM            513 dbswpujf-6314.dat
-a----        3/15/2019   4:46 PM            371 qlkdufp0-0481.dat
-a----        3/15/2019   4:46 PM           2010 5cxq3tb5-5624.dat
-a----        3/15/2019   4:46 PM           2043 mcvoh4n5-8041.dat
-a----        3/15/2019   4:46 PM           1048 4iwibnmf-1584.dat
-a----        3/15/2019   4:46 PM            378 fgsj0rtd-2894.dat
```

Create 10 dummy files with random names and sizes.

## PARAMETERS

### -Case

Some values like username or computername might be in different case than what you want. You can use the default value, or return a value that is all upper or lower case.

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: Lower, Upper, Default

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Template

A string that defines the naming pattern based on a set of placeholders.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.String

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[New-RandomFileName](./New-RandomFileName.md)
