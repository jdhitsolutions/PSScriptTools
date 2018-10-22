---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version:
schema: 2.0.0
---

# New-PSDriveHere

## SYNOPSIS

Create a new PSDrive at the current location.

## SYNTAX

### Folder (Default)

```yaml
New-PSDriveHere [[-Path] <String>] [-First] [-SetLocation] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Name

```yaml
New-PSDriveHere [[-Path] <String>] [[-Name] <String>] [-SetLocation] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

This function will create a new PSDrive at the specified location. The default is the current location, but you can specify any PSPath. The function will take the last word of the path and use it as the name of the new PSDrive. If you prefer to use the first word of the location, use -First. If you prefer to specify a totally different name, then use the -Name parameter.

## EXAMPLES

### EXAMPLE 1

```PowerShell
PS C:\users\jeff\documents\Enterprise Mgmt Webinar> new-psdrivehere

Name           Used (GB)     Free (GB) Provider      Root                                 CurrentLocation
----           ---------     --------- --------      ----                                 ---------------
Webinar                         146.57 FileSystem    C:\users\jeff\Documents\Enter...
```

### EXAMPLE 2

```powerShell
PS C:\users\jeff\documents\Enterprise Mgmt Webinar> new-psdrivehere -first

Name           Used (GB)     Free (GB) Provider      Root                                 CurrentLocation
----           ---------     --------- --------      ----                                 ---------------
Enterprise                      146.57 FileSystem    C:\users\jeff\Documents\Enter...
```

### EXAMPLE 3

```powershell
PS C:\> new-psdrivehere HKLM:\software\microsoft

Name           Used (GB)     Free (GB) Provider      Root                                 CurrentLocation
----           ---------     --------- --------      ----                                 ---------------
microsoft                              Registry      HKEY_LOCAL_MACHINE\software\micr...
```

### EXAMPLE 4

```powershell
PS C:\> new-psdrivehere -Path "\\jdh-nvnas\files\powershell" -Name PSFiles

Name           Used (GB)     Free (GB) Provider      Root                                 CurrentLocation
----           ---------     --------- --------      ----                                 ---------------
PSFiles                                FileSystem    \\jdh-nvnas\files\powershell
```

### EXAMPLE 5

```powershell
PS C:\Users\Jeff\Documents\DeepDive> new-psdrivehere . DeepDive -setlocation

Name           Used (GB)     Free (GB) Provider      Root                                 CurrentLocation
----           ---------     --------- --------      ----                                 ---------------
DeepDive                        130.53 FileSystem    C:\Users\Jeff\Documents\DeepDive


PS DeepDive:\>
```

Set a new PSDrive and change your location to it.

## PARAMETERS

### -Path

The path for the new PSDrive. The default is the current location.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: .
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name

The name for the new PSDrive. The default is the last word in the specified location, unless you use -First.

```yaml
Type: String
Parameter Sets: Name
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -First

Use the first word of the current location for the new PSDrive.

```yaml
Type: SwitchParameter
Parameter Sets: Folder
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -SetLocation

Set location to this new drive. This parameter has an alias of CD.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cd

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf

Shows what would happen if the cmdlet runs. The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm

Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Management.Automation.PSDrive

## NOTES

Originally published at http://jdhitsolutions.com/blog/2010/08/new-psdrivehere/

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Get-PSDrive]()

[New-PSDrive]()
