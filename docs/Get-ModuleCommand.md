---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version: https://bit.ly/2Kfjm1Q
schema: 2.0.0
---

# Get-ModuleCommand

## SYNOPSIS

Get a summary of module commands.

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

This is an alternative to Get-Command to make it easier to see at a glance what commands are contained within a module and what they can do. By default, Get-ModuleCommand looks for loaded modules. Use -ListAvailable to see commands in the module but not currently loaded. Note that if the help file is malformed or missing, you might get oddly formatted results.

## EXAMPLES

### Example 1

```powershell
PS C:\> Get-ModuleCommand PSCalendar


   ModuleName: PSCalendar

Name             Alias Synopsis
----             ----- --------
Get-Calendar     cal   Displays a visual representation of a calendar.
Show-Calendar    scal  Display a colorized calendar month in the console.
Show-GuiCalendar gcal  Display a WPF-based calendar
```

Get module commands using the default formatted view. You can install this module from the PowerShell Gallery.

### Example 2

```powershell
PS C:\> Get-ModuleCommand smbshare -ListAvailable | Format-List


ModuleName : SmbShare
Name       : Block-SmbShareAccess
Alias      : blsmba
Synopsis   : Adds a deny ACE for a trustee to the security descriptor of the SMB share.

ModuleName : SmbShare
Name       : Close-SmbOpenFile
Alias      : cssmbo
Synopsis   : Closes a file that is open by one of the clients of the SMB server.

ModuleName : SmbShare
Name       : Close-SmbSession
Alias      : cssmbse
Synopsis   : Ends forcibly the SMB session.
...
```

Using the default list view.

### Example 3

```powershell
PS C:\> Get-ModuleCommand PSScriptTools | Format-Table -view verb



   Verb: Add

Name             Alias        Type        Synopsis
----             -----        ----        --------
Add-Border                    Function    Create a text border around a string.


   Verb: Compare

Name            Alias           Type        Synopsis
----            -----           ----        --------
Compare-Module  cmo             Function    Compare PowerShell module versions.

...
```

Display commands using a custom table view called 'Verb'.

### Example 4

```powershell
PS C:\ Get-ModuleCommand PSScriptTools | Format-Table -view version

   ModuleName: PSScriptTools [v2.41.0]

Name                        Alias             Compatible      PSVersion
----                        -----             ----------      ---------
Add-Border                  ab                {Desktop, Core}       5.1
Compare-Module              cmo               {Desktop, Core}       5.1
Compare-Script              csc               {Desktop, Core}       5.1
Convert-CommandToHashtable                    {Desktop, Core}       5.1
...
```

Using the custom table view 'version'.

## PARAMETERS

### -FullyQualifiedName

Specifies names of modules in the form of ModuleSpecification objects. The FullyQualifiedName parameter accepts a module name that is specified in the following formats:

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

Indicates that this cmdlet gets all installed modules. Get-Module finds modules in paths listed in the PSModulePath environment variable. Without this parameter, Get-ModuleCommand gets only the modules that are both listed in the PSModulePath environment variable, and that are loaded in the current session.

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
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### ModuleCommand

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Get-Command]()

[Get-Module]()
