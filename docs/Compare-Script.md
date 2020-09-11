---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version: 
schema: 2.0.0
---

# Compare-Script

## SYNOPSIS

Compare PowerShell script versions.

## SYNTAX

```yaml
Compare-Script [[-Name] <String>] [-Gallery <String>] [<CommonParameters>]
```

## DESCRIPTION

Use this command to compare script versions between what is installed against an online repository like the PSGallery. Results will be automatically sorted by script name.

## EXAMPLES

### EXAMPLE 1

```powershell
PS C:\> Compare-Script | Where-object {$_.UpdateNeeded}

Name             : DNSSuffix
OnlineVersion    : 0.4.1
InstalledVersion : 0.2.0
PublishedDate    : 10/22/2018 8:21:46 PM
UpdateNeeded     : True

Name             : InvokeBuild
OnlineVersion    : 5.4.2
InstalledVersion : 3.2.2
PublishedDate    : 12/7/2018 1:30:46 AM
UpdateNeeded     : True
...
```

List all scripts that could be updated.

### EXAMPLE 2

```powershell
PS C:\> Compare-Script | Where UpdateNeeded |
Out-Gridview -title "Select modules to update" -outputMode multiple |
Foreach-Object { Update-Script $_.name }
```

Compare scripts and send results to Out-Gridview. Use Out-Gridview as an object picker to decide what scripts to update.

## PARAMETERS

### -Name

The name of a script to check. Wildcards are permitted.

```yaml
Type: String
Parameter Sets: (All)
Aliases: modulename

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: True
```

### -Gallery

Specify the remote repository or gallery to check.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: PSGallery
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### [string]

## OUTPUTS

### PSCustomObject

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Find-Script]()

[Get-InstalledScript]()

[Update-Script]()
