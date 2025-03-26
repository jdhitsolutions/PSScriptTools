---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version: https://github.com/jdhitsolutions/PSScriptTools/blob/master/docs/Compare-Script.md
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

Use this command to compare script versions between what is installed against an online repository like the PSGallery. Results will be automatically sorted by the script name.

## EXAMPLES

### Example 1

```powershell
PS C:\> Compare-Script | Where-object {$_.UpdateNeeded}

Name             : winfetch
OnlineVersion    : 2.5.1
InstalledVersion : 1.0
PublishedDate    : 8/26/2023 8:12:46 PM
UpdateNeeded     : True
```

List all scripts that could be updated.

### Example 2

```powershell
PS C:\> Compare-Script | Where UpdateNeeded |
Out-GridView -Title "Select scripts to update" -OutputMode multiple |
Foreach-Object { Update-Script $_.name }
```

Compare scripts and send results to Out-GridView. Use Out-GridView as an object picker to decide what scripts to update.

## PARAMETERS

### -Name

The name of a script to check. Wildcards are permitted.

```yaml
Type: String
Parameter Sets: (All)
Aliases: scriptname

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

### System.String

## OUTPUTS

### PSCustomObject

## NOTES

Learn more about PowerShell: https://jdhitsolutions.com/yourls/newsletter

## RELATED LINKS

[Find-Script]()

[Get-InstalledScript]()

[Update-Script]()
