---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version: http://bit.ly/31SLyhD
schema: 2.0.0
---

# Convert-CommandToHashtable

## SYNOPSIS

Convert a PowerShell expression into a splatting equivalent.

## SYNTAX

```yaml
Convert-CommandToHashtable [-Text] <String> [<CommonParameters>]
```

## DESCRIPTION

This command is intended to convert a long PowerShell expression with named parameters into a splatting alternative. The central concept is that you are editing a script file with a lengthy PowerShell expression with multiple parameters and you would like to turn it into splatting code.

## EXAMPLES

### Example 1

```powershell
PS C:\> $text ="Get-Winevent -listlog p* -computername SRV1 -erroraction stop"
PS C:\> Convert-CommandToHashtable -Text $text | Set-Clipboard
```

The $text variable might be a line of code from your script. The second line converts into a splatting sequence and copies it to the Windows clipboard so you can paste it back into your script. You could create a VS Code task sequence using this function.

## PARAMETERS

### -Text

A PowerShell command using a single cmdlet or function, preferably with named parameters.

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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### Hashtable

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Convert-HashtableToCode](Convert-HashtableToCode.md)
