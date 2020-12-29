---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version: http://bit.ly/314L8W9
schema: 2.0.0
---

# Convert-EventLogRecord

## SYNOPSIS

Convert EventLogRecords to structured objects.

## SYNTAX

```yaml
Convert-EventLogRecord [-LogRecord] <EventLogRecord[]> [<CommonParameters>]
```

## DESCRIPTION

When you use Get-WinEvent, the results are objects you can work with in PowerShell. However, often times there is additional information that is part of the eventlog record, such as replacement strings, that are used to construct a message. This additional information is not readily exposed.
You can use this command to convert the results of a Get-WinEvent command into a PowerShell custom object with additional information. For best results, you should pipe the same event IDs to this command.

Note that not every event record exposes data that is compatible with this command. For those types of event log records, you will see a RawProperties property with most likely an array of strings.
Use the Message property for more information.

## EXAMPLES

### EXAMPLE 1

```powershell
PS C:\> Get-WinEvent -FilterHashtable @{Logname = 'security';ID=5059} |
Convert-EventLogRecord | Select-Object -Property TimeCreated,Subject*,
Computername

TimeCreated       : 1/20/2020 10:48:45 AM
SubjectUserSid    : S-1-5-83-1-2951761591-1086169693-630393256-923523501
SubjectUserName   : AFF04EB7-A25D-40BD-A809-9325ADD90B37
SubjectDomainName : NT VIRTUAL MACHINE
SubjectLogonId    : 0x7cbf5
Computername      : Bovine320

TimeCreated       : 1/20/2020 10:48:45 AM
SubjectUserSid    : S-1-5-83-1-2951761591-1086169693-630393256-923523501
SubjectUserName   : AFF04EB7-A25D-40BD-A809-9325ADD90B37
SubjectDomainName : NT VIRTUAL MACHINE
SubjectLogonId    : 0x7cbf5
Computername      : Bovine320
```

### EXAMPLE 2

```powershell
PS C:\> Get-WinEvent -FilterHashtable @{Logname = 'security';ID=4624} `
-MaxEvents 100 -computername win10 | Convert-EventLogRecord |
Where-Object {$_.LogonType -eq 3} |
Select-Object -first 10 -property TargetUsername,IPAddress,
TimeCreated,Computername | Format-Table

TargetUserName  IpAddress                 TimeCreated           Computername
--------------  ---------                 -----------           ------------
ArtD           fe80::ddae:8ade:c3ff:e584 1/20/2020 12:05:12 PM WIN10.Company.Pri
WIN10$         -                         1/20/2020 11:56:52 AM WIN10.Company.Pri
WIN10$         -                         1/20/2020 11:56:52 AM WIN10.Company.Pri
WIN10$          -                        1/20/2020 11:56:52 AM WIN10.Company.Pri
WIN10$          -                        1/20/2020 11:56:51 AM WIN10.Company.Pri
ArtD           192.168.3.10              1/20/2020 11:45:31 AM WIN10.Company.Pri
WIN10$         ::1                       1/20/2020 11:39:52 AM WIN10.Company.Pri
ArtD           192.168.3.10              1/20/2020 11:35:49 AM WIN10.Company.Pri
ArtD           192.168.3.10              1/20/2020 11:34:36 AM WIN10.Company.Pri
ArtD           192.168.3.10              1/20/2020 11:32:06 AM WIN10.Company.Pri
```

This example filters on a property added by this command to only show interactive logons.

### EXAMPLE 3

```powershell
PS C:\> Get-WinEvent -FilterHashtable @{Logname ='system';
ID =7040} -MaxEvent 10 | Convert-EventlogRecord |
Select-Object -Property TimeCreated,@{Name="Service";Expression={$_.param4}},
@{Name="OriginalState";Expression = {$_.param2}},
@{Name="NewState";Expression={$_.param3}},Computername | Format-Table

