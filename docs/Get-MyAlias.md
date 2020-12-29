---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version: https://github.com/jdhitsolutions/PSScriptTools/blob/master/docs/Get-MyAlias.md
schema: 2.0.0
---

# Get-MyAlias

## SYNOPSIS

Get non-default aliases defined in the current session.

## SYNTAX

```yaml
Get-MyAlias [-NoModule] [<CommonParameters>]
```

## DESCRIPTION

Often you might define aliases for functions and scripts you use often. It may difficult sometimes to remember them all or to find them in the default Get-Alias output. This command will list all currently defined aliases that are not part of the initial PowerShell state.

The PSScriptTools module also includes a custom formatting file for alias objects which you can use with Get-Alias or Get-MyAlias. See examples.

## EXAMPLES

### Example 1

```powershell
PS C:\> Get-MyAlias

CommandType     Name                                 Version    Source
-----------     ----                                 -------    ------
Alias           abt -> Get-AboutInfo
Alias           bv -> Brave
Alias           cal -> Get-Calendar                  1.11.0     PSCalendar
Alias           cc -> Copy-Command                   2.27.0     PSScriptTools
Alias           cfn -> New-CustomFileName            2.27.0     PSScriptTools
Alias           CFS -> ConvertFrom-String            3.1.0.0    Microsoft.Po...
Alias           cft -> ConvertFrom-Text              2.27.0     PSScriptTools
Alias           chc -> Convert-HashTableToCode       2.27.0     PSScriptTools
Alias           che -> Copy-HelpExample              2.27.0     PSScriptTools
Alias           cl -> Create-List
Alias           clr -> Convert-EventLogRecord        2.27.0     PSScriptTools
Alias           clt -> ConvertTo-LocalTime           2.27.0     PSScriptTools
Alias           cmo -> Compare-Module                2.27.0     PSScriptTools
...
```

Get all aliases that aren't par of the initial session state. This will include aliases defined in any modules you have loaded.

### Example 2

```powershell
PS C:\> Get-MyAlias -NoModule

CommandType     Name                             Version    Source
-----------     ----                             -------    ------
Alias           abt -> Get-AboutInfo
Alias           bv -> Brave
Alias           cl -> Create-List
```

Get defined aliases that don't belong to a module. These should be aliases you have defined in stand-alone scripts or your profile.

### Example 3

```powershell
PS C:\> Get-MyAlias -NoModule | Format-Table -View options

Name Definition    Options  ModuleName Version
---- ----------    -------  ---------- -------
abt  Get-AboutInfo None
bv   Brave         None
cl   Create-List   None
np   notepad       ReadOnly
```

Get your aliases and pipe to format table using a custom view defined by the PSScriptTools module.

## PARAMETERS

### -NoModule

Only show aliases that DO NOT belong to a module.

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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Management.Automation.AliasInfo

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Get-Alias]()
