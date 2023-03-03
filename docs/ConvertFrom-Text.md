---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version: http://bit.ly/31VAujZ
schema: 2.0.0
---

# ConvertFrom-Text

## SYNOPSIS

Convert structured text to objects.

## SYNTAX

### File (Default)

```yaml
ConvertFrom-Text [-Pattern] <Regex> [-Path] <String> [-TypeName <String>]
[-NoProgress] [<CommonParameters>]
```

### InputObject

```yaml
ConvertFrom-Text [-Pattern] <Regex> [-InputObject] <String>
[-TypeName <String>] [-NoProgress] [<CommonParameters>]
```

## DESCRIPTION

This command will take structured text such as from a log file and convert it to objects that you can use in the PowerShell pipeline. You can specify the path to a text file, or pipe content directly into this command. The piped content could even be output from command-line tools. You have to specify a regular expression pattern that uses named captures. The names will become property names in the custom objects.

The command will write a generic custom object to the pipeline. However, you can specify a custom type name. You might want to do this if you have your own format ps1xml file and want to handle formatting through that file.

## EXAMPLES

### EXAMPLE 1

```powershell
PS C:\> $b = "(?<Date>\d{2}-\d{2}-\d{4}\s\d{2}:\d{2}).*(?<Error>\d+),\s+(?<Step>.*):\s+(?<Action>\w+),\s+(?<Path>(\w+\\)*\w+\.\w+)"
PS C:\> ConvertFrom-Text -pattern $b -Path C:\windows\DtcInstall.log

Date   : 10-18-2020 10:49
Error  : 0
Step   : CMsdtcUpgradePlugin::PostApply
Action : Enter
Path   : com\complus\dtc\dtc\msdtcstp\msdtcplugin.cpp

Date   : 10-18-2020 10:49
Error  : 0
Step   : CMsdtcUpgradePlugin::PostApply
Action : Exit
Path   : com\complus\dtc\dtc\msdtcstp\msdtcplugin.cpp
...
```

The first command creates a variable to hold the regular expression pattern that defines named captures for content in the DtcInstall.log. The second line runs the command using the pattern and the log file.

### EXAMPLE 2

```powershell
PS C:\> $wu = "(?<Date>\d{4}-\d{2}-\d{2})\s+(?<Time>(\d{2}:)+\d{3})\s+(?<PID>\d+)\s+(?<TID>\w+)\s+(?<Component>\w+)\s+(?<Message>.*)"
PS C:\> $out = ConvertFrom-Text -pattern $wu -Path C:\Windows\WindowsUpdate.log -noprogress
PS C:\> $out | Group-Object Component | Sort-Object Count

Count Name                      Group
----- ----                      -----
   20 DtaStor                   {@{Date=2020-01-27; Time=07:19:19:584; PID=1...
   72 Setup                     {@{Date=2020-01-27; Time=07:19:05:868; PID=1...
  148 SLS                       {@{Date=2020-01-27; Time=07:19:05:086; PID=1...
  150 PT                        {@{Date=2020-01-27; Time=07:19:08:946; PID=1...
  209 WuTask                    {@{Date=2020-01-26; Time=20:05:28:483; PID=1...
  256 EP                        {@{Date=2020-01-26; Time=21:21:23:341; PID=1...
  263 Handler                   {@{Date=2020-01-27; Time=07:19:42:878; PID=3...
  837 Report                    {@{Date=2020-01-26; Time=21:21:23:157; PID=1...
  900 IdleTmr                   {@{Date=2020-01-26; Time=21:21:23:338; PID=1...
  903 Service                   {@{Date=2020-01-26; Time=20:05:29:104; PID=1...
  924 Misc                      {@{Date=2020-01-26; Time=21:21:23:033; PID=1...
 1062 DnldMgr                   {@{Date=2020-01-26; Time=21:21:23:159; PID=1...
 2544 AU                        {@{Date=2020-01-26; Time=19:55:27:449; PID=1...
 2839 Agent                     {@{Date=2020-01-26; Time=21:21:23:045; PID=1...

PS C:\> $out |
Where-Object {\[datetime\]$_.date -ge \[datetime\]"2/10/2020" -AND $_.component -eq "AU"} |
Format-Table Date,Time,Message -wrap

Date       Time         Message
----       ----         -------
2020-02-10 05:36:44:183 ###########  AU: Initializing Automatic Updates  ###########
2020-02-10 05:36:44:184 Additional Service {117CAB2D-82B1-4B5A-A08C-4D62DBEE7782} with Approval
                        type {Scheduled} added to AU services list
2020-02-10 05:36:44:184 AIR Mode is disabled
2020-02-10 05:36:44:185 # Approval type: Scheduled (User preference)
2020-02-10 05:36:44:185 # Auto-install minor updates: Yes (User preference)
2020-02-10 05:36:44:185 # ServiceTypeDefault: Service 117CAB2D-82B1-4B5A-A08C-4D62DBEE7782
                        Approval type: (Scheduled)
2020-02-10 05:36:44:185 # Will interact with non-admins (Non-admins are elevated (User preference))
2020-02-10 05:36:44:204 WARNING: Failed to get Wu Exemption info from NLM, assuming not exempt,
                        error = 0x80070490
2020-02-10 05:36:44:213 AU finished delayed initialization
2020-02-10 05:38:01:000 #############
...
```

