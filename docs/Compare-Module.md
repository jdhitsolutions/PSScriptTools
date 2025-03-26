---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version: https://jdhitsolutions.com/yourls/86d9fd
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

### Example 1

```powershell
PS C:\> Compare-Module | Where-Oject {$_.UpdateNeeded}

Name             : ActiveDirectoryDsc
OnlineVersion    : 6.6.2
InstalledVersion : 6.2.0,6.0.1
PublishedDate    : 3/17/2025 4:41:19 PM
UpdateNeeded     : True

Name             : ComputerManagementDsc
OnlineVersion    : 10.0.0
InstalledVersion : 9.0.0,8.5.0,8.4.0
PublishedDate    : 1/25/2025 3:17:04 PM
UpdateNeeded     : True

Name             : DynamicTitle
OnlineVersion    : 0.4.0
InstalledVersion : 0.3.0
PublishedDate    : 7/10/2023 1:15:44 PM
UpdateNeeded     : True
...
```

List all modules that could be updated.

### Example 2

```powershell
PS C:\> Compare-Module | Where UpdateNeeded |
Out-GridView -title "Select modules to update" -outputMode multiple |
Foreach-Object { Update-Module $_.name }
```

Compare modules and send results to Out-GridView. Use Out-GridView as an object picker to decide what modules to update.

### Example 3

```powershell
PS C:\> Compare-Module -name xWin* | Format-Table

Name           OnlineVersion InstalledVersion PublishedDate        UpdateNeeded
----           ------------- ---------------- -------------        ------------
xWindowsUpdate 2.8.0.0       2.8.0.0          4/3/2019 10:53:09 PM        False
```

Compare all modules that start with xWin* and display results in a table format.

### Example 4

```powershell
PS C:\> Get-DSCResource xAD* | Select-Object moduleName -Unique |
Compare-Module

Name             : xActiveDirectory
OnlineVersion    : 3.0.0.0
InstalledVersion : 3.0.0.0
PublishedDate    : 6/26/2019 9:34:27 PM
UpdateNeeded     : False

Name             : xAdcsDeployment
OnlineVersion    : 1.4.0.0
InstalledVersion : 1.4.0.0
PublishedDate    : 12/20/2017 10:10:43 PM
UpdateNeeded     : False
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

Learn more about PowerShell: https://jdhitsolutions.com/yourls/newsletter

## RELATED LINKS

[Find-Module]()

[Get-Module]()

[Update-Module]()
