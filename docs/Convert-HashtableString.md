---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version: https://jdhitsolutions.com/yourls/59c4ce
schema: 2.0.0
---

# Convert-HashtableString

## SYNOPSIS

Convert a hashtable string into a hashtable object.

## SYNTAX

```yaml
Convert-HashtableString [-Text] <String> [<CommonParameters>]
```

## DESCRIPTION

This function is similar to Import-PowerShellDataFile. But where that command can only process a file, this command will take any hashtable-formatted string and convert it into an actual hashtable.

## EXAMPLES

### Example 1

```powershell
PS C:\> Get-Content c:\work\test.psd1 | Unprotect-CmsMessage | Convert-HashtableString

Name                           Value
----                           -----
CreatedBy                      BOVINE320\Jeff
CreatedAt                      10/02/2024 21:28:47 UTC
Computername                   Think51
Error
Completed                      True
Date                           10/02/2024 21:29:35 UTC
Scriptblock                    restart-service spooler -force
CreatedOn                      BOVINE320
```

The test.psd1 file is protected as a CMS Message. In this example, the contents are decoded as a string which is then in turn converted into an actual hashtable.

## PARAMETERS

### -Text

Enter your hashtable string.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

## OUTPUTS

### hashtable

## NOTES

Learn more about PowerShell: https://jdhitsolutions.com/yourls/newsletter

## RELATED LINKS

[Import-PowerShellDatafile]()

[Convert-HashtableToCode](Convert-HashtableToCode.md)
