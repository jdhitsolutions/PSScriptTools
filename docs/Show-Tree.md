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
Show-Tree [[-Path] <String[]>] [[-Depth] <Int32>] [-IndentSize <Int32>] [-ShowItem] [-ShowProperty]
 [<CommonParameters>]
```

### LiteralPath

```yaml
Show-Tree [[-LiteralPath] <String[]>] [[-Depth] <Int32>] [-IndentSize <Int32>] [-ShowItem] [-ShowProperty]
 [<CommonParameters>]
```

## DESCRIPTION

Shows the specified path as a graphical tree in the console. This is intended as PowerShell alternative to the tree DOS command. This function should work for any type of PowerShell provider and can be used to explore providers used for configuration like the WSMan provider or the registry. Currently, this will not work with any PSDrives created with the Certificate provider.

By default, the output will only show directory or equivalent structures. But you can opt to include items well as item details.

It should work cross-platform. If you are running PowerShell 7, there is a dynamic parameter, -InColor, that will write ANSI-colored output to the pipeline. The color scheme is designed for the file system.

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
PS C:\> Show-Tree HKLM:\SOFTWARE\Microsoft\.NETFramework -Depth 2 -ShowProperty

HKLM:\SOFTWARE\Microsoft\.NETFramework
+--Property: Enable64Bit = 1
+--Property: InstallRoot = C:\Windows\Microsoft.NET\Framework64\
+--Property: UseRyuJIT = 1
+--Property: DbgManagedDebugger = "C:\WINDOWS\system32\vsjitdebugger.exe" PID %d APPDOM %d EXTEXT "%s" EVTHDL %d
+--Property: DbgJITDebugLaunchSetting = 16
+--Advertised
|  +--Policy
|  \--v2.0.50727
+--AssemblyFolders
|  +--ADOMD.Client 14.0
|  |  \--Property: (default) = C:\Program Files\Microsoft.NET\ADOMD.NET\140\
|  +--Microsoft .NET Framework 3.5 Reference Assemblies
|  |  \--Property: (default) = C:\Program Files\Reference Assemblies\Microsoft\Framework\v3.5\
|  +--SQL Server Assemblies 140
|  |  \--Property: (default) = C:\Program Files\Microsoft SQL Server\140\SDK\Assemblies\
|  +--v3.0
|  |  +--Property: <IncludeDotNet2Assemblies> = 1
|  |  \--Property: All Assemblies In = C:\Program Files\Reference Assemblies\Microsoft\Framework\v3.0\
|  \--v3.5
|     +--Property: <IncludeDotNet2Assemblies> = 1
|     \--Property: All Assemblies In = C:\Program Files\Reference Assemblies\Microsoft\Framework\v3.5\
+--NGen
|  \--Policy
+--NGenQueue
|  +--WIN32
|  \--WIN64
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
   |  |  +--Certificate
   |  |  \--CredSSP
   |  +--DefaultPorts
   |  |  +--HTTP
   |  |  \--HTTPS
   |  \--TrustedHosts
   +--Service
   |  +--RootSDDL
   |  +--MaxConcurrentOperations
   |  +--MaxConcurrentOperationsPerUser
   |  +--EnumerationTimeoutms
   ...
```

Shows all the containers and items in the WSMan: drive.

## PARAMETERS

### -Path

The path to the root of the tree that will be shown.

```yaml
Type: String[]
Parameter Sets: Path
Aliases:

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
Aliases: PSPath

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

The size of the indent per level. The default is 3. Minimum value is 1. You shouldn't have to modify this parameter.

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
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -ShowProperty

Shows the properties on containers and items (if -ShowItem is specified).

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
