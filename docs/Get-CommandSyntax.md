---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version: https://bit.ly/2H0mgti
schema: 2.0.0
---

# Get-CommandSyntax

## SYNOPSIS

Get provider-specific command syntax.

## SYNTAX

```yaml
Get-CommandSyntax [-Name] <String> [-ProviderName <String>] [<CommonParameters>]
```

## DESCRIPTION

Some PowerShell commands are provider aware and may have special syntax or parameters depending on what PSDrive you are using when you run the command. In Windows PowerShell, the help system could show you syntax based on a given path. However, this no longer appears to work. This command is intended as an alternative. Specify a cmdlet or function name, and the output will display the syntax detected when using different providers. Dynamic parameters will be highlighted with an ANSI-escape sequence.

## EXAMPLES

### Example 1

```powershell
PS C:\> Get-CommandSyntax -Name Get-Item

Registry

Get-Item [-Path] <string[]> [-Filter <string>] [-Include <string[]>]
[-Exclude <string[]>] [-Force] [-Credential <PSCredential>]
[<CommonParameters>]

Get-Item -LiteralPath <string[]> [-Filter <string>] [-Include <string[]>]
[-Exclude <string[]>] [-Force] [-Credential <PSCredential>]
[<CommonParameters>]


Alias

Get-Item [-Path] <string[]> [-Filter <string>] [-Include <string[]>]
[-Exclude <string[]>] [-Force] [-Credential <PSCredential>]
[<CommonParameters>]

Get-Item -LiteralPath <string[]> [-Filter <string>] [-Include <string[]>]
[-Exclude <string[]>] [-Force] [-Credential <PSCredential>]
[<CommonParameters>]
...
```

The output will show each PowerShell Provider and the corresponding command syntax. Dynamic parameters will be highlighted by color.

## PARAMETERS

### -Name

Enter the name of a PowerShell cmdlet or function.
Ideally, it has been loaded into the current PowerShell session.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProviderName

Enter a specific provider name. The default is all currently loaded providers.

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

### None

## OUTPUTS

### System.String

## NOTES

Learn more about PowerShell: https://jdhitsolutions.com/yourls/newsletter

## RELATED LINKS

[Get-Help]()

[Get-Command]()

[Get-ParameterInfo](Get-ParameterInfo.md)
