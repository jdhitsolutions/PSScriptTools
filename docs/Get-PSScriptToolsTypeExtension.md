---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version: https://jdhitsolutions.com/yourls/01064c
schema: 2.0.0
---

# Get-PSScriptToolsTypeExtension

## SYNOPSIS

Get available custom type extensions

## SYNTAX

```yaml
Get-PSScriptToolsTypeExtension [[-TypeName] <String>] [<CommonParameters>]
```

## DESCRIPTION

The PSScriptTools module includes several custom type extensions that you can import. These will add functionality to output of commands like Get-Process and Measure-Object. Use this command to get information about available extensions.

## EXAMPLES

### Example 1

```powershell
PS C:\> Get-PSScriptToolsTypeExtension -TypeName *file*

TypeName   : System.IO.FileInfo
Description: Alias and script properties designed to extend the file object. There is also a PropertySet called AgeInfo.

    MemberType    MemberName
    ----------    ----------
    AliasProperty Created
    AliasProperty Modified
    AliasProperty Size
      PropertySet AgeInfo
   ScriptProperty SizeKB
   ScriptProperty ModifiedAge
   ScriptProperty CreatedAge
   ScriptProperty SizeMB
```

The default behavior is to list all available extensions. You can filter the list by providing a wildcard pattern for the TypeName parameter.

## PARAMETERS

### -TypeName

The name of the custom type extension set

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: True
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

## OUTPUTS

### PSScriptToolsTypeExtension

## NOTES

Learn more about PowerShell: https://jdhitsolutions.com/yourls/newsletter

## RELATED LINKS

[Import-PSScriptToolsTypeExtension](Import-PSScriptToolsTypeExtension.md)
