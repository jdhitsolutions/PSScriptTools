---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version: https://jdhitsolutions.com/yourls/9825a9
schema: 2.0.0
---

# Get-TypeConstructor

## SYNOPSIS

Get constructor details for a .NET type.

## SYNTAX

```yaml
Get-TypeConstructor [-TypeName] <Type> [<CommonParameters>]
```

## DESCRIPTION

Often you need to create a new instance of a .NET type and you need to know what constructors are available. This function will return the constructors for a .NET type. The default output is formatted to display the kind of syntax you would use in your PowerShell code.

## EXAMPLES

### Example 1

```powershell
PS C:\> Get-TypeConstructor System.Drawing.SolidBrush

[System.Drawing.SolidBrush]::new([System.Drawing.Color]$Color))
```

The default formatting will using color to highlight the parameter name you would need.

### Example 2

```powershell
PS C:\> Get-TypeConstructor diagnostics.process

[System.Diagnostics.Process]::new()
```

This type doesn't need any parameters to create a new instance.

### Example 3

```powershell
PS C:\> Get-TypeConstructor system.drawing.rectangle

[System.Drawing.Rectangle]::new([System.Int32]$X),
                        [System.Int32]$Y),
                        [System.Int32]$Width),
                        [System.Int32]$Height))

[System.Drawing.Rectangle]::new([System.Drawing.Point]$Location),[System.Drawing.Size]$Size))
```

Constructors with more than three parameters will be displayed in a list to make it easier to read.

### Example 4

```powershell
PS C:\> ctor int32
WARNING: No constructors found for Int32
```

The function has an alias of ctor for convenience. Note there is no period.

## PARAMETERS

### -TypeName

Specify a .NET type name like DateTime

```yaml
Type: Type
Parameter Sets: (All)
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

### psTypeConstructor

## NOTES

Learn more about PowerShell: https://jdhitsolutions.com/yourls/newsletter

## RELATED LINKS

[Get-TypeMember](Get-TypeMember.md)
