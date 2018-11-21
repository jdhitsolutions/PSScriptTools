---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version: 
schema: 2.0.0
---

# ConvertTo-WPFGrid

## SYNOPSIS

Send command output to an interactive WPF-based grid.

## SYNTAX

```powershell
ConvertTo-WPFGrid [[-InputObject] <PSObject>] [[-Title] <String>] [[-Timeout] <Int32>] [[-Width] <Int32>]
 [[-Height] <Int32>] [-CenterScreen] [<CommonParameters>]
```

## DESCRIPTION

This command is an alternative to Out-Gridview. It works much the same way. Run a PowerShell command and pipe it to this command. The output will be displayed in a data grid. You can click on column headings to sort. You can resize columns and you can re-order columns.

You will want to be selective about which properties you pipe through to this command. See examples.

Unlike Out-Gridview, your PowerShell prompt will be blocked until the WPF-based grid is closed.

## EXAMPLES

### EXAMPLE 1

```powershell
PS C:\ Get-Service -computername Server1 | Select Name,Status,Displayname,StartType,Machinename | ConvertTo-WPFGrid -centerscreen
```

Get all services from Server1 and display selected properties in a grid which will be centered on the screen.

### EXAMPLE 2

```powershell
PS C:\> $vmhost = "CHI-HVR2"
PS C:\> Get-VM -computername $VMHost | Select Name,State,Uptime,
@{Name="AssignedMB";Expression={$_.MemoryAssigned/1mb -as \[int\]}},
@{Name="DemandMB";Expression={$_.MemoryDemand/1mb -as \[int\]}} |
ConvertTo-WPFGrid -title "VM Report $VMHost" -Width 500 -height 200 -timeout 20
```

Get Hyper-V virtual machine information and display in a resized grid for 20 seconds.

## PARAMETERS

### -InputObject

Typically the results of a PowerShell command or expression. You should select the specific properties you wish to display.

```yaml
Type: PSObject
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Title

Specify a title for your form.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: ConvertTo-WPFGrid
Accept pipeline input: False
Accept wildcard characters: False
```

### -Timeout

By default the grid will remain displayed until you manually close it. But you can specify a timeout interval in seconds.
The minimum accepted value is 5 seconds. Because the timer ticks in 5 second intervals it is recommended that your time out value also be a multiple of 5.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Width

Specify a width in pixels for your form.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: 1024
Accept pipeline input: False
Accept wildcard characters: False
```

### -Height

Specify a height in pixels for your form.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: 768
Accept pipeline input: False
Accept wildcard characters: False
```

### -CenterScreen

Windows will display the form in the center of your screen.

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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### [PSObject]

## OUTPUTS

### None

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Out-GridView]()

[ConvertTo-HTML]()

[ConvertTo-Markdown](./ConvertTo-Markdown.md)