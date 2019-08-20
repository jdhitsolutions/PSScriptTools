---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version: http://bit.ly/31SGo5o
schema: 2.0.0
---

# New-PSFormatXML

## SYNOPSIS

Create or modify a format.ps1xml file

## SYNTAX

```yaml
New-PSFormatXML [-InputObject] <Object> [[-Properties] <String[]>] [-Typename <String>]
 [[-FormatType] <String>] [[-ViewName] <String>] [-Path] <String> [-GroupBy <String>] [-Append] [-Passthru]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

When defining custom objects with a new typename, PowerShell by default will display all properties. However, you may wish to have a specific default view, be it a table or list. Or you may want to have different views display the object differently. Format directives are stored in format.ps1xml files which can be tedious to create. This command simplifies that process.

Pipe an instance of your custom object to this function and it will generate a format.ps1xml file based on either all the properties or a subset that you provide. You can repeat the process to add additional views. When finished, edit the format.ps1xml file and fine tune it. The file will have notes on how to substitute script blocks. If you run this command inside VS Code and use -Passthru, the new file will automatically be opened in your editor.

Note that table views are set to Autosize. But the table definition will include best guesses for column widths. If you prefer a more granular approach you can delete the Autosize tag and experiment with varying widths. Don't forget to run Update-FormatData to load your new file. You may need to start a new PowerShell session to test changes.

## EXAMPLES

### Example 1

```powershell
PS C:\> $tname = "myThing"
PS C:\> $obj = [PSCustomObject]@{
    PSTypeName   = $tname
    Name         = "Jeff"
    Date         = (Get-Date)
    Computername = $env:computername
    OS           = (Get-Ciminstance win32_operatingsystem -Property Caption).caption
}
PS C:\> Update-TypeData -TypeName $tname -MemberType "ScriptProperty" -MemberName "Runtime" -value {(Get-Date) - [datetime]"1/1/2019"} -force
PS C:\> $obj

Name         : Jeff
Date         : 2/10/2019 8:49:10 AM
Computername : BOVINE320
OS           : Microsoft Windows 10 Pro
Runtime      : 40.20:49:43.9205882
```

This example begins be creating a custom object. You might normally do this in a script or module.

### Example 2

```powershell
PS C:\> $obj | New-PSFormatXML -Properties Name, Date, Computername, OS -FormatType Table -path "C:\work\$tname.format.ps1xml"
PS C:\> $obj | New-PSFormatXML -Properties Name, OS, Runtime -FormatType Table -view runtime -path "C:\work\$tname.format.ps1xml" -append
PS C:\> $obj | New-PSFormatXML -FormatType List -path "C:\work\$tname.format.ps1xml" -append
```

The object is then piped to this command to generate a new format.ps1xml. Subsequent commands add more formatted views. When the file is completed it can be modified.

### Example 3

```powershell
PS C:\> Update-FormatData -appendpath "C:\work\$tname.format.ps1xml"
PS C:\> $obj

Name Date                 Computername Operating System
---- ----                 ------------ ----------------
Jeff 2/10/2019 8:49:10 AM BOVINE320    Microsoft Windows 10 Pro

PS C:\> $obj | format-table -View runtime

Name OS Runtime
---- -- -------
Jeff    40.20:56:24.5411481

PS C:\> $obj | format-list


Name            : Jeff
Date            : Sunday, February 10, 2019
Computername    : BOVINE320
OperatingSystem : Microsoft Windows 10 Pro
Runtime         : 40.21:12:01
```

After the format.ps1xml file is applied, the object can be formatted as designed.

### Example 4

```powershell
PS C:\> $obj | New-PSFormatXML -viewname computer -GroupBy Computername -path "c:\work\$tname.format.ps1xml" -append
PS C:\> Update-FormatData -appendpath "C:\work\$tname.format.ps1xml"
PS C:\> $obj | format-table -View computer


   Computername: BOVINE320

Name Date                  OS                       Runtime
---- ----                  --                       -------
Jeff 2/10/2019 8:49:10 AM Microsoft Windows 10 Pro 40.20:56:24.5411481
```

This adds another view called Computer that groups objects on the Computername property.

## PARAMETERS

### -Append

Append the new view to an existing format.ps1xml file.

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

### -FormatType

Specify whether to create a table or list view

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: Table, List

Required: False
Position: 2
Default value: Table
Accept pipeline input: False
Accept wildcard characters: False
```

### -InputObject

Specify an object to analyze and generate or update a ps1xml file. All you need is one instance of the object.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Passthru

Write the ps1xml file object to the pipeline. If you run this command inside VS Code and use this parameter, the file will be opened in the editor.

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

### -Path

Enter full filename and path for the format.ps1xml file.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Properties

Enter a set of properties to include. If you don't specify anything then all properties will be used.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ViewName

Enter the name of your view.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: default
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

### -Typename

Specify the object typename. If you don't, then the command will use the detected object type from the Inputobject.

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

### -GroupBy

Specify a property name to group on. You can edit the file if you need to change how it is displayed and/or calculated.

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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Object

## OUTPUTS

### None

### System.IO.FileInfo

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Update-FormatData]()
