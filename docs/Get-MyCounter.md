---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version:
schema: 2.0.0
---

# Get-MyCounter

## SYNOPSIS

Get performance counter data.

## SYNTAX

```yaml
Get-MyCounter [[-Counter] <String[]>] [-SampleInterval <Int32>]
[-MaxSamples <Int64>] [-Continuous] [-ComputerName <String[]>]
[<CommonParameters>]
```

## DESCRIPTION

Get-MyCounter is an enhanced version of Get-Counter which is available on Windows platforms to retrieve performance counter data. One of the challenges with Get-Counter is how it formats results. Get-MyCounter takes the same information and writes a custom object to the pipeline that is easier to work with. You can pipe counters from Get-Counter to this command.

The custom object has an associated formatting file with custom views. See examples.

## EXAMPLES

### Example 1

```powershell
PS C:\> Get-Counter -list "system" | Get-MyCounter

   Computername: SERVER18

Timestamp             Category Counter                           Value
---------             -------- -------                           -----
11/4/2020 10:48:47 AM system   file read operations/sec       203.3096
11/4/2020 10:48:47 AM system   file write operations/sec      252.6566
11/4/2020 10:48:47 AM system   file control operations/sec    197.3879
11/4/2020 10:48:47 AM system   file read bytes/sec         206336.5281
11/4/2020 10:48:47 AM system   file write bytes/sec         56409.5271
11/4/2020 10:48:47 AM system   file control bytes/sec       10452.6787
11/4/2020 10:48:47 AM system   context switches/sec          6068.6924
11/4/2020 10:48:47 AM system   system calls/sec             17854.7266
11/4/2020 10:48:47 AM system   file data operations/sec       455.9662
11/4/2020 10:48:47 AM system   system up time               73056.4005
11/4/2020 10:48:47 AM system   processor queue length                0
11/4/2020 10:48:47 AM system   processes                           301
11/4/2020 10:48:47 AM system   threads                            4502
11/4/2020 10:48:47 AM system   alignment fixups/sec                  0
11/4/2020 10:48:47 AM system   exception dispatches/sec         6.9086
11/4/2020 10:48:47 AM system   floating emulations/sec               0
11/4/2020 10:48:47 AM system   % registry quota in use          4.0327
```

Get all of the System counters with Get-Counter and pipe them to Get-MyCounter.

### Example 2

```powershell
PS C:\> Get-MyCounter -computername server18| Format-table -view category


   Category: network interface(intel[r] ethernet connection [11] i219-lm)

Computername    Timestamp             Counter                          Value
------------    ---------             -------                          -----
SERVER18        11/4/2020 11:20:09 AM bytes total/sec              2662.0477

   Category: network interface(intel[r] wi-fi 6 ax201 160mhz)

Computername    Timestamp             Counter                          Value
------------    ---------             -------                          -----
SERVER18        11/4/2020 11:20:09 AM bytes total/sec                      0

   Category: processor(_total)

Computername    Timestamp             Counter                          Value
------------    ---------             -------                          -----
SERVER18        11/4/2020 11:20:09 AM % processor time                1.4158

   Category: memory

Computername    Timestamp             Counter                          Value
------------    ---------             -------                          -----
SERVER18        11/4/2020 11:20:09 AM % committed bytes in use       40.5214
SERVER18        11/4/2020 11:20:09 AM cache faults/sec                     0

   Category: physicaldisk(_total)

Computername    Timestamp             Counter                          Value
------------    ---------             -------                          -----
SERVER18        11/4/2020 11:20:09 AM % disk time                     0.0217
SERVER18        11/4/2020 11:20:09 AM current disk queue length            0
```

Get the default counter set and pipe to Get-MyCounter to get values for the local host.

### Example 3

