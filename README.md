# ![toolbox](./images/toolbox-thumbnail.png) PSScriptTools

This PowerShell module contains a number of functions you might use to enhance your own functions and scripts. The [Samples](./samples) folder contains demonstration script files.

## Current Release

The current release is [PSScriptTools-v1.5.1](https://github.com/jdhitsolutions/PSScriptTools/archive/v1.5.1.zip)

You can also install this from the PowerShell Gallery:

```powershell
Install-Module PSScriptTools
```

or in PowerShell Core:

```powershell
Install-Module PSScriptTools -scope currentuser
```

Please post any questions, problems or feedback in Issues. Any input is greatly appreciated.

## Add-Border

This command will create a character or text based border around a line of text. You might use this to create a formatted text report or to improve the display of information to the screen.

```powershell
PS C:\> add-border $env:computername

*************
*   COWPC   *
*************
```

## Get-PSWho

This command will provide a summary of relevant information for the current user in a PowerShell Session. You might use this to troubleshoot an end-user problem running a script or command.

```powershell
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

```powershell
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

```powershell
PS C:\> new-randomfilename
fykxecvh.ipw
```

But you can specify an extension.

```powershell
PS C:\> new-randomfilename -extension dat
emevgq3r.dat
```

Optionally you can create a random file name using the TEMP folder or your HOME folder. On Windows platforms this will default to your Documents folder.

```powershell
PS C:\> new-randomfilename -extension log -UseHomeFolder
C:\Users\Jeff\Documents\kbyw4fda.log
```

On Linux machines it will be the home folder.

```powershell
PS /mnt/c/scripts> new-randomfilename -home -Extension tmp
/home/jhicks/oces0epq.tmp
```

## Write-Detail

This command is designed to be used within your functions and scripts to make it easier to write a detailed message that you can use as verbose output. The assumption is that you are using an advanced function with a Begin, Process and End scriptblocks. You can create a detailed message to indicate what part of the code is being executed. The output can be configured to include a datetime stamp or just the time.

```powershell
PS C:\> write-detail "Getting file information" -Prefix Process -Date
9/15/2018 11:42:43 [PROCESS] Getting file information
```

In a script you might use it like this:

```powershell
Begin {
    Write-Detail "Starting $($myinvocation.mycommand)" -Prefix begin -time | Write-Verbose
    $tabs = "`t" * $tab
    Write-Detail "Using a tab of $tab" -Prefix BEGIN -time | Write-Verbose
} #begin
```

## Out-VerboseTee

This command is intended to let you see your verbose output and write the verbose messages to a log file. It will only work if the verbose pipeline is enabled, usually when your command is run with -Verbose. This function is designed to be used within your scripts and functions. You either have to hard code a file name or find some other way to define it in your function or control script. You could pass a value as a parameter or set it as a PSDefaultParameterValue.

This command has an alias of `Tee-Verbose`.

```powershell
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

```powershell
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

```powershell
PS C:\> Get-PowerShellEngine
C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe
```

But PowerShell Core is a bit different:

```powershell
PS /home/jhicks> Get-PowerShellEngine 
/opt/microsoft/powershell/6/pwsh
```

You can also get detailed information.
![Windows PowerShell](./images/get-powershellengine1.png)

![PowerShell Core on Windows](./images/get-powershellengine2.png)

![PowerShell Core on Linux](./images/get-powershellengine3.png)

Results will vary depending on whether you are running Windows PowerShell or PowerShell Core.

## Out-More

This command provides a PowerShell alternative to the cmd.exe MORE command, which doesn't work in the PowerShell ISE. When you have screens of information, you can page it with this function.

```powershell
get-service | out-more
```

![](./images/out-more.png)

This also works in PowerShell Core.

## Invoke-InputBox

This function is a graphical replacement for Read-Host. It creates a simple WPF form that you can use to get user input. The value of the text box will be written to the pipeline.

```powershell
$name = Invoke-InputBox -Prompt "Enter a user name" -Title "New User Setup"
```

![](./images/ibx-1.png)

You can also capture a secure string.

```powershell
Invoke-Inputbox -Prompt "Enter a password for $Name" -AsSecureString -BackgroundColor red
```

![](./images/ibx-2.png)

This example also demonstrates that you can change form's background color.
This function will **not** work in PowerShell Core.

## ToDo

Because this module is intended to make scripting easier for you, it adds options to insert ToDo statements into PowerShell files. If you are using the PowerShell ISE or VS Code and import this module, it will add the capability to insert a line like this:

```yaml
# [12/13/2017 16:52:40] TODO: Add parameters
```

In the PowerShell ISE, you will get a new menu under Add-Ons

![](./images/todo-1.png)

You can use the menu or keyboard shortcut which will launch an input box.

![](./images/todo-2.png)

The comment will be inserted at the current cursor location.

In VS Code, access the command palette (Ctrl+Shift+P) and then "PowerShell: Show Additional Commands from PowerShell Modules". Select "Insert ToDo" from the list and you'll get the same input box. Note that this will only work for PowerShell files.

## Test-Expression

The primary command can be used to test a PowerShell expression or scriptblock for a specified number of times and calculate the average runtime, in milliseconds, over all the tests.

### Why?

When you run a single test with `Measure-Command` the result might be affected by any number of factors. Likewise, running multiple tests may also be influenced by things such as caching. The goal in this module is to provide a test framework where you can run a test repeatedly with either a static or random interval between each test. The results are aggregated and analyzed. Hopefully, this will provide a more meaningful or realistic result.

### Examples

The output will also show the median and trimmed values as well as some metadata about the current PowerShell session.

```powershell
PS C:\> $cred = Get-credential globomantics\administrator
PS C:\> Test-Expression {param($cred) get-wmiobject win32_logicaldisk -computer chi-dc01 -credential $cred } -argumentList $cred

