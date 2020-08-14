---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version: http://bit.ly/2Vtk3ew
schema: 2.0.0
---

# Test-EmptyFolder

## SYNOPSIS

Test if a folder is empty of files.

## SYNTAX

```yaml
Test-EmptyFolder [-Path] <String[]> [-Passthru] [<CommonParameters>]
```

## DESCRIPTION

This command will test if a given folder path is empty of all files anywhere in the path.
This includes hidden files.
The command will return True even if there are empty sub-folders.
The default output is True or False but you can use -Passthru to get more information.
See examples.

## EXAMPLES

### Example 1

```powershell
PS C:\> Test-EmptyFolder c:\work
False
```

Test a single folder from a parameter.

### Example 2

```powershell
PS C:\> Get-ChildItem c:\work -Directory | Test-EmptyFolder -passthru


Path          Name  IsEmpty Computername
----          ----  ------- ------------
C:\work\A     A       False DESK10
C:\work\alpha alpha   False DESK10
C:\work\B     B       True  DESK10
C:\work\data  data    False DESK10
C:\work\demo3 demo3    True DESK10
C:\work\demos demos   False DESK10
...
```

Test child folders under C:\work.

### Example 3

```powershell
PS C:\> Get-ChildItem c:\work -Directory | Test-EmptyFolder -passthru |
Where-object {$_.Isempty} |
Foreach-Object { Remove-Item -LiteralPath $_.path -Recurse -force -whatif}

What if: Performing the operation "Remove Directory" on target "C:\work\demo3".
What if: Performing the operation "Remove Directory" on target "C:\work\installers".
What if: Performing the operation "Remove Directory" on target "C:\work\new".
What if: Performing the operation "Remove Directory" on target "C:\work\sqlback".
What if: Performing the operation "Remove Directory" on target "C:\work\todd".
What if: Performing the operation "Remove Directory" on target "C:\work\[data]".
```

Find all empty sub-folders under C:\Work and pipe them to Remove-Item. This is one way to remove empty folders.
The example is piping objects to ForEach-Object so that Remove-Item can use the -LiteralPath parameter, because C:\work\[data] is a non-standard path.

## PARAMETERS

### -Passthru

Write a test object to the pipeline.

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

### -Path

Enter a file system path like C:\Scripts.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: PSPath

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String[]

## OUTPUTS

### Boolean

### EmptyFolder

## NOTES

Learn more about PowerShell:
http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Get-FolderSizeInfo](Get-FolderSizeInfo.md)
