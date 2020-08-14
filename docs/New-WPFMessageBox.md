---
external help file: PSScriptTools-help.xml
Module Name: PSScriptTools
online version: http://bit.ly/31PDbDx
schema: 2.0.0
---

# New-WPFMessageBox

## SYNOPSIS

Display a customizable WPF-based message box.

## SYNTAX

### standard (Default)

```yaml
New-WPFMessageBox [-Message] <String> [-Title <String>] [-Icon <String>]
[-ButtonSet <String>] [-Background <String>] [-Quiet] [<CommonParameters>]
```

### custom

```yaml
New-WPFMessageBox [-Message] <String> [-Title <String>] [-Icon <String>]
[-CustomButtonSet <OrderedDictionary>] [-Background <String>] [-Quiet]
[<CommonParameters>]
```

## DESCRIPTION

This function creates a Windows Presentation Foundation (WPF) based message box. This is intended to replace the legacy MsgBox function from VBScript and the Windows Forms library. The command uses a set of predefined button sets, each of which will close the form and write a value to the pipeline.

    OK     = 1

    Cancel = 0

    Yes    = $True

    No     = $False

You can also create an ordered hashtable of your own buttons and values. See examples. If you prefer to simply display the form, you can use the -Quiet parameter to suppress any output. PowerShell will block until a button is clicked or the form dismissed.

This command requires a Windows platform.

## EXAMPLES

### Example 1

```powershell
PS C:\> New-WPFMessageBox -Message "Are you sure you want to do this?"
-Title Confirm -Icon Question -ButtonSet YesNo
False
```

Display a Yes/No message box. The value of the clicked button will be written to the pipeline. It is assumed you would use this in a script and have logic to determine what to do based on the value.

### Example 2

```powershell
PS C:\> New-WPFMessageBox -Message "Press OK when ready to continue."
-Title "User Deletion" -Quiet -Background crimson -Icon Shield
```

Display a message box with a crimson background and using the Shield icon. No value will be written to the pipeline and PowerShell will wait until OK is clicked or the form dismissed.

### Example 3

```powershell
PS C:\> New-WPFMessageBox -Message "Select a system option from these choices:"
-Title "You Decide" -Background cornsilk -Icon Warning
-CustomButtonSet ([ordered]@{"Reboot"=1;"Shutdown"=2;"Cancel"=3})
```

Create a custom message box with a user-defined set of buttons.

## PARAMETERS

### -Background

You can specify any console color or any value from https://docs.microsoft.com/en-us/dotnet/api/system.windows.media.brushes?view=netframework-4.7.2. You can use the name or the code. Keep in mind there are no provisions to change the font color.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: White
Accept pipeline input: False
Accept wildcard characters: False
```

### -ButtonSet

Select a pre-defined set of buttons. Each button will close the form and write a value to the pipeline. This can serve as the "return value" of the form.

OK     = 1

Cancel = 0

Yes    = $True

No     = $False

```yaml
Type: String
Parameter Sets: standard
Aliases:
Accepted values: OK, OKCancel, YesNo

Required: False
Position: Named
Default value: OK
Accept pipeline input: False
Accept wildcard characters: False
```

### -CustomButtonSet

You can specify your own button set defined in an ordered hashtable. Buttons will be displayed in order from left to right. You can display up to 3 buttons. The key should be the text to display and the value should be the value you expect to write to the pipeline. It is recommended that you keep the button text,short. The first letter of each key will automatically be formatted as an accelerator so you should make sure each key starts with a different letter. The first key will also be set as the default.

```yaml
Type: OrderedDictionary
Parameter Sets: custom
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Icon

Select one of the standard system icons.

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: Information, Warning, Error, Question, Shield

Required: False
Position: Named
Default value: Information
Accept pipeline input: False
Accept wildcard characters: False
```

### -Message

Enter the text message to display.

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

### -Quiet

Suppress any pipeline output.

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

### -Title

Enter the text to be displayed in the title bar. You should keep this brief.

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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Int32

### System.Boolean

### System.String

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Invoke-InputBox](Invoke-InputBox.md)
