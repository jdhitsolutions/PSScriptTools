---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version: https://bit.ly/3dqVRjO
schema: 2.0.0
---

# Get-PSProfile

## SYNOPSIS

Get PowerShell profile locations.

## SYNTAX

```yaml
Get-PSProfile [<CommonParameters>]
```

## DESCRIPTION

This command is designed for Windows-based systems to show all possible PowerShell profile scripts. Including those for VS Code and the PowerShell ISE.

## EXAMPLES

### Example 1

```powershell

PS C:\> Get-PSProfile

   Name: PowerShell

Scope                  Path                                                                Exists
-----                  ----                                                                ------
AllUsersCurrentHost    C:\Program Files\PowerShell\7\Microsoft.PowerShell_profile.ps1      False
AllUsersAllHosts       C:\Program Files\PowerShell\7\profile.ps1                           False
CurrentUserAllHosts    C:\Users\Jeff\Documents\PowerShell\profile.ps1                      True
CurrentUserCurrentHost C:\Users\Jeff\Documents\PowerShell\Microsoft.PowerShell_profile.ps1 True


   Name: Windows PowerShell

Scope                  Path                                                                        Exists
-----                  ----                                                                        ------
AllUsersCurrentHost    C:\WINDOWS\System32\WindowsPowerShell\v1.0\Microsoft.PowerShell_profile.ps1 True
AllUsersAllHosts       C:\WINDOWS\System32\WindowsPowerShell\v1.0\profile.ps1                      True
CurrentUserAllHosts    C:\Users\Jeff\Documents\WindowsPowerShell\profile.ps1                       True
CurrentUserCurrentHost C:\Users\Jeff\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1  True


   Name: VSCode PowerShell

Scope                  Path                                                            Exists
-----                  ----                                                            ------
CurrentUserCurrentHost C:\Users\Jeff\Documents\PowerShell\Microsoft.VSCode_profile.ps1 True
AllUsersCurrentHost    C:\Program Files\PowerShell\7\Microsoft.VSCode_profile.ps1      False
...
```

The command has a default formatted table view.

### Example 2

```powershell
 PS C:\> Get-PSProfile | Where-Object Exists | Format-List


   Name: PowerShell


Scope        : CurrentUserAllHosts
Path         : C:\Users\Jeff\Documents\PowerShell\profile.ps1
Exists       : True
LastModified : 9/9/2020 2:35:45 PM

Scope        : CurrentUserCurrentHost
Path         : C:\Users\Jeff\Documents\PowerShell\Microsoft.PowerShell_profile.ps1
Exists       : True
LastModified : 9/9/2020 2:03:44 PM



   Name: Windows PowerShell


Scope        : AllUsersCurrentHost
Path         : C:\WINDOWS\System32\WindowsPowerShell\v1.0\Microsoft.PowerShell_profile.ps1
Exists       : True
LastModified : 10/9/2020 4:08:35 PM
...
```

The command has a default list view.

## PARAMETERS

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### PSProfilePath

## NOTES

Learn more about PowerShell: https://jdhitsolutions.com/yourls/newsletter

## RELATED LINKS
