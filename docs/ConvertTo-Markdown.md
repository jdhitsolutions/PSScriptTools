---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version: http://bit.ly/31Nn21e
schema: 2.0.0
---

# ConvertTo-Markdown

## SYNOPSIS

Convert pipeline output to a markdown document.

## SYNTAX

### text (Default)

```yaml
ConvertTo-Markdown [[-InputObject] <Object>] [-Title <String>]
[-PreContent <String[]>] [-PostContent <String[]>] [-Width <Int32>] [<CommonParameters>]
```

### table

```yaml
ConvertTo-Markdown [[-InputObject] <Object>] [-Title <String>] [-PreContent <String[]>] [-PostContent <String[]>] [-AsTable] [<CommonParameters>]
```

### list

```yaml
ConvertTo-Markdown [[-InputObject] <Object>] [-Title <String>] [-PreContent <String[]>] [-PostContent <String[]>] [-AsList] [<CommonParameters>]
```

## DESCRIPTION

This command is designed to accept pipelined output and create a generic markdown document. The pipeline output will formatted as a text block or you can specify a table. The AsList parameter technically still create a table, but it is two columns with the property name and value.

You can optionally define a title, content to appear before the output, and content to appear after the output. Best efforts have been made to produce markdown output that meets basic standards.

The command does not create a text file. You need to pipe results from this command to a cmdlet like Out-File or Set-Content. See examples.

## EXAMPLES

### EXAMPLE 1

```powershell
PS C:\> Get-Service Bits,Winrm |
ConvertTo-Markdown -title "Service Check" -PreContent "## $($env:computername)"`
-PostContent "_report $(Get-Date)_" | Out-File c:\work\svc.md
```

Create markdown output from a Get-Service command and save the output to a file.

### EXAMPLE 2

````powershell
PS C:\> $computers = "srv1","srv2","srv4"
PS C:\> $Title = "System Report"
PS C:\> $footer = "_report run by $($env:USERDOMAIN)\$($env:USERNAME)_"
PS C:\> $sb =  {
$os = Get-CimInstance -ClassName Win32_OperatingSystem -property caption,
LastBootUpTime
[PSCustomObject]@{
PSVersion = $PSVersionTable.PSVersion
OS = $os.caption
Uptime = (Get-Date) - $os.LastBootUpTime
SizeFreeGB = (Get-Volume -DriveLetter C).SizeRemaining /1GB
 }
}
PS C:\> $out = ConvertTo-Markdown -title $Title
PS C:\> foreach ($computer in $computers) {
$out+= Invoke-command -ScriptBlock $sb -Computer $computer -HideComputerName |
Select-Object -Property * -ExcludeProperty RunspaceID |
ConvertTo-Markdown -PreContent "## $($computer.ToUpper())"
}
PS C:\>$out += ConvertTo-Markdown -PostContent $footer
PS C:\>$out | Set-Content c:\work\report.md
````

Here is an example that creates a series of markdown fragments for each computer and in the end creates a markdown document. The commands are shown at a PowerShell prompt, but you are likely to put them in a PowerShell script file.

### EXAMPLE 3

```powershell
PS C:\> Get-WindowsVersion | ConvertTo-Markdown -title "OS Summary" -PreContent "## $($env:computername)" -AsList

# OS Summary

## THINKX1-JH

| Property | Value |
|----|----|
|ProductName|Microsoft Windows 11 Pro|
|ReleaseVersion|23H2|
|EditionID|Professional|
|ReleaseID|2009|
|Build|22631.2191|
|Branch|ni_release|
|InstalledUTC|5/17/2022 6:54:52 PM|
|Computername|THINKX1-JH|
```

Create a "list" table with output from the Get-WindowsVersion command.

### EXAMPLE 4

```powershell
PS C:\> Get-Service | Sort-Object -property DisplayName |
Foreach-Object -begin {
    "# Service Status`n"
} -process {
    $name = $_.DisplayName
    $_ | Select-Object -property Name,StartType,Status,
    @{Name="RequiredServices";Expression = {$_.RequiredServices.name -join ','}} |
    ConvertTo-Markdown -asList -PreContent "## $Name"
} -end {
    "### $($env:computername) $(Get-Date)"
} | Out-File c:\work\services.md
```

The example will create a markdown file with a title of Service Status. Each service will be converted to a markdown list with the DisplayName as pre-content.

## PARAMETERS

### -InputObject

Typically the results of a PowerShell command or expression.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Title

Specify a top-level title. You do not need to include any markdown. It will automatically be formatted with a H1 tag.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PreContent

Enter whatever content you want to appear before converted input. You can use whatever markdown you wish.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PostContent

Enter whatever content you want to appear after converted input. You can use whatever markdown you wish.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Width

Specify the document width. Depending on what you intend to do with the markdown from this command you may want to adjust this value.

```yaml
Type: Int32
Parameter Sets: text
Aliases:

Required: False
Position: Named
Default value: 80
Accept pipeline input: False
Accept wildcard characters: False
```

### -AsTable

Format the incoming data as a markdown table.
This works best with similar content such as the result of running a PowerShell command.

```yaml
Type: SwitchParameter
Parameter Sets: table
Aliases: table

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AsList

Display results as a 2 column markdown table. The first column will be the property name with the value formatted as a string in the second column.

```yaml
Type: SwitchParameter
Parameter Sets: list
Aliases: list

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Object

## OUTPUTS

### System.String

## NOTES

Learn more about PowerShell: https://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[ConvertTo-HTML]()

[Out-File]()