TimeCreated          Service          OriginalState NewState     Computername
-----------          -------          ------------- --------     ------------
1/20/2020 9:26:08 AM BITS             demand start  auto start   Bovine320
1/20/2020 5:47:17 AM BITS             auto start    demand start Bovine320
1/20/2020 5:45:11 AM BITS             demand start  auto start   Bovine320
1/20/2020 1:44:31 AM BITS             auto start    demand start Bovine320
1/20/2020 1:42:30 AM BITS             demand start  auto start   Bovine320
1/19/2020 8:53:37 PM BITS             auto start    demand start Bovine320
1/17/2020 8:27:10 PM TrustedInstaller demand start  auto start   Bovine320
1/17/2020 8:27:10 PM TrustedInstaller auto start    demand start Bovine320
1/17/2020 8:26:29 PM TrustedInstaller demand start  auto start   Bovine320
1/17/2020 8:26:20 PM TrustedInstaller auto start    demand start Bovine320
```

Once you know the type of data, you can customize the output or build a script around it.

### EXAMPLE 4

```powershell
PS C:\> Get-WinEvent -FilterHashtable @{Logname = "Application";
ID=17137} -MaxEvents 1 | Convert-EventLogRecord

LogName       : Application
RecordType    : Information
TimeCreated   : 1/20/2020 2:31:52 PM
ID            : 17137
RawProperties : {TickleEventDB}
Message       : Starting up database 'TickleEventDB'.
Keywords      : {Classic}
Source        : MSSQL$SQLEXPRESS
Computername  : Bovine320
```

This record doesn't have structured extra data. The replacement strings are stored as text so the command displays the data using the RawProperties property.

### EXAMPLE 5

```powershell
PS C:\> $all = New-PSSession -ComputerName 'win10','srv1','srv2','dom1'
PS C:\> $local = Get-Item Function:\Convert-EventLogRecord
PS C:\> Invoke-Command -ScriptBlock {
 New-item -Path Function: -Name $using:local.name -Value $using:local.ScriptBlock
 } -Session $all
PS C:\> Invoke-Command {
    Get-WinEvent -FilterHashtable @{Logname='security';id=4624} -MaxEvents 10 |
    Convert-EventLogRecord |
    Select-Object -Property Computername,Time*,TargetUser*,
    TargetDomainName,Subject*} -session $all -HideComputerName |
    Select-Object -Property * -ExcludeProperty runspaceID

Computername      : WIN10.Company.Pri
TimeCreated       : 1/20/2020 5:21:17 PM
TargetUserSid     : S-1-5-18
TargetUserName    : SYSTEM
TargetDomainName  : NT AUTHORITY
SubjectUserSid    : S-1-5-18
SubjectUserName   : WIN10$
SubjectDomainName : COMPANY
SubjectLogonId    : 0x3e7

Computername      : WIN10.Company.Pri
TimeCreated       : 1/20/2020 5:18:51 PM
TargetUserSid     : S-1-5-18
TargetUserName    : SYSTEM
TargetDomainName  : NT AUTHORITY
SubjectUserSid    : S-1-5-18
SubjectUserName   : WIN10$
SubjectDomainName : COMPANY
SubjectLogonId    : 0x3e7

Computername      : WIN10.Company.Pri
TimeCreated       : 1/20/2020 5:16:07 PM
TargetUserSid     : S-1-5-21-278538743-3177530655-100218012-1105
TargetUserName    : ArtD
TargetDomainName  : COMPANY.PRI
SubjectUserSid    : S-1-0-0
SubjectUserName   : -
SubjectDomainName : -
SubjectLogonId    : 0x0
...
```

The first command creates PSSessions to several remote computers. The local copy of this command is created in the remote PSSessions. Then event log data is retrieved in the remote sessions and converted using the Convert-EventlogRecord function in each session.

## PARAMETERS

### -LogRecord

An event log record from the Get-WinEvent command.

```yaml
Type: EventLogRecord[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Diagnostics.Eventing.Reader.EventLogRecord

## OUTPUTS

### PSCustomObject

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Get-WinEvent]()
