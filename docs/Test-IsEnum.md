---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version: https://jdhitsolutions.com/yourls/a654eb
schema: 2.0.0
---

# Test-IsEnum

## SYNOPSIS

Test if a .NET class is an enum.

## SYNTAX

```yaml
Test-IsEnum [-EnumType] <Type> [<CommonParameters>]
```

## DESCRIPTION

This is a simple command to test if a .NET class is an enum.

## EXAMPLES

### Example 1

```powershell
PS C:\> Test-IsEnum DateTime
False
```

### Example 2

```powershell
PS C:\> if (Test-IsEnum ConsoleColor) { Show-Enum ConsoleColor}

   Typename: System.ConsoleColor

Name        Value
----        -----
Black           0
DarkBlue        1
DarkGreen       2
DarkCyan        3
DarkRed         4
DarkMagenta     5
DarkYellow      6
Gray            7
DarkGray        8
Blue            9
Green          10
Cyan           11
Red            12
Magenta        13
Yellow         14
White          15
```

Because the command writes a boolean result, it is easy to use in an If statement.

## PARAMETERS

### -EnumType

Specify an enum type name like ConsoleColor

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

### Boolean

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/yourls/newsletter

## RELATED LINKS

[Show-Enum](Show-Enum.md)
