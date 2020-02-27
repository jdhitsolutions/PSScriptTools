---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version: http://bit.ly/31TyFnk
schema: 2.0.0
---

# Test-WithCulture

## SYNOPSIS

Test your PowerShell code under a different culture.

## SYNTAX

### scriptblock (Default)

```yaml
Test-WithCulture [-Culture] <CultureInfo> [-Scriptblock] <ScriptBlock> [-ArgumentList <Object[]>]
 [<CommonParameters>]
```

### file

```yaml
Test-WithCulture [-Culture] <CultureInfo> -FilePath <ScriptBlock> [-ArgumentList <Object[]>]
 [<CommonParameters>]
```

## DESCRIPTION

When writing PowerShell commands, sometimes the culture you are running under becomes critical. For example, European countries use a different datetime format than North Americans which might present a problem with your script or command. Unless you have a separate computer running under the foreign culture, it is difficult to test. This command will allow you to test a scriptblock or even a file under a different culture, such as DE-DE for German.

Note that this command is not an absolute test. There may be commands that fail to produce the alternate culture results you expect.

## EXAMPLES

### Example 1

```powershell
PS C:\> Test-WithCulture de-de -Scriptblock {(Get-Date).addDays(90)}
Montag, 14. Oktober 2019 08:59:01
```

### Example2

```powershell
PS C\> Test-WithCulture fr-fr -Scriptblock { Get-winEvent -log system -max 500 | Select-Object -Property TimeCreated,ID,OpCodeDisplayname,Message | Sort-Object -property TimeCreated | Group-Object {$_.timecreated.toshortdatestring()} -noelement }

Count Name
----- ----
  165 10/07/2019
  249 11/07/2019
   17 12/07/2019
   16 13/07/2019
   20 14/07/2019
   26 15/07/2019
    7 16/07/2019
```

## PARAMETERS

### -ArgumentList

Specify an array of positional arguments to pass to the scriptblock for file.

```yaml
Type: Object[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Culture

Enter a new culture like de-de

```yaml
Type: CultureInfo
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FilePath

Enter the path to a PowerShell script file to execute using the specified culture.

```yaml
Type: ScriptBlock
Parameter Sets: file
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Scriptblock

Enter a scriptblock to execute using the specified culture. Be aware that long or complex pipelined expressions might not give you the culture specific results you expect.

```yaml
Type: ScriptBlock
Parameter Sets: scriptblock
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object

## NOTES

Learn more about PowerShell:
http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Get-Culture]()

[Get-UICulture]()
