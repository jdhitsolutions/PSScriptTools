---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version: 
schema: 2.0.0
---

# New-RandomFileName

## SYNOPSIS
Create a random file name.

## SYNTAX

### none (Default)
```
New-RandomFileName [-Extension <String>]
```

### temp
```
New-RandomFileName [-Extension <String>] [-UseTempFolder]
```

### home
```
New-RandomFileName [-Extension <String>] [-UseHomeFolder]
```

## DESCRIPTION
Create a new random file name. The default is a completely random name including the extension. But you can also create a filename that includes either the TEMP folder or the user's home folder. In the case of a Windows system, the home folder will be the documents folder.

This command does not create the file, it only generates a name for you to use.

## EXAMPLES

### Example 1
```
PS C:\> new-randomfilename
fykxecvh.ipw
```
### Example 2
```
PS C:\> new-randomfilename -extension dat
emevgq3r.dat
```
Specify a file extension.

### Example 3
```
PS C:\> new-randomfilename -extension log -UseHomeFolder
C:\Users\Jeff\Documents\kbyw4fda.log
```
Create a random file name using the user's home folder. In Windows this will be the Documents folder.

### Example 4
```
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

## INPUTS

### None

## OUTPUTS

### System.String

## NOTES
Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS
[New-CustomFileName]()
