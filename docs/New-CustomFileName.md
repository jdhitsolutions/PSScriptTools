---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version: 
schema: 2.0.0
---

# New-CustomFileName

## SYNOPSIS
Create a custom file name based on a template.

## SYNTAX

```
New-CustomFileName [[-Template] <String>] [-Case <String>]
```

## DESCRIPTION
This command will generate a custom file name based on a template string that you provide. You can create a template string using any of these variables. Most of these should be self-explanatory

- %username     
- %computername 
- %year  - 4 digit year        
- %yr  - 2 digit year         
- %monthname - The abbreviated month name   
- %month  - The month number      
- %dayofweek - The full name of the week day   
- %day          
- %hour         
- %minute       
- %time  - A compact string of HourMinuteSecond       
- %string - A random string       
- %guid       

You can also insert a random number using %### with a # character for each digit. If you want a 2 digit random number use %##. If you want 6 digits, use %######.

The command will attempt to preserve case for any non pattern string, but you should separate it from other placeholder patterns with one of these characters: - ( ) [ ] or a . Using an underscore will not work.

    New-CustomFilename "%Year_LOG-%computername.txt"
    2017_log-Bovine320.txt

    New-CustomFilename "%Year-LOG-%computername.txt"
    2017-LOG-Bovine320.txt

Another option, is to turn the entire name into upper or lower case.

    New-CustomFilename "%Year%Monthname-LOG-%computername[%username].txt" -case lower
    2017nov-log-bovine320[jeff].txt

This command does not create the file, it only generates a name for you to use.

## EXAMPLES

### Example 1
```
PS C:\> New-CustomFileName %computername_%day%monthname%yr-%time.log
COWPC_28Nov17-142138.log

```

### Example 2
```
PS C:\> New-CustomFileName %dayofweek-%####.dat
Tuesday-3128.dat
```

Create a custom file name using the day of the week and a 4 digit random number.

### Example 3
```
PS C:\> New-CustomFileName %username-%string.tmp -Case Upper
JEFF-Z0XUXMFS.TMP
```

Create an upper case custom file name. The %string placeholder will be replaced with a random 8 character string.
## PARAMETERS

### -Case
Some values like username or computername might be in different case than what you want. You can use the default value, or return a value that is all upper or lower case.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 
Accepted values: Lower, Upper, Default

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Template
A string that defines the naming pattern based on a set of placeholders.

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

## INPUTS

### None

## OUTPUTS

### System.String

## NOTES
Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS
[New-RandomFileName]()