In this example, the WindowsUpdate log is converted from text to objects using the regular expression pattern. Given the size of the log file this process can take some time to complete so the progress bar is turned off to improve performance.

### EXAMPLE 3

```powershell
PS C:\> Get-Content c:\windows\windowsupdate.log -totalcount 50 |
ConvertFrom-Text $wu
```

This example gets the first 50 lines from the Windows update log and converts that to objects using the pattern from the previous example.

### EXAMPLE 4

```powershell
PS C:\> $c = "(?<Protocol>\w{3})\s+(?<LocalIP>(\d{1,3}\.){3}\d{1,3}):(?<LocalPort>\d+)\s+(?<ForeignIP>.*):(?<ForeignPort>\d+)\s+(?<State>\w+)?"
PS C:\> netstat | select -skip 4 | ConvertFrom-Text $c |
Format-Table -autosize

Protocol LocalIP      LocalPort ForeignIP      ForeignPort State
-------- -------      --------- ---------      ----------- -----
TCP      127.0.0.1    19872     Novo8          50835       ESTABLISHED
TCP      127.0.0.1    50440     Novo8          50441       ESTABLISHED
TCP      127.0.0.1    50441     Novo8          50440       ESTABLISHED
TCP      127.0.0.1    50445     Novo8          50446       ESTABLISHED
TCP      127.0.0.1    50446     Novo8          50445       ESTABLISHED
TCP      127.0.0.1    50835     Novo8          19872       ESTABLISHED
TCP      192.168.6.98 50753     74.125.129.125 5222        ESTABLISHED
```

The first command creates a variable to be used with output from the Netstat command which is used in the second command.

### EXAMPLE 5

```powershell
PS C:\> $arp = "(?<IPAddress>(\d{1,3}\.){3}\d{1,3})\s+(?<MAC>(\w{2}-){5}\w{2})\s+(?<Type>\w+$)"
PS C:\> arp -g -N 172.16.10.22 | Select-Object -skip 3 |
ForEach-Object {$_.Trim()} |
ConvertFrom-Text $arp -noprogress -typename arpData

IPAddress                         MAC                              Type
---------                         ---                              ----
172.16.10.1                       00-13-d3-66-50-4b                dynamic
172.16.10.100                     00-0d-a2-01-07-5d                dynamic
172.16.10.101                     2c-76-8a-3d-11-30                dynamic
172.16.10.121                     00-0e-58-ce-8b-b6                dynamic
172.16.10.122                     1c-ab-a7-99-9a-e4                dynamic
172.16.10.124                     00-1e-2a-d9-cd-b6                dynamic
172.16.10.126                     00-0e-58-8c-13-ac                dynamic
172.16.10.128                     70-11-24-51-84-60                dynamic
...
```

The first command creates a regular expression for the ARP command. The second prompt shows the ARP command being used to select the content, trimming each line, and then converting the output to text using the regular expression named pattern. This example also defines a custom type name for the output.

## PARAMETERS

### -InputObject

Any text that you want to pipe into this command. It can be a certain number of lines from a large text or log file. Or the output of a command line tool. Be sure to filter out blank lines.

```yaml
Type: String
Parameter Sets: InputObject
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -NoProgress

By default this command will display a progress bar to inform the user on the status. For large data sets this can impact performance. Use this parameter to suppress the progress messages.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Path

The filename and path to the text or log file.

```yaml
Type: String
Parameter Sets: File
Aliases: file

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Pattern

A regular expression pattern that uses named captures. This parameter has an aliases of regex and rx.

```yaml
Type: Regex
Parameter Sets: (All)
Aliases: regex, rx

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TypeName

Enter an optional typename for the object output. If you don't use one, the command will write a generic custom object to the pipeline.

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

### System.String

## OUTPUTS

### PSCustomObject

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Get-Content]()

[About_Regular_Expressions]()
