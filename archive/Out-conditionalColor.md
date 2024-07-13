---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version: http://bit.ly/31SFLZy
schema: 2.0.0
---

# Out-ConditionalColor

## SYNOPSIS

Display colorized pipelined output.

## SYNTAX

### property (Default)

```yaml
Out-ConditionalColor [-PropertyConditions] <Hashtable> -Property <String>
-InputObject <PSObject[]> [<CommonParameters>]
```

### conditions

```yaml
Out-ConditionalColor [-Conditions] <OrderedDictionary>
-InputObject <PSObject[]> [<CommonParameters>]
```

## DESCRIPTION

This command is designed to take pipeline input and display it in a colorized format, based on a set of conditions. Unlike Write-Host which doesn't write to the pipeline, this command will write to the pipeline. You can get colorized data and save the output to a variable at the same time, although you'll need to use the common OutVariable parameter (see examples).

The default behavior is to use a hash table with a property name and color. The color must be one of the standard console colors used with Write-Host.

    $c = @{Stopped='Red';Running='Green'}

You can then pipe an expression to this command, specifying a property name and the hash table. If the property matches the key name, the output for that object will be colored using the corresponding hash table value.

    Get-Service -DisplayName windows* | Out-ConditionalColor $c -property status

Or you can do more complex processing with an ordered hash table constructed using this format:

    [ordered]@{ <comparison scriptblock> = <color>}

The comparison scriptblock can use $PSitem.

    $h=[ordered]@{

      {$psitem.ws -gt 500mb}='red'

      {$psitem.ws -gt 300mb}='yellow'

      {$psitem.ws -gt 200mb}='cyan'
    }

    Get-Process | Out-ConditionalColor $h

When doing a complex comparison you must use an [ordered] hashtable as each key will be processed in order using an If/ElseIf statement.

This command should be the last part of any pipelined expression. If you pipe to anything else, such as Sort-Object, you will lose your color formatting. Do any other sorting or filtering before piping to this command.

This command works best in the PowerShell console. It won't do anything in the PowerShell ISE.

LIMITATIONS

Due to the nature of PowerShell's formatting system, there are some limitations with this command. If the first item in your output matches one of your conditions, any text before it, such as headers, will also be colorized. This command will have no effect if the incoming object does not have a defined format view. This means you can't pipe custom objects or something using Select-Object that only includes selected properties to this command.

NOTE: This command has been marked as deprecated and will be removed in a future release.

## EXAMPLES

### EXAMPLE 1

```powershell
PS C:\> Get-Service -DisplayName windows* |
Out-ConditionalColor -propertyconditions @{Stopped='Red'} -property Status
```

Get all services where the display name starts with windows and display stopped services in red.

### EXAMPLE 2

```powershell
PS C:\> Get-Service -DisplayName windows* |
Out-ConditionalColor @{Stopped='Red'} status -ov winstop
```

Repeat the previous example, but also save the output to the variable winstop. When you look at $Winstop you'll see the services, but they won't be colorized. This example uses the parameters positionally.

### EXAMPLE 3

```powershell
PS C:\> Get-EventLog system -newest 50 |
Out-ConditionalColor @{error='red';warning='yellow'}
Enter a property name: entrytype
```

Get the newest 50 entries from the System event log. Display errors in red and warnings in yellow. If you don't specify a property you will be prompted.

### EXAMPLE 4

```powershell
PS C:\> $c =[ordered]@{
{$psitem.length -ge 1mb}='red';
{$psitem.length -ge 500KB}='yellow';
{$psitem.length -ge 100KB}='cyan'}
```

The first command creates an ordered hashtable based on the Length property.

### EXAMPLE 5

```powershell
PS C:\> dir c:\scripts\*.doc,c:\scripts\*.pdf,c:\scripts\*.xml |
Out-ConditionalColor $c
```

The next command uses it to get certain file types in the scripts folder and display the selected properties in color depending on the file size.

## PARAMETERS

### -Conditions

Use an ordered hashtable for more complex processing. See examples.

```yaml
Type: OrderedDictionary
Parameter Sets: conditions
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -InputObject

The output from a PowerShell expression that you want to colorize.

```yaml
Type: PSObject[]
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Property

When using a simple hash table, specify the property to compare which will be done by using the -eq operator.

```yaml
Type: String
Parameter Sets: property
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PropertyConditions

Use a simple hashtable for basic processing or an ordered hash table for complex.

```yaml
Type: Hashtable
Parameter Sets: property
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Management.Automation.PSObject[]

## OUTPUTS

### System.Object

## NOTES

Learn more about PowerShell:
http://jdhitsolutions.com/blog/essential-powershell-resources/

Originally published at: http://jdhitsolutions.com/blog/powershell/3462/friday-fun-Out-ConditionalColor/

## RELATED LINKS

[About_Hash_Tables]()

[Show-Tree](docs/Show-Tree.md)
