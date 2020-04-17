---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version: https://bit.ly/2Kfjm1Q
schema: 2.0.0
---

# Get-ModuleCommand

## SYNOPSIS

Get a summary of commands in a module.

## SYNTAX

### name (Default)

```yaml
Get-ModuleCommand [-Name] <String> [-ListAvailable] [<CommonParameters>]
```

### fqdn

```yaml
Get-ModuleCommand -FullyQualifiedName <ModuleSpecification> [-ListAvailable] [<CommonParameters>]
```

## DESCRIPTION

This is an alternative to Get-Command to make it easier to see at a glance what commands are contained within a module and what they can do. By default, Get-ModuleCommand looks for loaded modules. Use -ListAvailable to see commands in module not currently loaded. Note that if the help file is malformed or missing, you might get oddly formatted results.

## EXAMPLES

### Example 1

```powershell
PS C:\> Get-ModuleCommand PSCalendar


   Verb: Get

Name                           Alias           Type      Synopsis
----                           -----           ----      --------
Get-Calendar                   cal             Function  Displays a visual representation of a ...


   Verb: Show

Name                           Alias           Type      Synopsis
----                           -----           ----      --------
Show-Calendar                  scal            Function  Display a colorized calendar month in ...
Show-GuiCalendar               gcal            Function  Display a WPF-based calendar
```

Get module commands using the default formatted view.

### Example 2

```powershell
PS C:\> Get-ModuleCommand smbshare -ListAvailable | format-list


Name     : Block-SmbShareAccess
Alias    : blsmba
Synopsis : Adds a deny ACE for a trustee to the security descriptor of the SMB share.

Name     : Close-SmbOpenFile
Alias    : cssmbo
Synopsis : Closes a file that is open by one of the clients of the SMB server.

Name     : Close-SmbSession
Alias    : cssmbse
Synopsis : Ends forcibly the SMB session.
...
```

Using the default list view.

## PARAMETERS

### -FullyQualifiedName

Specifies names of modules in the form of ModuleSpecification objects.
The FullyQualifiedName parameter accepts a module name that is specified in the following formats:

@{ModuleName = "modulename"; ModuleVersion = "version_number"}
@{ModuleName = "modulename"; ModuleVersion = "version_number"; Guid = "GUID"}

ModuleName and ModuleVersion are required, but Guid is optional.

You cannot specify the FullyQualifiedName parameter in the same command as a Name parameter.

```yaml
Type: ModuleSpecification
Parameter Sets: fqdn
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ListAvailable

Indicates that this cmdlet gets all installed modules. Get-Module gets modules in paths listed in the PSModulePath environment variable.
Without this parameter, Get-ModuleCommand gets only the modules that are both listed in the PSModulePath environment variable, and that are loaded in the current session.

ListAvailable does not return information about modules that are not found in the PSModulePath environment variable, even if those modules are loaded in the current session.

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

### -Name

The name of an installed module.

```yaml
Type: String
Parameter Sets: name
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### ModuleCommand

## NOTES

Learn more about PowerShell:
http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Get-Command]()

[Get-Module]()
