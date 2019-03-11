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

### Default (Default)

```yaml
Write-Detail [[-Message] <String>] [-Prefix <String>] [<CommonParameters>]
```

### Time

```yaml
Write-Detail [[-Message] <String>] [-Prefix <String>] [-Time] [<CommonParameters>]
```

### Date

```yaml
Write-Detail [[-Message] <String>] [-Prefix <String>] [-Date] [<CommonParameters>]
```

## DESCRIPTION

This command is designed to be used within your functions and scripts to make it easier to write a detailed message that you can use as verbose output. The assumption is that you are using an advanced function with a Begin, Process and End scriptblocks. You can create a detailed message to indicate what part of the code is being executed. The output can include a full time stamp, or a time string which includes a millisecond value.

In a script you might use it like this:

Begin {
    Write-Detail "Starting $($MyInvocation.MyCommand)" -Prefix begin -time | Write-Verbose
    $tabs = "`t" * $tab
    Write-Detail "Using a tab of $tab" -Prefix begin -time | Write-Verbose
} #begin

If you don't specify a prefix, it will default to PROCESS.

## EXAMPLES

### EXAMPLE 1

```powershell
PS C:\>write-detail "Getting file information" -Prefix Process
[PROCESS] Getting file information
```

Normally you would use this command in a function, but here is an example from the console so that you can see what to expect.

## PARAMETERS

### -Message

The message to display after the time stamp and prefix.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Prefix

Indicate whether you are in the BEGIN, PROCESS or END script block. Although you can specify any text. It will be displayed in upper case.

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values:

Required: False
Position: Named
Default value: PROCESS
Accept pipeline input: False
Accept wildcard characters: False
```

### -Date

Display a date value like 9/15/2018 11:36:41

```yaml
Type: SwitchParameter
Parameter Sets: Date
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Time

Display a time value with milliseconds like 11:37:01:4029.

```yaml
Type: SwitchParameter
Parameter Sets: Time
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

### None

## OUTPUTS

### System.String

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Write-Verbose]()
