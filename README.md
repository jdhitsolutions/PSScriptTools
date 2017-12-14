# ![](./images/toolbox-thumbnail.png)  PSScriptTools

This PowerShell module contains a number of functions you might use to enhance your own functions and scripts. The [Samples](./samples) folder contains demonstration script files.

## Current Release
The current release is [PSScriptTools-v1.0.1](https://github.com/jdhitsolutions/PSScriptTools/archive/v1.0.1.zip)

You can also install this from the PowerShell Gallery:
```
Install-Module PSScriptTools
```

Please post any questions, problems or feedback in Issues. Any input is greatly appreciated.

## Add-Border
This command will create a character or text based border around a line of text. You might use this to create a formatted text report or to improve the display of information to the screen.

```
PS C:\> add-border $env:computername

*************
*   COWPC   *
*************
```

## Get-PSWho
This command will provide a summary of relevant information for the current user in a PowerShell Session. You might use this to troubleshoot an end-user problem running a script or command.

```
PS C:\> Get-PSWho

User            : COWPC\Jeff
Elevated        : True
Computername    : COWPC
OperatingSystem : Microsoft Windows 10 Pro [64-bit]
OSVersion       : 10.0.16299
PSVersion       : 5.1.16299.64
Edition         : Desktop
PSHost          : ConsoleHost
WSMan           : 3.0
ExecutionPolicy : RemoteSigned
Culture         : en-US
```
## New-CustomFileName
This command will generate a custom file name based on a template string that you provide. 

```
PS C:\> New-CustomFileName %computername_%day%monthname%yr-%time.log
COWPC_28Nov17-142138.log

PS C:\> New-CustomFileName %dayofweek-%####.dat
Tuesday-3128.dat
```

You can create a template string using any of these variables. Most of these should be self-explanatory

- %username     
- %computername 
- %year  - 4 digit year        
- %yr  - 2 digit year         
- %monthname - The abbreviated month name   
- %month  - The month number      
- %dayofweek - The full name of the week day   
- %day          
- %hour         
- %minute       
- %time         
- %string - A random string       
- %guid       

You can also insert a random number using %### with a # character for each digit. If you want a 2 digit random number use %##. If you want 6 digits, use %######.

## New-RandomFileName
Create a new random file name. The default is a completely random name including the extension.
```
PS C:\> new-randomfilename
fykxecvh.ipw
```
But you can specify an extentions.
```
PS C:\> new-randomfilename -extension dat
emevgq3r.dat
```
Optionally you can create a random file name using the TEMP folder or your HOME folder. On Windows platforms this will default to your Documents folder.
```
PS C:\> new-randomfilename -extension log -UseHomeFolder
C:\Users\Jeff\Documents\kbyw4fda.log
```
On Linux machines it will be the home folder.
```
PS /mnt/c/scripts> new-randomfilename -home -Extension tmp
/home/jhicks/oces0epq.tmp
```
## Write-Detail
This command is designed to be used within your functions and scripts to make it easier to write a detailed message that you can use as verbose output. The assumption is that you are using an advanced function with a Begin, Process and End scriptblocks. You can create a detailed message to indicate what part of the code is being executed. The output will include a full time stamp, although you can shorten it to be only a time string which includes a millisecond value.

```
PS C:\>write-detail "Getting file information" -Prefix Process -NoDate
02:39:18:4874 [PROCESS] Getting file information
```
In a script you might use it like this:
```
Begin {
    Write-Detail "Starting $($myinvocation.mycommand)" -Prefix begin | Write-Verbose
    $tabs = "`t" * $tab
    Write-Detail "Using a tab of $tab" -Prefix BEGIN | Write-Verbose
} #begin
```

## Out-VerboseTee
This command is intended to let you see your verbose output and write the verbose messages to a log file. It will only work if the verbose pipeline is enabled, usually when your command is run with -Verbose. This function is designed to be used within your scripts and functions. You either have to hard code a file name or find some other way to define it in your function or control script. You could pass a value as a parameter or set it as a PSDefaultParameterValue.

This command has an alias of Tee-Verbose.

```
Begin {
    $log = New-RandomFilename -useTemp -extension log
    Write-Detail "Starting $($myinvocation.mycommand)" -Prefix begin | Tee-Verbose $log
    Write-Detail "Logging verbose output to $log" -prefix begin | Tee-Verbose -append
    Write-Detail "Initializing data array" -Prefix begin | Tee-Verbose $log -append
    $data = @()
} #begin
```
When the command is run with -Verbose you will see the verbose output and it will be saved to the specified log file.

## Out-ConditionalColor
This command is designed to take pipeline input and display it in a colorized format,based on a set of conditions. Unlike Write-Host which doesn't write to the pipeline, this command will write to the pipeline. 

You can use a simple hashtable to define a color if the given property matches the hashtable key.

![](./images/occ-1.png)

Or you can specify an ordered hashtable for more complex processing.
![](./images/occ-2.png)

This command doesn't always work depending on the type of object you pipe to it. The problem appears to be related to the formatting system. Development and testing is ongoing.

## Copy-Command
This command will copy a PowerShell command, including parameters and help to a new user-specified command. You can use this to create a "wrapper" function or to easily create a proxy function. The default behavior is to create a copy of the command complete with the original comment-based help block.

## Format-Functions
A set of simple commands to make it easier to format values.
```
PS C:\> format-percent -Value 123.5646MB -total 1GB -Decimal 4
12.0669
PS C:\> format-string "powershell" -Reverse -Case Proper
Llehsrewop
PS C:\>  format-value 1235465676 -Unit kb
1206509
```

## Get-PSLocation
A simple function to get common locations. This can be useful with cross-platform scripting.

![](./images/pslocation-win.png)
![](./images/pslocation-linux.png)

## Get-PowerShellEngine
Use this command to quickly get the path to the PowerShell executable. In Windows you should get a result like this:
```
PS C:\> Get-PowerShellEngine
C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe
```
But PowerShell Core is a bit different:
```
PS /home/jhicks> Get-PowerShellEngine                                                              /opt/microsoft/powershell/6.0.0-rc/pwsh
```
## Out-More
This command provides a PowerShell alternative to the cmd.exe MORE command, which doesn't work in the PowerShell ISE. When you have screens of information, you can page it with this function.
```
get-service | out-more
```
![](./images/out-more.png)
This also works in PowerShell Core.

## Invoke-InputBox
This function is a graphical replacement for Read-Host. It creates a simple WPF form that you can use to get user input. The value of the text box will be written to the pipeline.
```
$name = Invoke-InputBox -Prompt "Enter a user name" -Title "New User Setup"
```
![](./images/ibx-1.png)

You can also capture a secure string.
```
Invoke-Inputbox -Prompt "Enter a password for $Name" -AsSecureString -BackgroundColor red
```
![](./images/ibx-2.png)

This example also demonstrates that you can change form's background color.
This function will not work in PowerShell Core.

## ToDo
Because this module is intended to make scripting easier for you, it adds options to insert ToDo statements into PowerShell files. If you are using the PowerShell ISE or VS Code and import this module, it will add the capability to insert a line like this:
```
# [12/13/2017 16:52:40] TODO: Add parameters
```
In the PowerShell ISE, you will get a new menu under Add-Ons
![](./images/todo-1.png)

You can use the menu or keyboard shortcut which will launch an input box.
![](./images/todo-2.png)

The comment will be inserted at the current cursor location.
In VS Code, access the command palette (Ctrl+Shift+P) and then "PowerShell: Show Additional Commands from PowerShell Modules". Select "Insert ToDo" from the list and you'll get the same input box. Note that this will only work for PowerShell files.

### Compatibility
Where possible these commands have been tested with PowerShell Core, but not every platform. If you encounter problems,have suggestions or other feedback, please post an issue.

*last updated 13 December 2017*
