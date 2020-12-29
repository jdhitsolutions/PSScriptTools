---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version: http://bit.ly/31SFF48
schema: 2.0.0
---

# Optimize-Text

## SYNOPSIS

Clean and optimize text input.

## SYNTAX

### default (Default)

```yaml
Optimize-Text [[-Text] <String[]>] [-Filter <Regex>] [-Ignore <String>]
[-ToUpper] [<CommonParameters>]
```

### object

```yaml
Optimize-Text [[-Text] <String[]>] [-Filter <Regex>][-Ignore <String>]
[-ToUpper]  [-PropertyName <String>]  [<CommonParameters>]
```

## DESCRIPTION

Use this command to clean and optimize content from text files. Sometimes text files have blank lines or the content has trailing spaces. These sorts of issues can cause problems when passing the content to other commands.

This command will strip out any lines that are blank or have nothing by white space, and trim leading and trailing spaces. The optimized text is then written back to the pipeline. Optionally, you can specify a property name. This can be useful when your text file is a list of computer names and you want to take advantage of pipeline binding. See examples.

If your text file has commented lines, use the ignore parameter. As long as the character is the first non-whitespace character in the line, the line will be treated as a comment and ignored.

Finally, you can use the -Filter parameter to specify a regular expression pattern to further filter what text is written to the pipeline. The filter is applied after leading and trailing spaces have been removed and before any text is converted to upper case.

## EXAMPLES

### EXAMPLE 1

```powershell
PS C:\> Get-Content c:\scripts\computers.txt

win10-ent-01
srv1
 srv2
dc01

app02



PS C:\> Get-Content c:\scripts\computers.txt | Optimize-Text
win10-ent-01
srv1
quark
dc01
app02
```

The first example shows a malformed text file. In the second command, it has been optimized or normalized.

### EXAMPLE 2

```powershell
PS C:\> Get-Content c:\scripts\computers.txt |
Optimize-Text -property computername

computername
------------
win10-ent-01
srv1
quark
dc01
app02
```

Using the same text file, the command creates a custom object using the Computername property.

### EXAMPLE 3

```powershell
PS C:\> Get-Content computers.txt | Optimize-Text -prop computername |
Where-Object {Test-Connection $_.computername -count 1 -ea silentlycontinue} |
Get-Service bits | Select-Object Name,Status,Machinename

Name                          Status MachineName
----                          ------ -----------
bits                          Running win10-ent-01
bits                          Running dc01
bits                          Running app02
```

Optimize the computer names in computers.txt and add a Computername property. Test each computer, ignoring those that fail, and get the Bits service on the ones that can be pinged.

### EXAMPLE 4

```powershell
PS C:\> Get-Content .\ChicagoServers.txt |
Optimize-Text -Ignore "#" -Property ComputerName

ComputerName
------------
chi-fp01
chi-fp02
chi-core01
chi-test
chi-dc01
chi-dc02
chi-dc04
chi-db01
```

Optimize the text file ignoring any lines that start with the # character.

### EXAMPLE 5

```powershell
PS C:\> Get-Content .\ChicagoServers.txt |
Optimize-Text -filter "dc\d{2}" -ToUpper -PropertyName Computername |
Test-Connection -count 1

Source        Destination     IPV4Address      IPV6Address    Bytes    Time(ms)
------        -----------     -----------      -----------    -----    --------
win10-ENT-01  CHI-DC01        172.16.30.200                   32       0
win10-ENT-01  CHI-DC02        172.16.30.201                   32       0
win10-ENT-01  CHI-DC04        172.16.30.203                   32       0
```

Get names from a text file that match the pattern, turn into an object with a property name, and pipe to Test-Connection.

## PARAMETERS

### -Text

The text to be optimized. Typically read in from a file.

```yaml
Type: String[]
Parameter Sets: default
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

```yaml
Type: String[]
Parameter Sets: object
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Filter

Use a regular expression pattern to filter. The filtering is applied after leading and trailing spaces have been trimmed and before text can be converted to upper case.

```yaml
Type: Regex
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PropertyName

Assign each line of text a property name. This has the effect of turning your text file into an array of objects with a single property.

```yaml
Type: String
Parameter Sets: object
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Ignore

Specify a character that will be interpreted as a comment character. It must be the first-word character in a line.
These lines will be ignored. This parameter has an alias of 'comment'.

```yaml
Type: String
Parameter Sets: (All)
Aliases: comment

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ToUpper

Write text output as upper case.

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

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

## OUTPUTS

### System.String

### System.Management.Automation.PSObject

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

This function was originally described at http://jdhitsolutions.com/blog/2014/09/using-optimized-text-files-in-powershell

## RELATED LINKS

[Get-Content]()
