---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version: http://bit.ly/31TxZyi
schema: 2.0.0
---

# ConvertTo-WPFGrid

## SYNOPSIS

Send command output to an interactive WPF-based grid.

## SYNTAX

### input (Default)

```yaml
ConvertTo-WPFGrid [[-Title] <String>] [[-Timeout] <Int32>] [-Refresh]
[-GridLines <String>] [-InitializationScript <ScriptBlock>]
[-UseLocalVariable <String[]>] [-UseProfile] [<CommonParameters>]
```

### Input

```yaml
ConvertTo-WPFGrid [[-InputObject] <PSObject>] [[-Title] <String>]
[[-Timeout] <Int32>] [-Refresh] [-GridLines <String>]
[-InitializationScript <ScriptBlock>] [-UseLocalVariable <String[]>]
[-UseProfile] [<CommonParameters>]
```

### scriptblock

```yaml
ConvertTo-WPFGrid [-Scriptblock <ScriptBlock>] [[-Title] <String>]
[[-Timeout] <Int32>] [-Refresh] [-GridLines <String>]
[-InitializationScript <ScriptBlock>] [-UseLocalVariable <String[]>]
[-UseProfile] [<CommonParameters>]
```

## DESCRIPTION

This command is an alternative to Out-GridView. It works much the same way. Run a PowerShell command and pipe it to this command. The output will be displayed in an auto-sized data grid. You can click on column headings to sort. You can resize columns and you can re-order columns. You will want to be selective about which properties you pipe through to this command. See examples.

You can specify a timeout value which will automatically close the form. If you specify a timeout and the Refresh parameter, then the contents of the datagrid will automatically refreshed using the timeout value as an integer. This will only work when you pipe a PowerShell expression to ConvertTo-WPFGrid as one command. This will fail if you break the command in the PowerShell ISE or use a nested prompt. Beginning with v2.4.0 the form now has a Refresh button which will automatically refresh the datagrid. You should set a refresh interval that is greater than the time it takes to complete the command.

Because the grid is running in a new background runspace, it does not automatically inherit anything from your current session. However, you can use the -UserProfile parameter which will load your user profile scripts into the runspace. You can specify a list of locally defined variables to be used in the form. Use the variable name without the $. Finally, you can also use the -InitializationScript parameter and specify a scriptblock of PowerShell code to initialize the runspace. This is helpful when you need to dot source external scripts or import modules not in your module path.

This command runs the WPF grid in a new runspace so your PowerShell prompt will not be blocked. However, after closing the form you may be left with the runspace. You can use Remove-Runspace to clean up or wait until you restart PowerShell.

This command requires a Windows platform.

## EXAMPLES

### EXAMPLE 1

```powershell
PS C:\> Get-Process | Sort-Object WS -Descending |
Select-object -first 20 ID,Name,WS,VM,PM,Handles,StartTime |
ConvertTo-WPFGrid -Refresh -timeout 20 -Title "Top Processes"
```

Get the top 20 processes based on the value of the WorkingSet property and display selected properties in the WPF Grid. The contents will automatically refresh every 20 seconds. You will need to manually close the form.

### EXAMPLE 2

```powershell
PS C:\> $vmhost = "CHI-HVR2"
PS C:\> Get-VM -computername $VMHost | Select Name,State,Uptime,
@{Name="AssignedMB";Expression={$_.MemoryAssigned/1mb -as [int]}},
@{Name="DemandMB";Expression={$_.MemoryDemand/1mb -as [int]}} |
ConvertTo-WPFGrid -title "VM Report $VMHost" -timeout 30 -refresh
-uselocalvariable VMHost
```

Get Hyper-V virtual machine information and refresh every 30 seconds. Because the command is using a locally defined variable it is also being used in the form. Note that this would be written as one long pipelined expression. It is formatted here for the sake of the help documentation.

### EXAMPLE 3

```powershell
PS C:\> Get-VMData -host CHI-HVR2 |
ConvertTo-WPFGrid -title "VM Data" -refresh -timeout 60 -useprofile
```

This example uses a hypothetical command that might be defined in a PowerShell profile script. ConvertTo-WPFGrid will load the profile scripts so that the data can be updated every 60 seconds.

### EXAMPLE 4

```powershell
PS C:\> (Get-ProcessData -Computername $computers).where({$_.workingset -ge 100mb}) |
ConvertTo-WPFGrid -Title "Process Report" -UseLocalVariable computers -InitializationScript {. C:\scripts\Get-ProcessData.ps1} -Refresh -Timeout 30
```

This command runs a function that is defined in a script file. In order for the form to refresh, it must also dot source the script which is happening with the InitializationScript parameter. The example is also loading the local $computers variable so that it too is available upon refresh.

## PARAMETERS

### -InputObject

Typically the results of a PowerShell command or expression. You should select the specific properties you wish to display.

```yaml
Type: PSObject
Parameter Sets: Input
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

By default, the grid will remain displayed until you manually close it. But you can specify a timeout interval in seconds. The minimum accepted value is 5 seconds. If you use this parameter with -Refresh, then the datagrid will be refreshed with results of the PowerShell expression you piped to ConvertTo-WPFGrid.

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

### -Refresh

If you specify this parameter and a Timeout value, this command will refresh the datagrid with the PowerShell expression piped into ConvertTo-WPFGrid. You should use a value that is longer than the time it takes to complete the command that generates your data.

This parameter will only work if you are using ConvertTo-WPFGrid at the end of a pipelined expression. See examples.

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

### -UseProfile

Load your PowerShell profiles into the background runspace.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: profile

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Scriptblock

Enter a scriptblock that will generate data to be populated in the form

```yaml
Type: ScriptBlock
Parameter Sets: scriptblock
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -UseLocalVariable

Load locally defined variables into the background runspace

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: var

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -InitializationScript

Run this scriptblock to initialize the background runspace. You might need to dot source a script file or load a non-standard module.

```yaml
Type: ScriptBlock
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -GridLines

Control how grid lines are displayed in the form. You may not want to have any or perhaps only vertical or horizontal lines.

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

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Object

## OUTPUTS

### None

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Out-GridView]()

[ConvertTo-HTML]()

[ConvertTo-Markdown](ConvertTo-Markdown.md)
