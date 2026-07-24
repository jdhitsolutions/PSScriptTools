---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version: https://jdhitsolutions.com/yourls/1f9841
schema: 2.0.0
---

# Show-Enum

## SYNOPSIS

Display an enum's names and values.

## SYNTAX

```yaml
Show-Enum [-EnumType] <Type> [<CommonParameters>]
```

## DESCRIPTION

This command is intended to make it easier to discover an enum's names and values.

## EXAMPLES

### Example 1

```powershell
PS C:\> Show-Enum Dayofweek

   Typename: System.DayOfWeek

Name      Value
----      -----
Sunday        0
Monday        1
Tuesday       2
Wednesday     3
Thursday      4
Friday        5
Saturday      6
```

### Example 2

```powershell
PS C:\> Show-Enum System.Globalization.CultureTypes

   Typename: System.Globalization.CultureTypes

Name                   Value
----                   -----
NeutralCultures            1
SpecificCultures           2
InstalledWin32Cultures     4
AllCultures                7
UserCustomCulture          8
ReplacementCultures       16
WindowsOnlyCultures       32
FrameworkCultures         64
```

You might need to include the full type name.

## PARAMETERS

### -EnumType

Specify an enum type name like ConsoleColor.

```yaml
Type: Type
Parameter Sets: (All)
Aliases: Class, PropertyType

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Type

## OUTPUTS

### enumInfo

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/yourls/newsletter

## RELATED LINKS

[Test-IsEnum](Test-IsEnum.md)
