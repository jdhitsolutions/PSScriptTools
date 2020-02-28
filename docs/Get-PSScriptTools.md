---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version: http://bit.ly/3acixBH
schema: 2.0.0
---

# Get-PSScriptTools

## SYNOPSIS

Get a summary of PSScriptTools commands.

## SYNTAX

```yaml
Get-PSScriptTools [<CommonParameters>]
```

## DESCRIPTION

You can use this command to get a summary display of functions included in the PSScriptTools module.

## EXAMPLES

### Example 1

```powershell

PS C:\> Get-PSScriptTools


   Verb: Add

Name                        Alias                Synopsis
----                        -----                --------
Add-Border                                       Create a text border around a string.


   Verb: Compare

Name                        Alias                Synopsis
----                        -----                --------
Compare-Module              cmo                  Compare PowerShell module versions.


   Verb: Convert

Name                        Alias                Synopsis
----                        -----                --------
Convert-CommandtoHashtable                       Convert a PowerShell expression into a hashtable.
Convert-EventLogRecord      clr                  Convert EventLogRecords to structured objects
Convert-HashtableString                          Convert a hashtable string into a hashtable object.
Convert-HashTableToCode                          Convert a hashtable to a string representation.
...
```

### Example 2

```powershell
PS C:\> Get-PSScriptTools | Where-object alias | Select-Object Name,alias,Synopsis

Name                   Alias Synopsis
----                   ----- --------
Compare-Module         cmo   Compare PowerShell module versions.
Convert-EventLogRecord clr   Convert EventLogRecords to structured objects
ConvertFrom-Text       cft   Convert structured text to objects.
ConvertFrom-UTCTime    frut  Convert a datetime value from universal
ConvertTo-LocalTime    clt   Convert a foreign time to local
...
```

List commands with defined aliases in the PSScriptTools module.

## PARAMETERS

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### PSScriptTool

## NOTES

Learn more about PowerShell:
http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Get-Command]()

[Get-Module]()