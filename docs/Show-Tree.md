---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version: http://bit.ly/31RilUa
schema: 2.0.0
---

# Show-Tree

## SYNOPSIS

Shows the specified path as a tree.

## SYNTAX

### Path (Default)

```yaml
Show-Tree [[-Path] <String[]>] [[-Depth] <Int32>] [-IndentSize <Int32>]
[-ShowItem] [-ShowProperty <String[]>] [-InColor] [<CommonParameters>]
```

### LiteralPath

```yaml
Show-Tree [[-LiteralPath] <String[]>] [[-Depth] <Int32>] [-IndentSize <Int32>]
[-ShowItem] [-ShowProperty <String[]>] [-InColor] [<CommonParameters>]
```

## DESCRIPTION

Shows the specified path as a graphical tree in the console. Show-Tree is intended as a PowerShell alternative to the tree DOS command. This function should work for any type of PowerShell provider and can be used to explore providers used for configuration like the WSMan provider or the registry. Currently, this will *not work* with any PSDrives created with the Certificate provider. It should work cross-platform.

By default, the output will only show directory or equivalent structures. But you can opt to include items well as item details by using the ShowProperty parameter. Specify a comma-separated list of properties or use * to view them all.

If the Path is a FileSystem path there is a dynamic parameter, -InColor, that will write ANSI-colored output to the pipeline. This parameter has an alias of ansi.

Note: This is an update to an older function in my library. I seem to recall I found the original code somewhere online, perhaps from someone like Lee Holmes. Sadly, I neglected to record the source.

## EXAMPLES

### EXAMPLE 1

```powershell
PS C:\> Show-Tree C:\Work -Depth 2

C:\work
+--A
|  \--B
+--dnssuffix
|  +--docs
|  +--en-us
|  \--images
+--gpo
|  +--{65D9E940-AAD4-4508-A199-86EAE4E9E535}
|  \--{7E7F01CE-6889-44B0-9D03-818F8284EDE0}
+--installers
+--remoteop
|  \--archive
+--test files
\--tryme
   +--.vscode
   +--docs
   +--en-us
   \--test
```

Shows the directory tree structure, recursing down two levels.

### EXAMPLE 2

```powershell
PS C:\>Show-Tree HKLM:\SOFTWARE\Microsoft\.NETFramework -Depth 2 -ShowProp *

HKLM:\SOFTWARE\Microsoft\.NETFramework
+-- Enable64Bit = 1
+-- InstallRoot = C:\Windows\Microsoft.NET\Framework64\
+-- UseRyuJIT = 1
+--Advertised
|  +--Policy
|  \--v2.0.50727
+--AssemblyFolders
|  +--ADOMD.Client 14.0
|  |  \-- (default) = C:\Program Files\Microsoft.NET\ADOMD.NET\140\
|  +--Microsoft .NET Framework 3.5 Reference Assemblies
|  |  \-- (default) = C:\Program Files\Reference Assemblies\Microsoft\Framew...
|  +--SQL Server Assemblies 140
|  |  \-- (default) = C:\Program Files\Microsoft SQL Server\140\SDK\Assemblies\
|  +--v3.0
|  |  +-- <IncludeDotNet2Assemblies> = 1
|  |  \-- All Assemblies In = C:\Program Files\Reference Assemblies\Microsof...
|  \--v3.5
|     +-- <IncludeDotNet2Assemblies> = 1
|     \-- All Assemblies In = C:\Program Files\Reference Assemblies\Microsof...
...
```

Shows the hierarchy of registry keys and values (-ShowProperty), recursing down two levels.

### EXAMPLE 3

```powershell
PS C:\> Show-Tree WSMan: -ShowItem

WSMan:\
\--localhost
   +--MaxEnvelopeSizekb
   +--MaxTimeoutms
   +--MaxBatchItems
   +--MaxProviderRequests
   +--Client
   |  +--NetworkDelayms
   |  +--URLPrefix
   |  +--AllowUnencrypted
   |  +--Auth
   |  |  +--Basic
   |  |  +--Digest
   |  |  +--Kerberos
   |  |  +--Negotiate
...
```

Shows all the containers and items in the WSMan: drive.

### Example 4

```powershell
PS C:\> pstree c:\work\alpha -files -properties LastWriteTime,Length -ansi

C:\work\Alpha\
+-- LastWriteTime = 02/28/2020 11:19:32
+--bravo
|  +-- LastWriteTime = 02/28/2020 11:20:30
|  +--delta
|  |  +-- LastWriteTime = 02/28/2020 11:17:35
|  |  +--FunctionDemo.ps1
|  |  |  +-- Length = 888
|  |  |  \-- LastWriteTime = 06/01/2009 15:50:47
|  |  +--function-form.ps1
|  |  |  +-- Length = 1117
|  |  |  \-- LastWriteTime = 04/17/2019 17:18:28
|  |  +--function-logstamp.ps1
|  |  |  +-- Length = 598
|  |  |  \-- LastWriteTime = 05/23/2007 11:39:55
|  |  +--FunctionNotes.ps1
|  |  |  +-- Length = 617
|  |  |  \-- LastWriteTime = 02/24/2016 08:59:03
|  |  \--Function-SwitchTest.ps1
|  |     +-- Length = 242
|  |     \-- LastWriteTime = 06/09/2008 15:55:44
|  +--gamma
...
```

Show a tree listing with files including a few user-specified properties in color. This example is using parameter and command aliases.

## PARAMETERS

### -Path

The path to the root of the tree that will be shown.

```yaml
Type: String[]
Parameter Sets: Path
Aliases: FullName

Required: False
Position: 1
Default value: current location
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -LiteralPath

Use a literal path value.

```yaml
Type: String[]
Parameter Sets: LiteralPath
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Depth

Specifies how many levels of the specified path are recursed and shown.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: 2147483647
Accept pipeline input: False
Accept wildcard characters: False
```

### -IndentSize

The size of the indent per level. The default is 3. The minimum value is 1. You shouldn't have to modify this parameter.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 3
Accept pipeline input: False
Accept wildcard characters: False
```

### -ShowItem

Shows the items in each container or folder.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: files

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -ShowProperty

Shows the properties on containers and items. Use * to display all properties otherwise specify a comma separated list.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: properties

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -InColor

Show tree and item colorized. Values are from the $PSAnsiMap variable.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: ansi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

## OUTPUTS

### System.String

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[tree.com]()

[Get-ChildItem]()