Tests        : 1
TestInterval : 0.5
AverageMS    : 1990.6779
MinimumMS    : 1990.6779
MaximumMS    : 1990.6779
MedianMS     : 1990.6779
TrimmedMS    : 
PSVersion    : 5.1.14409.1005
OS           : Microsoft Windows 8.1 Enterprise
``` 

You can also run multiple tests with random time intervals.

```powershell
PS C:\>Test-expression {param([string[]]$Names) get-service $names} -count 5 -IncludeExpression -argumentlist @('bits','wuauserv','winrm') -RandomMinimum .5 -RandomMaximum 5.5

Tests        : 5
TestInterval : Random
AverageMS    : 1.91406
MinimumMS    : 0.4657
MaximumMS    : 7.5746
MedianMS     : 0.4806
TrimmedMS    : 0.51
PSVersion    : 5.1.14409.1005
OS           : Microsoft Windows 8.1 Enterprise
Expression   : param([string[]]$Names) get-service $names
Arguments    : {bits, wuauserv, winrm}
```

For very long running tests, you can run them as a background job.

### Graphical Testing

The module also includes a graphical command called `Test-ExpressionForm`. This is intended to serve as both an entry and results form.

![Test Expression](images/testexpressionform.png)

When you quit the form the last result will be written to the pipeline including all metadata, the scriptblock and any arguments.

## Find-CimClass

This function is designed to search an entire CIM repository for a class name. Sometimes, you may have a guess about a class name but not know the full name or even the correct namespace. `Find-CimClass` will recursively search for a given classname. You can use wildcards and search remote computers.

![find-cimclass](images/find-cimclass.png)

## ConvertTo-Markdown

This command is designed to accept pipelined output and create a markdown document. The pipeline output will formatted as a text block. You can optionally define a title, content to appear before the output and content to appear after the output. You can run a command like this:

```powershell
 Get-Service Bits,Winrm | Convertto-Markdown -title "Service Check" -precontent "## $($env:computername)"  -postcontent "_report $(Get-Date)_"
 ```

which generates this markdown:

    # Service Check

    ## BOVINE320

    ```text

    Status   Name               DisplayName
    ------   ----               -----------
    Running  Bits               Background Intelligent Transfer Ser...
    Running  Winrm              Windows Remote Management (WS-Manag...
    ```

    _report 09/25/2018 09:57:12_

Because the function writes markdown to the pipeline you will need to pipe it to a command `Out-File` to create a file.

## ConvertTo-WPFGrid

This command is an alternative to `Out-Gridview`. It works much the same way. Run a PowerShell command and pipe it to this command. The output will be displayed in a data grid. You can click on column headings to sort. You can resize columns and you can re-order columns.

```powershell
get-eventlog -list -ComputerName DOM1,SRV1,SRV2 |
Select Machinename,Log,MaximumKilobytes,Overflowaction,
@{Name="RetentionDays";Expression={$_.MinimumRetentionDays}},
@{Name="Entries";Expression = {$_.entries.count}} | 
ConvertTo-WPFGrid -Title "Event Log Report"
```

![wpfgrid](images/wpfgrid.png)

## Convert-CommandtoHashtable

This command is intended to convert a long PowerShell expression with named parameters into a splatting
alternative.

```powershell
PS C:\> Convert-CommandtoHashtable -Text "get-eventlog -listlog -computername a,b,c,d -erroraction stop"

$paramHash = @{
  listlog = $True
   computername = "a","b","c","d"
   erroraction = "stop"
}

Get-EventLog @paramHash
```

## Convert-HashtableString

This function is similar to Import-PowerShellDataFile. But where that command can only process a file, this command 
will take any hashtable-formatted string and convert it into an actual hashtable.

```powershell
PS C:\> get-content c:\work\test.psd1 | unprotect-cmsmessage | Convert-HashtableString

Name                           Value
----                           -----
CreatedBy                      BOVINE320\Jeff
CreatedAt                      10/02/2018 21:28:47 UTC
Computername                   Think51
Error
Completed                      True
Date                           10/02/2018 21:29:35 UTC
Scriptblock                    restart-service spooler -force
CreatedOn                      BOVINE320
```

The test.psd1 file is protected as a CMS Message. In this example, the contents are decoded as a string which is then in turn converted into an actual hashtable.

## Convert-HashTableToCode

Use this command to convert a hashtable into its text or string equivalent.

```powershell
PS C:\> $h = @{Name="SRV1";Asset=123454;Location="Omaha"}
PS C:\> convert-hashtabletocode $h
@{
        Name = 'SRV1'
        Asset = 123454
        Location = 'Omaha'
}
```

Convert a hashtable object to a string equivalent that you can copy into your script.

## ConvertTo-HashTable

This command will take an object and create a hashtable based on its properties. You can have the hashtable exclude some properties as well as properties that have no value.

```powershell
PS C:\> get-process -id $pid | select name,id,handles,workingset | ConvertTo-HashTable

Name                           Value
----                           -----
WorkingSet                     418377728
Name                           powershell_ise
Id                             3456
Handles                        958
```

## Join-Hashtable

This command will combine two hashtables into a single hashtable.Join-Hashtable will test for duplicate keys. If any of the keys from the first, or primary hashtable are found in the secondary hashtable, you will be prompted for which to keep. Or you can use -Force which will always keep the conflicting key from the first hashtable.

```powershell
PS C:\> $a=@{Name="Jeff";Count=3;Color="Green"}
PS C:\> $b=@{Computer="HAL";Enabled=$True;Year=2020;Color="Red"}
PS C:\> join-hashtable $a $b
Duplicate key Color
A Green
B Red
Which key do you want to KEEP \[AB\]?: A

Name                           Value
----                           -----
Year                           2020
Name                           Jeff
Enabled                        True
Color                          Green
Computer                       HAL
Count                          3
```

## Select Functions

The module contains 2 functions which simplify the use of `Select-Object`. The commands are intended to make it easier to select the first or last X number of objects. The commands include features so that you can sort the incoming objects on a given property first.

```powershell
PS C:\> get-process | select-first 5 -Property WS -Descending

Handles  NPM(K)    PM(K)      WS(K)     CPU(s)     Id  SI ProcessName
-------  ------    -----      -----     ------     --  -- -----------
    696      89   615944     426852     391.97   7352   0 sqlservr
    541      78   262532     274576     278.41   6208   8 Code
   1015      70   227824     269504     137.39  16484   8 powershell_ise
   1578     111   204852     254640      98.58  21332   8 firefox
    884      44   221872     245712     249.23  12456   8 googledrivesync
```

## New-PSDriveHere

This function will create a new PSDrive at the specified location. The default is the current location, but you
can specify any PSPath. The function will take the last word of the path and use it as the name of the new
PSDrive.

```powershell
PS C:\users\jeff\documents\Enterprise Mgmt Webinar> new-psdrivehere

Name           Used (GB)     Free (GB) Provider      Root                                 CurrentLocation
----           ---------     --------- --------      ----                                 ---------------
Webinar                         146.57 FileSystem    C:\users\jeff\Documents\Enter...
```

## Get-MyVariable

This function will return all variables not defined by PowerShell or by this function itself. The default is to
return all user-created variables from the global scope but you can also specify a scope such as script, local or
a number 0 through 5.

```powershell
PS C:\> Get-MyVariable

NName Value                  Type
---- -----                  ----
a    bits                   ServiceController
dt   10/22/2018 10:49:38 AM DateTime
foo  123                    Int32
r    {1, 2, 3, 4...}        Object[]
...
```

Depending on the value and how PowerShell chooses to display it, you may not see the type.

## Compatibility

Where possible these commands have been tested with PowerShell Core, but not every platform. If you encounter problems,have suggestions or other feedback, please post an issue.

*last updated 22 October 2018*
