# PSScriptTools

This PowerShell module contains a number of functions you might use to enhance your own functions and scripts. The [Samples](./samples) folder contains demonstration script files.

## Current Release
The current BETA release is [PSScriptTools-v0.3.0-beta](https://github.com/jdhitsolutions/PSScriptTools/archive/v0.3.0.zip)

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

### Compatibility
Where possible these commands have been tested with PowerShell Core, but not every platform. If you encounter problems, have suggestions or other feedback, please post an issue.

*last updated 29 November 2017*
