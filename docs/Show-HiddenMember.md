---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version: https://jdhitsolutions.com/yourls/2c344b
schema: 2.0.0
---

# Show-HiddenMember

## SYNOPSIS

Show an object's hidden members.

## SYNTAX

```yaml
Show-HiddenMember [-InputObject] <Object> [-MemberType <PSMemberTypes>] 
[-ExcludePropertyMethod] [<CommonParameters>]
```

## DESCRIPTION

By design, PowerShell will hide parts of an object that have very little relevance to scripting or interactive PowerShell use. Often, these are .NET properties and methods that are automatically added. You can see them using Get-Member -Force. This command is designed to simplify the process.

It is expected that you will pipe an object to this command like you do with Get-Member. It is also assumed that if you pipe multiple objects they are all of the same type. Only the first object will be processed.

An earlier version of this command was first introduced at LINK

## EXAMPLES

### Example 1

```powershell
PS C:\> "powershell" | Show-HiddenMember

   Type: System.String

Name                    MemberType
----                    ----------
pstypenames           CodeProperty
psadapted                MemberSet
psbase                   MemberSet
psextended               MemberSet
psobject                 MemberSet
get_Chars                   Method
get_Length                  Method
```

The default behavior is to show all hidden members.

### Example 2

```powershell
PS C:\> Get-Process -id $pid | Show-HiddenMember -ExcludePropertyMethod

   Type: System.Diagnostics.Process

Name                    MemberType
----                    ----------
pstypenames           CodeProperty
psadapted                MemberSet
psbase                   MemberSet
psextended               MemberSet
psobject                 MemberSet
PSStandardMembers        MemberSet
```

Many classes will have intrinsic .NET methods to get and set properties like get_Name. You can exclude these methods from the output.

### Example 3

```powershell
PS C:\> Get-PSWorkItem | Show-HiddenMember -MemberType Property

   Type: PSWorkItem

Name                    MemberType
----                    ----------
TaskID                    Property

PS C:\> Get-PSWorkItem | Select-Object TaskID,Due

TaskID                               Due
------                               ---
4bad9e29-a5a9-4a16-aa9b-f180995e298a 12/31/2025 5:00:00 PM
d8fdba1f-e046-429a-8225-9cbbe927e366 6/18/2026 7:26:08 AM
226022de-4c91-4014-985e-34ee18ce0eda 6/26/2026 6:40:00 AM
...
```

The Get-PSWorkItem command is from the PSWorkItem (https://github.com/jdhitsolutions/PSWorkitem)module. It uses a custom class. Show-HiddenMember reveals a hidden property. Once you know the name, you can use it.

## PARAMETERS

### -ExcludePropertyMethod

Exclude methods like get_Name and set_Name

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

### -InputObject

Pipe an object to this command. It is assumed all the objects are of the same type as only the first object will be processed.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -MemberType

The default is to show all hidden members, but you can filter by specifying a member type. You can tab-complete the values.

```yaml
Type: PSMemberTypes
Parameter Sets: (All)
Aliases:
Accepted values: AliasProperty, CodeProperty, Property, NoteProperty, ScriptProperty, Properties, PropertySet, Method, CodeMethod, ScriptMethod, Methods, ParameterizedProperty, MemberSet, Event, Dynamic, All

Required: False
Position: Named
Default value: All
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Object

## OUTPUTS

### psHiddenMember

## NOTES

This command has an alias of sm

Learn more about PowerShell: http://jdhitsolutions.com/yourls/newsletter

## RELATED LINKS

[Get-Member]()

[Get-TypeMember](Get-TypeMember.md)
