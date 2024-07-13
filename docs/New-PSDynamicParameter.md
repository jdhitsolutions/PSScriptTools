---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version: https://bit.ly/3JX8R0w
schema: 2.0.0
---

# New-PSDynamicParameter

## SYNOPSIS

Create a PowerShell function dynamic parameter.

## SYNTAX

```yaml
New-PSDynamicParameter [-ParameterName] <String[]> -Condition <String> [-Mandatory]
[-DefaultValue <Object[]>] [-Alias <String[]>] [-ParameterType <Type>] [-HelpMessage <String>][-ValueFromPipelineByPropertyName] [-ParameterSetName <String>][-Comment <String>] [-ValidateNotNullOrEmpty] [-ValidateLength <Int32[]>] [-ValidateSet <Object[]>]
[-ValidateRange <Int32[]>] [-ValidateCount <Int32[]>] [-ValidatePattern <String>] [-ValidateScript <ScriptBlock>] [<CommonParameters>]
```

## DESCRIPTION

This command will create the code for a dynamic parameter that you can insert into your PowerShell script file. You need to specify a parameter name and a condition. The condition value is code that would run inside an If statement. Use a value like $True if you want to add it later in your scripting editor.

## EXAMPLES

### Example 1

```powershell
PS C:\> New-PSDynamicParameter -Condition "$PSEdition -eq 'Core'" -ParameterName ANSI -Alias color -Comment "Create a parameter to use ANSI if running PowerShell 7" -ParameterType switch

    DynamicParam {
    # Create a parameter to use ANSI if running PowerShell 7
        If (Core -eq 'Core') {

        $paramDictionary = New-Object -Type System.Management.Automation.RuntimeDefinedParameterDictionary

        # Defining parameter attributes
        $attributeCollection = New-Object -Type System.Collections.ObjectModel.Collection[System.Attribute]
        $attributes = New-Object System.Management.Automation.ParameterAttribute
        $attributes.ParameterSetName = '__AllParameterSets'
        $attributeCollection.Add($attributes)

        # Adding a parameter alias
        $dynalias = New-Object System.Management.Automation.AliasAttribute -ArgumentList 'color'
        $attributeCollection.Add($dynalias)

        # Defining the runtime parameter
        $dynParam1 = New-Object -Type System.Management.Automation.RuntimeDefinedParameter('ANSI', [Switch], $attributeCollection)
        $paramDictionary.Add('ANSI', $dynParam1)

        return $paramDictionary
    } # end if
} #end DynamicParam
```

This creates dynamic parameter code that you can use in a PowerShell function. Normally you would save this output to a file or copy to the clipboard so that you can paste it into scripting editor.

## PARAMETERS

### -ParameterName

Enter the name of your dynamic parameter.
This is a required value.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: Name

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Condition

Enter an expression that evaluates to True or False.
This is code that will go inside an IF statement.
If using variables, wrap this in single quotes.
You can also enter a placeholder like '$True' and edit it later.
This is a required value.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Mandatory

Is this dynamic parameter mandatory?

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

### -DefaultValue

Enter an optional default value.

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

### -Alias

Enter an optional parameter alias.
Specify multiple aliases separated by commas.

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

### -ParameterType

Enter the parameter value type such as String or Int32.
Use a value like string\[\] to indicate an array.

```yaml
Type: Type
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: String
Accept pipeline input: False
Accept wildcard characters: False
```

### -HelpMessage

Enter an optional help message.

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

### -ValueFromPipelineByPropertyName

Does this dynamic parameter take pipeline input by property name?

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

### -ParameterSetName

Enter an optional parameter set name.

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

### -Comment

Enter an optional comment for your dynamic parameter.
It will be inserted into your code as a comment.

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

### -ValidateNotNullOrEmpty

Validate that the parameter is not NULL or empty.

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

### -ValidateLength

Enter a minimum and maximum string length for this parameter value
as an array of comma-separated set values.

```yaml
Type: Int32[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ValidateSet

Enter a set of parameter validations values

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

### -ValidateRange

Enter a set of parameter range validations values as a
comma-separated list from minimum to maximum

```yaml
Type: Int32[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ValidateCount

Enter a set of parameter count validations values as a
comma-separated list from minimum to maximum

```yaml
Type: Int32[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ValidatePattern

Enter a parameter validation regular expression pattern

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

### -ValidateScript

Enter a parameter validation scriptblock.
If using the form, enter the scriptblock text.

```yaml
Type: ScriptBlock
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.String[]

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[New-PSDynamicParameterForm](New-PSDynamicParameterForm.md)

[about_Functions_Advanced_Parameters]()
