---
Module Name: PSScriptTools
Module Guid: f8deaba5-5c23-43aa-a59f-f508e7369a30
Download Help Link: {{Please enter FwLink manually}}
Help Version: 2.0
Locale: en-US
---

# PSScriptTools Module

## Description

This PowerShell module contains a number of functions you might use to enhance your own functions and scripts. It is intended to work with both Windows PowerShell and PowerShell Core as much as possible. Although some commands in this module will only work on a full Windows PowerShell platform.

### [Add-Border](./Add-Border.md)

This command will create a character or text based border around a line of text. You might use this to create a formatted text report or to improve the display of information to the screen.

### [Copy-Command](./Copy-Command.md)

This command will copy a PowerShell command, including parameters and help to a new user-specified command.

### [Format-Percent](./Format-Percent.md)

This command calculates a percentage of a value from a total, with the formula (value/total)*100. The default is to return a value to 2 decimal places but you can configure that with -Decimal. There is also an option to format the percentage as a string which will include the % symbol.

### [Format-String](./Format-String.md)

Use this command to apply different types of formatting to strings such as reverse, changing case or randomization.

### [Format-Value](./Format-Value.md)

This command will format a given numeric value. By default it will treat the number as an integer. Or you can specify a certain number of decimal places. The command will also allow you to format the value in KB, MB, etc.

### [Get-PSWho](./Get-PSWho.md)

This command will provide a summary of relevant information for the current user in a PowerShell Session. You might use this to troubleshoot an end-user problem running a script or command.

### [New-CustomFileName](./New-CustomFileName.md)

This command will generate a custom file name based on a template string that you provide.

### [New-RandomFileName](./New-RandomFileName.md)

Create a new random file name. The default is a completely random name including the extension.

### [Out-ConditionalColor](./Out-ConditionalColor.md)

This command is designed to take pipeline input and display it in a colorized format,based on a set of conditions.

### [Out-VerboseTee](./Out-VerboseTee.md)

This command is intended to let you see your verbose output and write the verbose messages to a log file. It will only work if the verbose pipeline is enabled, usually when your command is run with -Verbose.

### [Write-Detail](./Write-Detail.md)

This command is designed to be used within your functions and scripts to make it easier to write a detailed message that you can use as verbose output.

### [Get-PSLocation](./Get-PSLocation.md)

A simple function to get common locations. This can be useful with cross-platform scripting.

### [Get-PowerShellEngine](./Get-PowerShellEngine.md)

Use this command to quickly get the path to the PowerShell executable with an option for detailed information.

### [Out-More](./Out-More.md)

This command provides a PowerShell alternative to the cmd.exe MORE command, which doesn't work in the PowerShell ISE. When you have screens of information, you can page it with this function.

### [Invoke-InputBox](./Invoke-InputBox.md)

This function is a graphical replacement for Read-Host. It creates a simple WPF form that you can use to get user input. The value of the text box will be written to the pipeline.  It can be either a string or a secure string. You can customize the form's title, prompt and background color.

### [Test-Expression](./Test-Expression.md)

This command will test a PowerShell expression or scriptblock for a specified number of times and calculate the average runtime, in milliseconds, over all the tests. The output will also show the median and trimmed values.

### [Test-ExpressionForm](./Test-ExpressionForm.md)

A WPF front end to `Test-Expression`.

### [Find-CimClass](./Find-CimClass.md)

This function is designed to search an entire CIM repository for a class name. Sometimes, you may have a guess about a class name but not know the full name or even the correct namespace. `Find-CimClass` will recursively search for a given classname. You can use wildcards.

### [ConvertTo-Markdown](./ConvertTo-Markdown.md)

This command is designed to accept pipelined output and create a markdown document. The pipeline output will formatted as a text block. You can optionally define a title, content to appear before the output and content to appear after the output.

### [ConvertTo-WPFGrid](./ConvertTo-WPFGrid.md)]

This command is an alternative to `Out-Gridview`. It works much the same way. Run a PowerShell command and pipe it to this command. The output will be displayed in a data grid. You can click on column headings to sort. You can resize columns and you can re-order columns.

### [Show-Tree](./Show-Tree.md)

Shows the specified path as a graphical tree in the console. This is intended as PowerShell alternative to the tree DOS command. This function should work for any type of PowerShell provider and can be used to explore providers used for configuration like the WSMan provider or the registry.

### [Optimize-Text](./Optimize-Text.md)

Use this command to clean and optimize content from text files. Sometimes text files have blank lines or the content has trailing spaces. These sorts of issues can cause problems when passing the content to other commands.

### [Convert-CommandtoHashtable](./Convert-CommandtoHashtable.md)

