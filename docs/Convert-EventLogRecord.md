---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version: https://jdhitsolutions.com/yourls/bb432d
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

### Example 1

```powershell
PS C:\> Get-WinEvent -FilterHashtable @{LogName = 'security';ID=5059} |
Convert-EventLogRecord | Select-Object -Property TimeCreated,Subject*,
Computername

TimeCreated       : 3/26/2025 9:03:41 AM
SubjectUserSid    : S-1-5-21-3465062479-264850141-705915528-1001
SubjectUserName   : Jeff
SubjectDomainName : PROSPERO
SubjectLogonId    : 0x34cb5c
Computername      : Prospero

TimeCreated       : 3/26/2025 9:03:41 AM
SubjectUserSid    : S-1-5-21-3465062479-264850141-705915528-1001
SubjectUserName   : Jeff
SubjectDomainName : PROSPERO
SubjectLogonId    : 0x34cb5c
Computername      : Prospero
...
```

### Example 2

```powershell
PS C:\> Get-WinEvent -FilterHashtable @{LogName = 'security';ID=4624} `
-MaxEvents 100 -computername win10 | Convert-EventLogRecord |
Where-Object {$_.LogonType -eq 3} |
Select-Object -first 10 -property TargetUsername,IPAddress,
TimeCreated,Computername | Format-Table

TargetUserName  IpAddress                 TimeCreated           Computername
--------------  ---------                 -----------           ------------
ArtD           fe80::ddae:8ade:c3ff:e584 1/20/2025 12:05:12 PM WIN10.Company.Pri
WIN10$         -                         1/20/2025 11:56:52 AM WIN10.Company.Pri
WIN10$         -                         1/20/2025 11:56:52 AM WIN10.Company.Pri
WIN10$          -                        1/20/2025 11:56:52 AM WIN10.Company.Pri
WIN10$          -                        1/20/2025 11:56:51 AM WIN10.Company.Pri
ArtD           192.168.3.10              1/20/2025 11:45:31 AM WIN10.Company.Pri
WIN10$         ::1                       1/20/2025 11:39:52 AM WIN10.Company.Pri
ArtD           192.168.3.10              1/20/2025 11:35:49 AM WIN10.Company.Pri
ArtD           192.168.3.10              1/20/2025 11:34:36 AM WIN10.Company.Pri
ArtD           192.168.3.10              1/20/2025 11:32:06 AM WIN10.Company.Pri
```

This example filters on a property added by this command to only show interactive logons.

### Example 3

```powershell
PS C:\> Get-WinEvent -FilterHashtable @{LogName ='system';
ID =7040} -MaxEvent 10 | Convert-EventlogRecord |
Select-Object -Property TimeCreated,@{Name="Service";Expression={$_.param4}},
@{Name="OriginalState";Expression = {$_.param2}},
@{Name="NewState";Expression={$_.param3}},Computername | Format-Table

TimeCreated          Service          OriginalState NewState     Computername
-----------          -------          ------------- --------     ------------
3/26/2025 9:03:23 AM BITS             auto start    demand start Prospero
3/26/2025 9:01:20 AM BITS             demand start  auto start   Prospero
3/26/2025 9:00:32 AM TrustedInstaller auto start    demand start Prospero
3/26/2025 8:54:48 AM BITS             auto start    demand start Prospero
3/26/2025 8:51:13 AM BITS             demand start  auto start   Prospero
3/26/2025 8:50:41 AM WslInstaller     auto start    disabled     Prospero
3/26/2025 5:09:35 AM BITS             auto start    demand start Prospero
3/26/2025 5:07:35 AM BITS             demand start  auto start   Prospero
3/26/2025 4:34:26 AM BITS             auto start    demand start Prospero
3/26/2025 4:31:49 AM BITS             demand start  auto start   Prospero
```

Once you know the type of data, you can customize the output or build a script around it.

### Example 4

```powershell
PS C:\> Get-WinEvent -FilterHashtable @{LogName = "Application";
ID=17137} -MaxEvents 1 | Convert-EventLogRecord

LogName       : Application
RecordType    : Information
TimeCreated   : 3/26/2025 9:04:02 AM
RecordID      : 17137
RawProperties : {TickleEventDB}
Message       : Starting up database 'TickleEventDB'.
Keywords      : {Classic}
Source        : MSSQL$SQLEXPRESS
Computername  : Prospero
```

This record doesn't have structured extra data. The replacement strings are stored as text so the command displays the data using the RawProperties property.

### Example 5

```powershell
PS C:\> $all = New-PSSession -ComputerName 'win10','srv1','srv2','dom1'
PS C:\> $local = Get-Item Function:\Convert-EventLogRecord
PS C:\> Invoke-Command -ScriptBlock {
 New-item -Path Function: -Name $using:local.name -Value $using:local.ScriptBlock
 } -Session $all
PS C:\> Invoke-Command {
    Get-WinEvent -FilterHashtable @{LogName='security';id=4624} -MaxEvents 10 |
    Convert-EventLogRecord |
    Select-Object -Property Computername,Time*,TargetUser*,
    TargetDomainName,Subject*} -session $all -HideComputerName |
    Select-Object -Property * -ExcludeProperty runspaceID

Computername      : WIN10.Company.Pri
TimeCreated       : 1/20/2025 5:21:17 PM
TargetUserSid     : S-1-5-18
TargetUserName    : SYSTEM
TargetDomainName  : NT AUTHORITY
SubjectUserSid    : S-1-5-18
SubjectUserName   : WIN10$
SubjectDomainName : COMPANY
SubjectLogonId    : 0x3e7

Computername      : WIN10.Company.Pri
TimeCreated       : 1/20/2025 5:18:51 PM
TargetUserSid     : S-1-5-18
TargetUserName    : SYSTEM
TargetDomainName  : NT AUTHORITY
SubjectUserSid    : S-1-5-18
SubjectUserName   : WIN10$
SubjectDomainName : COMPANY
SubjectLogonId    : 0x3e7

Computername      : WIN10.Company.Pri
TimeCreated       : 1/20/2025 5:16:07 PM
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

Learn more about PowerShell: https://jdhitsolutions.com/yourls/newsletter

## RELATED LINKS

[Get-WinEvent]()
