---
Module Name: PSScriptTools
Module Guid: f8deaba5-5c23-43aa-a59f-f508e7369a30
Download Help Link: {{Please enter FwLink manually}}
Help Version: 1.0
Locale: en-US
---

# PSScriptTools Module
## Description
This PowerShell module contains a number of functions you might use to enhance your own functions and scripts. T

## PSScriptTools Cmdlets
### [Add-Border](Add-Border.md)
This command will create a character or text based border around a line of text. You might use this to create a formatted text report or to improve the display of information to the screen.

### [Copy-Command](Copy-Command.md)
This command will copy a PowerShell command, including parameters and help to a new user-specified command.

### [Format-Percent](Format-Percent.md)
This command calculates a percentage of a value from a total, with the formula (value/total)*100. The default is to return a value to 2 decimal places but you can configure that with -Decimal. There is also an option to format the percentage as a string which will include the % symbol.

### [Format-String](Format-String.md)
Use this command to apply different types of formatting to strings such as reverse, changing case or randomization.

### [Format-Value](Format-Value.md)
This command will format a given numeric value. By default it will treat the number as an integer. Or you can specify a certain number of decimal places. The command will also allow you to format the value in KB, MB, etc.
### [Get-PSWho](Get-PSWho.md)
This command will provide a summary of relevant information for the current user in a PowerShell Session. You might use this to troubleshoot an end-user problem running a script or command.

### [New-CustomFileName](New-CustomFileName.md)
This command will generate a custom file name based on a template string that you provide. 

### [New-RandomFileName](New-RandomFileName.md)
Create a new random file name. The default is a completely random name including the extension.

### [Out-ConditionalColor](Out-ConditionalColor.md)
This command is designed to take pipeline input and display it in a colorized format,based on a set of conditions.

### [Out-VerboseTee](Out-VerboseTee.md)
This command is intended to let you see your verbose output and write the verbose messages to a log file. It will only work if the verbose pipeline is enabled, usually when your command is run with -Verbose.

### [Write-Detail](Write-Detail.md)
This command is designed to be used within your functions and scripts to make it easier to write a detailed message that you can use as verbose output.

