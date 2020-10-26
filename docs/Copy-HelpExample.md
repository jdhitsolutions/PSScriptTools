---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version: https://bit.ly/3dlKTfI
schema: 2.0.0
---

# Copy-HelpExample

## SYNOPSIS

Copy code snippet from help examples.

## SYNTAX

```yaml
Copy-HelpExample [-Name] <String> [-Path <String>] [-UseGridView]
[<CommonParameters>]
```

## DESCRIPTION

This command is intended to make it easier to copy code snippets from help examples to the clipboard. You can select one or more examples which have been trimmed of comments, blank lines and most prompts. Some code examples contain the output or have several lines of code. You will need to manually delete what you don't want. If this command is run on a Windows system you have a dynamic parameter to use Out-Gridview to display your choices. When prompted enter a comma separated list of the examples you wish to copy. Otherwise, the command will display a console-based menu. Note that if you are using the PowerShell ISE you will be forced to use Out-GridView.

## EXAMPLES

### Example 1

```powershell
PS C:\> Copy-HelpExample -Name Stop-Process

Code Samples

Each help example is numbered to the left. At the prompt below, select the code
samples you want to copy to the clipboard. Separate multiple values with a
comma.

Some example code includes the output.


[1] Example 1: Stop all instances of a process

    Stop-Process -Name "notepad"

[2] Example 2: Stop a specific instance of a process

    Stop-Process -Id 3952 -Confirm -PassThru
Confirm
Are you sure you want to perform this action?
Performing operation "Stop-Process" on Target "notepad (3952)".
[Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help
(default is "Y"):y
Handles  NPM(K)    PM(K)      WS(K) VM(M)   CPU(s)     Id ProcessName
-------  ------    -----      ----- -----   ------     -- -----------
41       2      996       3212    31            3952 notepad

[3] Example 3: Stop a process and detect that it has stopped

    calc
 $p = Get-Process -Name "calc"
 Stop-Process -InputObject $p
 Get-Process | Where-Object {$_.HasExited}

[4] Example 4: Stop a process not owned by the current user

    Get-Process -Name "lsass" | Stop-Process

Stop-Process : Cannot stop process 'lsass (596)' because of the following error
: Access is denied
At line:1 char:34
+ Get-Process -Name "lsass" | Stop-Process <<<<

[ADMIN]:  Get-Process -Name "lsass" | Stop-Process

Warning!
Are you sure you want to perform this action?
Performing operation 'Stop-Process' on Target 'lsass(596)'
[Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help (default is "Y"):
[ADMIN]:  Get-Process -Name "lsass" | Stop-Process -Force
[ADMIN]:

Please select items to copy to the clipboard by number. Separate multiple entries with a comma. Press Enter alone to cancel:
```

The console menu will be displayed using ANSI. Enter a comma separated list of numbers for the items to copy to the clipboard.

## PARAMETERS

### -Name

Enter the name of the PowerShell command.

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

### -Path

Gets help that explains how the cmdlet works in the specified provider path. Enter a PowerShell provider path.

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

### -UseGridView

Select help examples using Out-Gridview. This parameter is only available on Windows systems. The parameter has an alias of 'ogv'.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: ogv

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

### None

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Get-Help]()