```powershell
PS C:\> $c = (Get-Counter -list logicaldisk).PathsWithinstances |
Where-Object {$_ -match "\(c:\)\\%"}
PS C:\> Get-MyCounter -Counter $c -ComputerName SERVER18,SERVER2 |
Format-Table -view category

   Category: logicaldisk(c:)

Computername    Timestamp             Counter                          Value
------------    ---------             -------                          -----
SERVER18        11/4/2020 10:50:03 AM % free space                   48.3822
SERVER2         11/4/2020 10:50:04 AM % free space                   54.5916
SERVER18        11/4/2020 10:50:03 AM % disk time                     1.4669
SERVER2         11/4/2020 10:50:04 AM % disk time                     5.3787
SERVER18        11/4/2020 10:50:03 AM % disk read time                0.8467
SERVER2         11/4/2020 10:50:04 AM % disk read time                     0
SERVER18        11/4/2020 10:50:03 AM % disk write time               0.6203
SERVER2         11/4/2020 10:50:04 AM % disk write time               5.3787
SERVER18        11/4/2020 10:50:03 AM % idle time                    98.5846
SERVER2         11/4/2020 10:50:04 AM % idle time                    93.3567

PS C:\> Get-MyCounter -Counter $c -ComputerName SERVER18,SERVER2 |
Sort-Object Computername

   Computername: SERVER18

Timestamp             Category        Counter             Value
---------             --------        -------             -----
11/4/2020 10:50:35 AM logicaldisk(c:) % free space      48.3822
11/4/2020 10:50:35 AM logicaldisk(c:) % disk time        0.0263
11/4/2020 10:50:35 AM logicaldisk(c:) % disk read time        0
11/4/2020 10:50:35 AM logicaldisk(c:) % disk write time  0.0263
11/4/2020 10:50:35 AM logicaldisk(c:) % idle time       99.9435

   Computername: SERVER2

Timestamp             Category        Counter             Value
---------             --------        -------             -----
11/4/2020 10:50:37 AM logicaldisk(c:) % free space      54.5916
11/4/2020 10:50:37 AM logicaldisk(c:) % disk time             0
11/4/2020 10:50:37 AM logicaldisk(c:) % disk read time        0
11/4/2020 10:50:37 AM logicaldisk(c:) % disk write time       0
11/4/2020 10:50:37 AM logicaldisk(c:) % idle time       99.0114
```

The first command gets a collection of logical disk counters for drive C. The second command gets performance counter data for two remote computers and formats the results using a custom view. The last command repeats the process but sorts the result by the computer name.

### Example 4

```powershell
PS C:\> $p = Get-MyCounter -Counter "\IPv4\Datagrams/sec" -ComputerName SERVER2
-SampleInterval 5 -MaxSamples 30
```

This command will get the specified counter value every 5 seconds for a total of 30 samples.

## PARAMETERS

### -ComputerName

The name of a remote computer. Querying a remote computer does not use PowerShell remoting and requires administrator-level permissions. Typically, the RemoteRegistry service must also be running.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: Cn

Required: False
Position: Named
Default value: localhost
Accept pipeline input: False
Accept wildcard characters: False
```

### -Continuous

Gets samples continuously until you press CTRL+C. By default, Get-MyCounter gets only one counter sample. You can use the SampleInterval parameter to set the interval for continuous sampling.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Counter

Gets data from the specified performance counters. Enter one or more counter paths. Wildcards are permitted only in the Instance value. You can also pipe counter path strings to Get-MyCounter.

 Each counter path has the following format:

"[\\<ComputerName>]\<CounterSet>(<Instance>)\<CounterName>"

For example:

"\\Server01\Processor(2)\% User Time"

The <ComputerName> element is optional. If you omit it, Get-MyCounter uses the value of the ComputerName parameter.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -MaxSamples

Specifies the number of samples to get from each counter. The default is 1 sample. To get samples continuously (no maximum sample size), use the Continuous parameter.

```yaml
Type: Int64
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SampleInterval

Specifies the time between samples in seconds. The minimum value and the default value are 1 second

```yaml
Type: Int32
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

### System.String[]

## OUTPUTS

### myCounter

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Get-Counter]()
