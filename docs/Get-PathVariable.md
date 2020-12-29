---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version: https://bit.ly/33UwYKo
schema: 2.0.0
---

# Get-PathVariable

## SYNOPSIS

Get information from locations in %PATH%.

## SYNTAX

```yaml
Get-PathVariable [[-Scope] <String>] [<CommonParameters>]
```

## DESCRIPTION

Use this command to test the locations specified in the %PATH% environment variable. On Windows platforms, you can distinguish between settings set per machine and those set per user. On non-Windows platforms, the scope will be Process.

## EXAMPLES

### Example 1

```powershell
PS C:\> Get-PathVariable

Scope   UserName Path                                            Exists
-----   -------- ----                                            ------
User    Jeff     C:\Program Files\kdiff3                         True
User    Jeff     C:\Program Files (x86)\Bitvise SSH Client       True
User    Jeff     C:\Program Files\OpenSSH                        True
...
Machine Jeff     C:\WINDOWS                                      True
Machine Jeff     C:\WINDOWS\system32                             True
Machine Jeff     C:\WINDOWS\System32\Wbem                        True
...
```

### Example 2

```powershell
PS /home/jeff> Get-PathVariable | Where-Object {-Not $_.exists}

Scope        : Process
Computername : Bovine320
UserName     : jeff
Path         : /snap/bin
Exists       : False
```

This example is on a Linux platform, finding locations that don't exist or can be verified. You could run the same command on Windows.

## PARAMETERS

### -Scope

On Windows platforms you can distinguish between Machine and User specific settings.

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: All, User, Machine

Required: False
Position: 0
Default value: All
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### EnvPath

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS
