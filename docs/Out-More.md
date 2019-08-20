---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version: http://bit.ly/31OtYvh
schema: 2.0.0
---

# Out-More

## SYNOPSIS

Send "pages" of objects to the pipeline.

## SYNTAX

```yaml
Out-More [-InputObject] <Object[]> [[-Count] <Int32>] [-ClearScreen]
```

## DESCRIPTION

This function is designed to display groups or "pages" of objects to the PowerShell pipeline.
It is modeled after the legacy More.com command line utility. By default the command will write out objects out to the pipeline in groups of 50. You will be prompted after each grouping.

Pressing M or Enter will get the next group.
Pressing A will stop paging and display all of the remaining objects.
Pressing N will display the next object.
Press Q to stop writing anything else to the pipeline.

Note that you may encounter an error message when quitting prematurely, especially on non-Windows platforms. You can ignore these errors.

## EXAMPLES

### EXAMPLE 1

```powershell
PS C:\> get-process | out-more -count 10

Handles  NPM(K)    PM(K)      WS(K) VM(M)   CPU(s)     Id  SI ProcessName
-------  ------    -----      ----- -----   ------     --  -- -----------
    103       9     1448       4220    67     0.02   1632   0 BtwRSupportService
     80       9     3008       8588 ...27    21.00   5192   1 conhost
     40       5      752       2780 ...82     0.00   5248   0 conhost
     53       7      972       3808 ...07     0.02   6876   1 conhost
    482      17     1932       3692    56     0.91    708   0 csrss
    520      30     2488     134628   180    31.67    784   1 csrss
    408      18     6496      12436 ...35     0.56   1684   0 dasHost
    180      14     3348       6748    66     0.50   4688   0 devmonsrv
\[M\]ore \[A\]ll \[N\]ext \[Q\]uit
```

Display processes in groups of 10.

### EXAMPLE 2

```powershell
PS C:\> dir c:\work -file -Recurse | out-more -ClearScreen | tee -Variable work
```

List all files in C:\Work and page them to Out-More using the default count, but after clearing the screen first. The results are then piped to Tee-Object which saves them to a variable.

## PARAMETERS

### -InputObject

```yaml
Type: Object[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Count

The number of objects to group together in a page.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: i

Required: False
Position: 2
Default value: 50
Accept pipeline input: False
Accept wildcard characters: False
```

### -ClearScreen

Clear the screen prior to writing data to the pipeline.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cls

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

### System.Object[]

## OUTPUTS

### System.Object

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

This command was first demonstrated at http://jdhitsolutions.com/blog/powershell/4707/a-better-powershell-more/

## RELATED LINKS

[more]()
