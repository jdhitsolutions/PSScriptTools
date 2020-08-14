---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version: http://bit.ly/31Lt56y
schema: 2.0.0
---

# New-RandomFileName

## SYNOPSIS

Create a random file name.

## SYNTAX

### none (Default)

```yaml
New-RandomFileName [-Extension <String>] [<CommonParameters>]
```

### temp

```yaml
New-RandomFileName [-Extension <String>] [-UseTempFolder] [<CommonParameters>]
```

### home

```yaml
New-RandomFileName [-Extension <String>] [-UseHomeFolder] [<CommonParameters>]
```

## DESCRIPTION

Create a new random file name. The default is a completely random name including the extension. But you can also create a filename that includes either the TEMP folder or the user's home folder. In the case of a Windows system, the home folder will be the documents folder.

This command does not create the file, it only generates a name for you to use.

## EXAMPLES

### EXAMPLE 1

```powershell
PS C:\> new-randomfilename
fykxecvh.ipw
```

### EXAMPLE 2

```powershell
PS C:\> new-randomfilename -extension dat
emevgq3r.dat
```

Specify a file extension.

### EXAMPLE 3

```powershell
PS C:\> new-randomfilename -extension log -UseHomeFolder
C:\Users\Jeff\Documents\kbyw4fda.log
```

Create a random file name using the user's home folder. In Windows this will be the Documents folder.

### EXAMPLE 4

```powershell
PS /mnt/c/scripts> new-randomfilename -home -Extension tmp
/home/jhicks/oces0epq.tmp
```

Create a random file name using the user's home folder on a Linux installation.

## PARAMETERS

### -Extension

Use a specific extension. Do not include the period.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -UseHomeFolder

Include the user's HOME folder.

```yaml
Type: SwitchParameter
Parameter Sets: home
Aliases: home

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -UseTempFolder

Include the TEMP folder.

```yaml
Type: SwitchParameter
Parameter Sets: temp
Aliases: temp

Required: False
Position: Named
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

[New-CustomFileName](New-CustomFileName.md)
