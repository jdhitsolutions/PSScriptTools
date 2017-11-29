---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version: 
schema: 2.0.0
---

# Out-VerboseTee

## SYNOPSIS
Write to Verbose stream and a file

## SYNTAX

```
Out-VerboseTee -Value <Object> [-Path] <String> [-Encoding <Encoding>] [-Append]
```

## DESCRIPTION
This command is intended to let you see your verbose output and write the verbose messages to a log file. It will only work if the verbose pipeline is enabled, usually when your command is run with -Verbose. This function is designed to be used within your scripts and functions. You either have to hard code a file name or find some other way to define it in your function or control script. You could pass a value as a parameter or set it as a PSDefaultParameterValue.

This command has an alias of Tee-Verbose.

Begin {
    $log = New-RandomFilename -useTemp -extension log
    Write-Detail "Starting $($myinvocation.mycommand)" -Prefix begin | Tee-Verbose $log
    Write-Detail "Logging verbose output to $log" -prefix begin | Tee-Verbose -append
    Write-Detail "Initializing data array" -Prefix begin | Tee-Verbose $log -append
    $data = @()
} #begin

When the command is run with -Verbose you will see the verbose output and it will be saved to the specified log file.

## EXAMPLES

### Example 1
```
PS C:\> $VerbosePreference= "continue"
PS C:\> $log = New-CustomFileName ".\VerboseLog_%time.txt"
PS C:\> Write-Detail "This is a verbose log test" | Out-VerboseTee -path $log
PS C:\> Get-Content $log
11/29/2017 08:21:31:0704 [PROCESS] This is a verbose log test
PS C:\> $verbosePreference = "silentlyContinue"
```

Normally you would use this command inside a function or script, but you can run it from the console if you want to understand how it works.

## PARAMETERS

### -Append
Append to the specified text file.

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

### -Encoding
Specify a file encoding.

```yaml
Type: Encoding
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Path
The path for the output file.

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

### -Value
The message to be displayed as a verbose message and saved to the file.

```yaml
Type: Object
Parameter Sets: (All)
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

## INPUTS

### System.Object

## OUTPUTS

### System.Object

## NOTES
Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS
[Write-Verbose]()

[Write-Detail]()
