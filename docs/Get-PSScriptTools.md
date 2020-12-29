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
Get-PSScriptTools [-Verb <String>] [<CommonParameters>]
```

## DESCRIPTION

You can use this command to get a summary display of functions included in the PSScriptTools module. Use the -Verb parameter to filter the output.

## EXAMPLES

### Example 1

```powershell
PS C:\> Get-PSScriptTools


   Verb: Add

Name                 Alias                Synopsis
----                 -----                --------
Add-Border                                Create a text border around a string.


   Verb: Compare

Name                 Alias                Synopsis
----                 -----                --------
Compare-Module       cmo                  Compare PowerShell module versions.


   Verb: Convert

Name                        Alias          Synopsis
----                        -----          --------
Convert-CommandToHashtable                 Convert a PowerShell expression i...
Convert-EventLogRecord      clr            Convert EventLogRecords to struct...
Convert-HashtableString                    Convert a hashtable string into a...
Convert-HashtableToCode                    Convert a hashtable to a string r...
...
```

### Example 2

```powershell
PS C:\> Get-PSScriptTools | Where alias

   Verb: Compare

Name                        Alias      Synopsis
----                        -----      --------
Compare-Module              cmo        Compare PowerShell module versions.
Compare-Script              csc        Compare PowerShell script versions.

   Verb: Convert

Name                        Alias      Synopsis
----                        -----      --------
Convert-EventLogRecord      clr        Convert EventLogRecords to structured...
Convert-HashtableToCode     chc        Convert a hashtable to a string repre...
...
```

List commands with defined aliases in the PSScriptTools module.

### Example 3

```powershell
PS C:\> Get-PSScriptTools -Verb Select


   Verb:Select

Name                        Alias                Synopsis
----                        -----                --------
Select-After                after                Select objects after a give...
Select-Before               before               Select objects before a giv...
Select-First                First                Select the first X number o...
Select-Last                 Last                 Select the last X number of...
Select-Newest               newest               Select the newest X number ...
Select-Oldest               oldest               Select the oldest X number ...
```

Get all module commands that use the Select verb.

## PARAMETERS

### -Verb

Filter commands based on a standard PowerShell verb.

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

### PSScriptTool

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Get-Command]()

[Get-Module]()

[Open-PSScriptToolsHelp](Open-PSScriptToolsHelp.md)
