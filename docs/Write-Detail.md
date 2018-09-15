---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version: 
schema: 2.0.0
---

# Write-Detail

## SYNOPSIS

Write a detailed message string.

## SYNTAX

```yaml
Write-Detail [-Message] <String> [-Prefix <String>] [-NoDate] [<CommonParameters>]
```

## DESCRIPTION

This command is designed to be used within your functions and scripts to make it easier to write a detailed message that you can use as verbose output. The assumption is that you are using an advanced function with a Begin, Process and End scriptblocks. You can create a detailed message to indicate what part of the code is being executed. The output will include a full time stamp, although you can shorten it to be only a time string which includes a millisecond value.

In a script you might use it like this:

    Begin {
        Write-Detail "Starting $($myinvocation.mycommand)" -Prefix begin | Write-Verbose
        $tabs = "`t" * $tab
        Write-Detail "Using a tab of $tab" -Prefix begin | Write-Verbose
    } #begin

If you don't specify a prefix, it will default to PROCESS.

## EXAMPLES

### EXAMPLE 1

```powershell
PS C:\>write-detail "Getting file information" -Prefix Process -NoDate
02:39:18:4874 [PROCESS] Getting file information
```

Normally you would use this command in a function, but here is an example from the console so that you can see what to expect.

## PARAMETERS

### -Message

The message to display after the time stamp and prefix.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NoDate

Don't display the full date, only the time.

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

### -Prefix

Indicate whether you are in the BEGIN, PROCESS or END script block.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 
Accepted values: BEGIN, PROCESS, END

Required: False
Position: Named
Default value: PROCESS
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.String

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Write-Verbose]()
