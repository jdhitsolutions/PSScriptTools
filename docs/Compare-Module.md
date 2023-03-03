---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version: http://bit.ly/31UsaRA
schema: 2.0.0
---

# Compare-Module

## SYNOPSIS

Compare PowerShell module versions.

## SYNTAX

```yaml
Compare-Module [[-Name] <String>] [-Gallery <String>] [<CommonParameters>]
```

## DESCRIPTION

Use this command to compare module versions between what is installed against an online repository like the PSGallery. Results will be automatically sorted by module name.

## EXAMPLES

### EXAMPLE 1

```powershell
PS C:\> Compare-Module | Where-object {$_.UpdateNeeded}

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

List all modules that could be updated.

### EXAMPLE 2

```powershell
PS C:\> Compare-Module | Where UpdateNeeded |
Out-GridView -title "Select modules to update" -outputMode multiple |
Foreach-Object { Update-Module $_.name }
```

Compare modules and send results to Out-GridView. Use Out-GridView as an object picker to decide what modules to update.

### EXAMPLE 3

```powershell
PS C:\> Compare-Module -name xWin* | Format-Table

Name           OnlineVersion InstalledVersion PublishedDate         UpdateNeeded
----           ------------- ---------------- -------------         ------------
xWindowsUpdate 2.7.0.0       2.7.0.0,2.5.0.0  7/12/2017 10:43:54 PM        False
xWinEventLog   1.2.0.0       1.2.0.0          6/13/2018 8:06:45 PM         False
```

Compare all modules that start with xWin* and display results in a table format.

### EXAMPLE 4

```powershell
PS C:\> get-dscresource xAD* | Select-Object moduleName -Unique |
Compare-Module

Name             : xActiveDirectory
OnlineVersion    : 2.22.0.0
InstalledVersion : 2.16.0.0,2.14.0.0
PublishedDate    : 10/25/2018 5:25:24 PM
UpdateNeeded     : True

Name             : xAdcsDeployment
OnlineVersion    : 1.4.0.0
InstalledVersion : 1.1.0.0,1.0.0.0
PublishedDate    : 12/20/2017 10:10:43 PM
UpdateNeeded     : True
```

Get all DSC Resources that start with xAD and select the corresponding module name. Since the module name will be listed for every resource, get a unique list and pipe that to Compare-Module.

## PARAMETERS

### -Name

The name of a module to check. Wildcards are permitted.

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

### System.String

## OUTPUTS

### PSCustomObject

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Find-Module]()

[Get-Module]()

[Update-Module]()