This command is intended to convert a long PowerShell expression with named parameters into a splatting alternative.

### [Convert-HashtableString](./Convert-HashtableString.md)

This function is similar to Import-PowerShellDataFile. But where that command can only process a file, this command will take any hashtable-formatted string and convert it into an actual hashtable.

### [Convert-HashTableToCode](./Convert-HashTableToCode.md)

Use this command to convert a hashtable into its text or string equivalent.

### [ConvertTo-HashTable](./ConvertTo-HashTable.md)

This command will take an object and create a hashtable based on its properties. You can have the hashtable exclude some properties as well as properties that have no value.

### [Get-MyVariable](./Get-MyVariable.md)

 This function will return all variables not defined by PowerShell or by this function itself. The default is to return all user-created variables from the global scope but you can also specify a scope such as script, local or a number 0 through 5.

### [Join-Hashtable](./Join-Hashtable.md)

This command will combine two hashtables into a single hashtable. Normally this is as easy as $hash1+$hash2. But if there are duplicate keys, this will fail. Join-Hashtable will test for duplicate keys. If any of the keys from the first, or primary hashtable are found in the secondary hashtable, you will be prompted for which to keep.

### [New-PSDriveHere](./New-PSDriveHere.md)

This function will create a new PSDrive at the specified location. The default is the current location, but you can specify any PSPath. The function will take the last word of the path and use it as the name of the new PSDrive.

### [Select-First](./Select-First.md)

This command takes pipelined input and selects the first specified number of objects which are then written to the pipeline. You also have the option to sort on the specified property.

### [Select-Last](./Select-Last.md)

This is a script version of `Select-Object` designed to select the last X number of objects. The command takes pipelined input and selects the last specified number of objects which are then written to the pipeline. You have an option to first sort on the specified property.

### [Tee-Verbose](./Tee-Verbose.md)

This command is intended to let you see your verbose output and write the verbose messages to a log file. It will only work if the verbose pipeline is enabled, usually when your command is run with -Verbose. This function is designed to be used within your scripts and functions.

### [Compare-Module](./Compare-Module.md)

Use this command to compare module versions between what is installed against an online repository like the
PSGallery. Results will be automatically sorted by module name.

### [Get-ParameterInfo](./Get-ParameterInfo.md)

Using Get-Command, this function will return information about parameters for any loaded cmdlet or function. The common parameters like Verbose and ErrorAction are omitted.

### [Get-WindowsVersion](./Get-WindowsVersion.md)

This is a PowerShell version of the winver.exe utility. This command uses PowerShell remoting to query the
registry on a remote machine to retrieve Windows version information.

### [Get-WindowsVersionString](./Get-WindowsVersionString.md)

This is a PowerShell version of the winver.exe utility.This command uses PowerShell remoting to query the registry on a remote machine to retrieve Windows version information. The command writes a string of version information.

### [New-PSFormatXML](./New-PSFormatXML.md)

When defining custom objects with a new typename, PowerShell by default will display all properties. However, you may wish to have a specific default view, be it a table or list. Or you may want to have different views display the object differently. Format directives are stored in format.ps1xml files which can be tedious to create. This command simplifies that process.

### [New-WPFMessageBox](./New-WPFMessageBox.md)

This function creates a Windows Presentation Foundation (WPF) based message box. This is intended to replace the legacy MsgBox function from VBScript and the Windows Forms library. The command uses a set of predefined button sets, each of which will close the form and write a value to the pipeline.

### [Remove-Runspace](./Remove-Runspace.md)

During the course of your PowerShell work, you may discover that some commands and scripts can leave behind
runspaces. You may even deliberately be creating additional runspaces. These runspaces will remain until you exit your PowerShell session. Or use this command to cleanly close and dispose of runspaces.

### [ConvertTo-UTCTime](./ConvertTo-UTCTime.md)

Convert a local datetime to universal time.

### [ConvertTo-UTCTime](./ConvertFrom-UTCTime.md)

Convert a universal time to local time.

### [Get-MyTimeInfo](./Get-MyTimeInfo.md)

Display a time settings for a collection of locations.

### [Set-ConsoleTitle](./Set-ConsoleTitle.md)

Set the title bar of the current PowerShell console window.

### [Set-ConsoleColor](./Set-ConsoleColor.md)

Configure the foreground or background color of the current PowerShell console window.

### [ConvertTo-LocalTime](./ConvertTo-LocalTime.md)

Convert a non-local datetime to your local time.

### [Get-TZList](./Get-TZList.md)

Get a list of time zone areas.

### [Get-TZData](./Get-TZData.md)

Get details of a give time zone area.

### [Get-FileItem](./Get-FileItem.md)

A PowerShell version of the CLI where.exe command.