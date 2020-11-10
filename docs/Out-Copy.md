---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version:
schema: 2.0.0
---

# Out-Copy

## SYNOPSIS

Send command output to the pipeline and clipboard.

## SYNTAX

```yaml
Out-Copy [-InputObject] <Object> [-Width <Int32>] [-CommandOnly]
[<CommonParameters>]
```

## DESCRIPTION

This command is intended for writers and those who need to document with PowerShell. You can pipe any command to this function and you will get the regular output in your PowerShell session. Simultaneously, a copy of the output will be sent to the Windows clipboard. The copied output will include a prompt constructed from the current location unless you use the CommandOnly parameter.

NOTE: You can only capture what is written to the Success pipeline. This command will not copy any other streams such as Verbose, Warning, or Error.

## EXAMPLES

### EXAMPLE 1

```powershell
PS C:\> Get-Process | Sort WS -Descending | Select-First 5 | Out-Copy
```

This will execute your expression and write the output to the pipeline.
The output plus the command:

PS C:\\> Get-Process | Sort WS -Descending | Select -first 5

will be copied to the clipboard. This example is using the Select-First function from the PSScriptTools module.

### EXAMPLE 2

```powershell
PS C:\> Get-Childitem *.ps1 | Out-File c:\work\ps.txt | Out-Copy
```

Even if your command doesn't write anything to the pipeline, Out-Copy will still capture a prompt and PowerShell expression.

### EXAMPLE 3

```powershell
PS C:\> Get-CimInstance -class win32_logicaldisk -filter "drivetype = 3" |
Out-Copy -commandonly
```

This will run the Get-CimInstance command and write results to the pipeline.
But the only text that will be copied to the clipboard is:

Get-CimInstance -class win32_logicaldisk -filter "drivetype = 3"

## PARAMETERS

### -InputObject

This is the piped in command.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Width

Specifies the number of characters in each line of output.
Any additional characters are truncated, not wrapped.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 80
Accept pipeline input: False
Accept wildcard characters: False
```

### -CommandOnly

Only copy the executed command, without references to Out-Copy, to the Windows clipboard.

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

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### [object[]]

## OUTPUTS

### [object[]]

## NOTES

Learn more about PowerShell:http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Out-String]()

[Set-Clipboard]()

[Tee-Object]()
