---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version: https://jdhitsolutions.com/yourls/237adc
schema: 2.0.0
---

# Get-PSScriptTools

## SYNOPSIS

Get a summary of PSScriptTools commands.

## SYNTAX

```yaml
Get-PSScriptTools [-Verb <String>] [-Tag <String>] [<CommonParameters>]
```

## DESCRIPTION

You can use this command to get a summary display of functions included in the PSScriptTools module. Use the -Verb and -Tag parameters to filter the output.

## EXAMPLES

### Example 1

```powershell
PS C:\> Get-PSScriptTools

___ ___ ___         _      _  _____        _
| _ \ __/ __|__ _ _(_)_ __| |__   _|__ ___| |___
|  _\__ \__ \ _| '_| | '_ \  _|| |/ _ \ _ \ (_-<
|_| |___/___\__|_| |_| .__/\__||_|\___\___/_/__/
|_|
v3.2.0

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

The header is written to the host and not the pipeline. In PowerShell 7, the command name will be a clickable hyperlink that points to the online help for the command.

### Example 2

```powershell
PS C:\> Get-PSScriptTools | Where alias

___ ___ ___         _      _  _____        _
| _ \ __/ __|__ _ _(_)_ __| |__   _|__ ___| |___
|  _\__ \__ \ _| '_| | '_ \  _|| |/ _ \ _ \ (_-<
|_| |___/___\__|_| |_| .__/\__||_|\___\___/_/__/
|_|
v3.2.0

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

___ ___ ___         _      _  _____        _
| _ \ __/ __|__ _ _(_)_ __| |__   _|__ ___| |___
|  _\__ \__ \ _| '_| | '_ \  _|| |/ _ \ _ \ (_-<
|_| |___/___\__|_| |_| .__/\__||_|\___\___/_/__/
|_|
v3.2.0

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

### Example 4

```powershell
PS C:\> Get-PSScriptTools -verb test | Select Name,Alias,Online
___ ___ ___         _      _  _____        _
| _ \ __/ __|__ _ _(_)_ __| |__   _|__ ___| |___
|  _\__ \__ \ _| '_| | '_ \  _|| |/ _ \ _ \ (_-<
|_| |___/___\__|_| |_|_.__/\__||_|\___\___/_/__/
|_|                  |_|
v3.2.0

Name                Alias   Online
----                -----   ------
Test-EmptyFolder            https://jdhitsolutions.com/yourls/525f6d
Test-Expression     tex     https://jdhitsolutions.com/yourls/812715
Test-ExpressionForm texf    https://jdhitsolutions.com/yourls/b36e28
Test-IsElevated     isAdmin https://jdhitsolutions.com/yourls/e1c162
Test-IsEnum                 https://jdhitsolutions.com/yourls/a654eb
Test-IsPSWindows            https://jdhitsolutions.com/yourls/c102e6
Test-WithCulture            https://jdhitsolutions.com/yourls/15101d
```

The output is an object with properties you might want to use.

### Example 5

```powershell
PS C:\> Get-PSScriptTools -Tag ansi -verb Get | Format-Table -View tags
___ ___ ___         _      _  _____        _
| _ \ __/ __|__ _ _(_)_ __| |__   _|__ ___| |___
|  _\__ \__ \ _| '_| | '_ \  _|| |/ _ \ _ \ (_-<
|_| |___/___\__|_| |_|_.__/\__||_|\___\___/_/__/
|_|                  |_|
v3.2.0

Name                     Alias Tags            Synopsis
----                     ----- ----            --------
Get-CimMember            cmm   {ansi}          Get information about CIM cl....
Get-PSAnsiFileMap              {ansi}          Display the PSAnsiFileMap.
Get-WindowsVersionString wvers {general, ansi} Get Windows version informati...
```

Beginning with v3.2.0, you can also filter on a predefined list of tags that categorize each command. You can also use a new formatted table view called tags.

### Example 6

```powershell
PS C:\> Get-PSScriptTools -verb export | Select tagInfo
___ ___ ___         _      _  _____        _
| _ \ __/ __|__ _ _(_)_ __| |__   _|__ ___| |___
|  _\__ \__ \ _| '_| | '_ \  _|| |/ _ \ _ \ (_-<
|_| |___/___\__|_| |_|_.__/\__||_|\___\___/_/__/
|_|                  |_|
v3.2.0

Name     : Export-PSAnsiFileMap
Alias    :
Tags     : {ansi}
Synopsis : Export a PSAnsiFileMap to a file.
Help     : https://jdhitsolutions.com/yourls/33a505
```

You can also use the tagInfo property set.

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

### -Tag

Filter commands based on command tag. Valid values:

'ansi','cim','console','editor','file','format','general','graphical','hashtable','other','scripting','select','time'

Even though a command might have multiple tags, you can only filter on a single one.

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

Learn more about PowerShell: https://jdhitsolutions.com/yourls/newsletter

## RELATED LINKS

[Get-Command]()

[Get-Module]()

[Open-PSScriptToolsHelp](Open-PSScriptToolsHelp.md)
