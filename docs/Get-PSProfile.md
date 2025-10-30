---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version: https://jdhitsolutions.com/yourls/d4ded2
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

This command is designed to show all possible PowerShell profile scripts. Including those for VS Code and the PowerShell ISE.

## EXAMPLES

### Example 1

```powershell
PS C:\> Get-PSProfile

   Name: PowerShell

Scope                  Exists Path
-----                  ------ ----
AllUsersAllHosts       True   C:\Program Files\PowerShell\7\profile.ps1
AllUsersCurrentHost    False  C:\Program Files\PowerShell\7\Microsoft.PowerShel…
CurrentUserAllHosts    True   C:\Users\Jeff\Documents\PowerShell\profile.ps1
CurrentUserCurrentHost True   C:\Users\Jeff\Documents\PowerShell\Microsoft.Powe…

   Name: Windows PowerShell

Scope                  Exists Path
-----                  ------ ----
AllUsersAllHosts       True   C:\WINDOWS\System32\WindowsPowerShell\v1.0\profil…
AllUsersCurrentHost    False  C:\WINDOWS\System32\WindowsPowerShell\v1.0\Micros…
CurrentUserAllHosts    True   C:\Users\Jeff\Documents\WindowsPowerShell\profile…
CurrentUserCurrentHost True   C:\Users\Jeff\Documents\WindowsPowerShell\Microso…

   Name: VSCode PowerShell

Scope                  Exists Path
-----                  ------ ----
AllUsersCurrentHost    False  C:\Program Files\PowerShell\7\Microsoft.VSCode_pr…
CurrentUserCurrentHost True   C:\Users\Jeff\Documents\PowerShell\Microsoft.VSCo…

   Name: VSCode Windows PowerShell

Scope                  Exists Path
-----                  ------ ----
AllUsersCurrentHost    False  C:\WINDOWS\System32\WindowsPowerShell\v1.0\Micros…
CurrentUserCurrentHost True   C:\Users\Jeff\Documents\WindowsPowerShell\Microso…

   Name: PowerShell ISE

Scope                  Exists Path
-----                  ------ ----
AllUsersCurrentHost    True   C:\WINDOWS\System32\WindowsPowerShell\v1.0\Micros…
CurrentUserCurrentHost True   C:\Users\Jeff\Documents\WindowsPowerShell\Microso…
```

The command has a default formatted table view. Files that don't exist will be shown in Red.

### Example 2

```powershell
PS C:\> Get-PSProfile | Where-Object Exists | Format-List

   Name: PowerShell

Scope        : AllUsersAllHosts
Path         : C:\Program Files\PowerShell\7\profile.ps1
Exists       : True
LastModified : 2/23/2022 1:27:30 PM

Scope        : CurrentUserAllHosts
Path         : C:\Users\Jeff\Documents\PowerShell\profile.ps1
Exists       : True
LastModified : 10/5/2020 3:50:19 PM

Scope        : CurrentUserCurrentHost
Path         : C:\Users\Jeff\Documents\PowerShell\Microsoft.PowerShell_profile.p
               s1
Exists       : True
LastModified : 10/5/2020 3:50:19 PM


   Name: Windows PowerShell

Scope        : AllUsersAllHosts
Path         : C:\WINDOWS\System32\WindowsPowerShell\v1.0\profile.ps1
Exists       : True
LastModified : 2/23/2022 1:54:55 PM

Scope        : CurrentUserAllHosts
Path         : C:\Users\Jeff\Documents\WindowsPowerShell\profile.ps1
Exists       : True
LastModified : 10/5/2020 3:49:25 PM
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

[Get-PSLocation](Get-PLocation.md)
