#requires -version 5.1

Function New-PSDynamicParameter {
<#
.Synopsis
Create a PowerShell dynamic parameter
.Description
This command will create the code for a dynamic parameter that you can insert into your PowerShell script file.
.Link
about_Functions_Advanced_Parameters

#>

    [cmdletbinding()]
    [alias("ndp")]
    [outputtype([System.String[]])]
    Param(
        [Parameter(Position = 0, Mandatory, HelpMessage = "Enter the name of your dynamic parameter.`nThis is a required value.")]
        [ValidateNotNullOrEmpty()]
        [alias("Name")]
        [string[]]$ParameterName,
        [Parameter(Mandatory, HelpMessage = "Enter an expression that evaluates to True or False.`nThis is code that will go inside an IF statement.`nIf using variables, wrap this in single quotes.`nYou can also enter a placeholder like '`$True' and edit it later.`nThis is a required value.")]
        [ValidateNotNullOrEmpty()]
        [string]$Condition,
        [Parameter(HelpMessage = "Is this dynamic parameter mandatory?")]
        [switch]$Mandatory,
        [Parameter(HelpMessage = "Enter an optional default value.")]
        [object[]]$DefaultValue,
        [Parameter(HelpMessage = "Enter an optional parameter alias.`nSpecify multiple aliases separated by commas.")]
        [string[]]$Alias,
        [Parameter(HelpMessage = "Enter the parameter value type such as String or Int32.`nUse a value like string[] to indicate an array.")]
        [type]$ParameterType = "string",
        [Parameter(HelpMessage = "Enter an optional help message.")]
        [ValidateNotNullOrEmpty()]
        [string]$HelpMessage,
        [Parameter(HelpMessage = "Does this dynamic parameter take pipeline input by property name?")]
        [switch]$ValueFromPipelineByPropertyName,
        [Parameter(HelpMessage = "Enter an optional parameter set name.")]
        [ValidateNotNullOrEmpty()]
        [string]$ParameterSetName,
        [Parameter(HelpMessage = "Enter an optional comment for your dynamic parameter.`nIt will be inserted into your code as a comment.")]
        [ValidateNotNullOrEmpty()]
        [string]$Comment,
        [Parameter(HelpMessage = "Validate that the parameter is not NULL or empty.")]
        [switch]$ValidateNotNullOrEmpty,
        [Parameter(HelpMessage = "Enter a minimum and maximum string length for this parameter value`nas an array of comma-separated set values.")]
        [ValidateNotNullOrEmpty()]
        [int[]]$ValidateLength,
        [Parameter(HelpMessage = "Enter a set of parameter validations values")]
        [ValidateNotNullOrEmpty()]
        [object[]]$ValidateSet,
        [Parameter(HelpMessage = "Enter a set of parameter range validations values as a`ncomma-separated list from minimum to maximum")]
        [ValidateNotNullOrEmpty()]
        [int[]]$ValidateRange,
        [Parameter(HelpMessage = "Enter a set of parameter count validations values as a`ncomma-separated list from minimum to maximum")]
        [ValidateNotNullOrEmpty()]
        [int[]]$ValidateCount,
        [Parameter(HelpMessage = "Enter a parameter validation regular expression pattern")]
        [ValidateNotNullOrEmpty()]
        [string]$ValidatePattern,
        [Parameter(HelpMessage = "Enter a parameter validation scriptblock.`nIf using the form, enter the scriptblock text.")]
        [ValidateNotNullOrEmpty()]
        [scriptblock]$ValidateScript
    )

    Begin {
        Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] Starting $($myinvocation.mycommand)"
        $out = @"
    DynamicParam {
    $(If ($comment) { "$([char]35) $comment"})
        If ($Condition) {

        `$paramDictionary = New-Object -Type System.Management.Automation.RuntimeDefinedParameterDictionary

"@

    } #begin

    Process {
        if (-Not $($PSBoundParameters.ContainsKey("ParameterSetName"))) {
            $PSBoundParameters.Add("ParameterSetName", "__AllParameterSets")
        }

        #get validation tests
        $Validations = $PSBoundParameters.GetEnumerator().Where({ $_.key -match "^Validate" })

        #this is structured for future development where you might need to create
        #multiple dynamic parameters. This feature is incomplete at this time
        Foreach ($Name in $ParameterName) {
            Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Defining dynamic parameter $Name [$($parametertype.name)]"
            $out += "`n        # Defining parameter attributes`n"
            $out += "        `$attributeCollection = New-Object -Type System.Collections.ObjectModel.Collection[System.Attribute]`n"
            $out += "        `$attributes = New-Object System.Management.Automation.ParameterAttribute`n"
            #add attributes
            $attributeProperties = 'ParameterSetName', 'Mandatory', 'ValueFromPipeline', 'ValueFromPipelineByPropertyName', 'ValueFromRemainingArguments', 'HelpMessage'
            foreach ($item in $attributeProperties) {
                if ($PSBoundParameters.ContainsKey($item)) {
                    Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Defining $item"
                    if ( $PSBoundParameters[$item] -is [string]) {
                        $value = "'$($PSBoundParameters[$item])'"
                    }
                    else {
                        $value = "`$$($PSBoundParameters[$item])"
                    }

                    $out += "        `$attributes.$item = $value`n"
                }
            }

            #add parameter validations
            if ($validations) {
                Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Processing validations"
                foreach ($validation in $Validations) {
                    Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] ... $($validation.key)"
                    $out += "`n        # Adding $($validation.key) parameter validation`n"
                    Switch ($Validation.key) {
                        "ValidateNotNullOrEmpty" {
                            $out += "        `$v = New-Object System.Management.Automation.ValidateNotNullOrEmptyAttribute`n"
                            $out += "        `$AttributeCollection.Add(`$v)`n"
                        }
                        "ValidateLength" {
                            $out += "        `$value = @($($Validation.Value[0]),$($Validation.Value[1]))`n"
                            $out += "        `$v = New-Object System.Management.Automation.ValidateLengthAttribute(`$value)`n"
                            $out += "        `$AttributeCollection.Add(`$v)`n"
                        }
                        "ValidateSet" {
                            $join = "'$($Validation.Value -join "','")'"
                            $out += "        `$value = @($join) `n"
                            $out += "        `$v = New-Object System.Management.Automation.ValidateSetAttribute(`$value)`n"
                            $out += "        `$AttributeCollection.Add(`$v)`n"
                        }
                        "ValidateRange" {
                            $out += "        `$value = @($($Validation.Value[0]),$($Validation.Value[1]))`n"
                            $out += "        `$v = New-Object System.Management.Automation.ValidateRangeAttribute(`$value)`n"
                            $out += "        `$AttributeCollection.Add(`$v)`n"
                        }
                        "ValidatePattern" {
                            $out += "        `$value = '$($Validation.value)'`n"
                            $out += "        `$v = New-Object System.Management.Automation.ValidatePatternAttribute(`$value)`n"
                            $out += "        `$AttributeCollection.Add(`$v)`n"
                        }
                        "ValidateScript" {
                            $out += "        `$value = {$($Validation.value)}`n"
                            $out += "        `$v = New-Object System.Management.Automation.ValidateScriptAttribute(`$value)`n"
                            $out += "        `$AttributeCollection.Add(`$v)`n"
                        }
                        "ValidateCount" {
                            $out += "        `$value = @($($Validation.Value[0]),$($Validation.Value[1]))`n"
                            $out += "        `$v = New-Object System.Management.Automation.ValidateCountAttribute(`$value)`n"
                            $out += "        `$AttributeCollection.Add(`$v)`n"
                        }
                    } #close switch
                } #foreach validation
            } #validations

            $out += "        `$attributeCollection.Add(`$attributes)`n"

            if ($Alias) {
                Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Adding parameter alias $($alias -join ',')"
                Foreach ($item in $alias) {
                    $out += "`n        # Adding a parameter alias`n"
                    $out += "        `$dynalias = New-Object System.Management.Automation.AliasAttribute -ArgumentList '$Item'`n"
                    $out += "        `$attributeCollection.Add(`$dynalias)`n"
                }
            }

            $out += "`n        # Defining the runtime parameter`n"

            #handle the Switch parameter since it uses a slightly different name
            if ($ParameterType.Name -match "Switch") {
                $paramType = "Switch"
            }
            else {
                $paramType = $ParameterType.Name
            }

            $out += "        `$dynParam1 = New-Object -Type System.Management.Automation.RuntimeDefinedParameter('$Name', [$paramType], `$attributeCollection)`n"
            if ($DefaultValue) {
                Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Using default value $($DefaultValue)"
                if ( $DefaultValue[0] -is [string]) {
                    $value = "'$($DefaultValue)'"
                }
                else {
                    $value = "`$$($DefaultValue)"
                }
                $out += "        `$dynParam1.Value = $value`n"
            }
            $Out += @"
        `$paramDictionary.Add('$Name', `$dynParam1)


"@
        } #foreach dynamic parameter name

    }
    End {
        $out += @"
        return `$paramDictionary
    } # end if
} #end DynamicParam
"@
        $out
        Write-Verbose "[$((Get-Date).TimeofDay) END    ] Ending $($myinvocation.mycommand)"
    } #end
}

Function New-PSDynamicParameterForm {
    [cmdletbinding()]
    [alias("dpf")]
    [Outputtype("None")]
    Param()

    Try {
        Add-`Type -AssemblyName PresentationFramework -ErrorAction stop
        Add-Type -AssemblyName PresentationCore -ErrorAction Stop
    }
    Catch {
        Write-Warning "This command is not compatible with this version of PowerShell."
        Return
    }
    $list = [System.Collections.Generic.list[object]]::new()
    [xml]$xaml = @"
    <Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
    xmlns:local="clr-namespace:New_DynamicParamForm"
    Title="New Dynamic Parameter" Height="475" Width="650" WindowStartupLocation = "CenterScreen" >
    <Grid HorizontalAlignment="Center" Width="650" Margin="0,0,0,0">
        <Grid.ColumnDefinitions>
            <ColumnDefinition Width="0*"/>
            <ColumnDefinition/>
        </Grid.ColumnDefinitions>
        <Label x:Name="label" Content="Parameter Name*" HorizontalAlignment="Left" Height="25" Margin="9,22,0,0" VerticalAlignment="Top" Width="116" Grid.Column="1"/>
        <TextBox x:Name="ParameterName" Grid.ColumnSpan="2" HorizontalAlignment="Left" Height="20" Margin="120,25,0,0" Text="" TextWrapping="Wrap" VerticalAlignment="Top" Width="153"/>
        <CheckBox x:Name="Mandatory" Content="Mandatory" HorizontalAlignment="Center" Margin="0,27,0,0" VerticalAlignment="Top" Grid.Column="1"/>
        <Label x:Name="label_Copy" Content="Parameter Set Name" HorizontalAlignment="Left" Height="25" Margin="307,44,0,0" VerticalAlignment="Top" Width="121" Grid.Column="1"/>
        <TextBox x:Name="ParameterSetName" Grid.ColumnSpan="2" HorizontalAlignment="Left" Height="20" Margin="443,46,0,0" Text="" TextWrapping="Wrap" VerticalAlignment="Top" Width="153"/>
        <Label x:Name="label1" Content="Comment" Grid.ColumnSpan="2" HorizontalAlignment="Left" Margin="18,392,0,0" VerticalAlignment="Top"/>
        <TextBox x:Name="Comment" Grid.ColumnSpan="2" HorizontalAlignment="Left" Margin="87,396,0,0" Text="" TextWrapping="Wrap" VerticalAlignment="Top" Width="345"/>
        <Label x:Name="label2" Content="Parameter Alias" Grid.ColumnSpan="2" HorizontalAlignment="Left" Margin="11,51,0,0" VerticalAlignment="Top"/>
        <TextBox x:Name="Alias" Grid.ColumnSpan="2" HorizontalAlignment="Left" Height="20" Margin="121,54,0,0" Text="" TextWrapping="Wrap" VerticalAlignment="Top" Width="153"/>
        <Label x:Name="label2_Copy" Content="Default Value" Grid.ColumnSpan="2" HorizontalAlignment="Left" Margin="11,78,0,0" VerticalAlignment="Top"/>
        <TextBox x:Name="DefaultValue" Grid.ColumnSpan="2" HorizontalAlignment="Left" Height="20" Margin="121,81,0,0" Text="" TextWrapping="Wrap" VerticalAlignment="Top" Width="153"/>
        <Button x:Name="OK" Content="_Create" Grid.ColumnSpan="2" HorizontalAlignment="Left" Margin="448,394,0,0" VerticalAlignment="Top" Width="75"/>
        <Button x:Name="Quit" Content="Close" Grid.ColumnSpan="2" HorizontalAlignment="Left" Margin="536,394,0,0" VerticalAlignment="Top" Width="75"/>
        <Label x:Name="label2_Copy1" Content="Help Message" Grid.ColumnSpan="2" HorizontalAlignment="Left" Margin="281,78,0,0" VerticalAlignment="Top"/>
        <TextBox x:Name="HelpMessage" HorizontalAlignment="Left" Height="20" Margin="376,81,0,0" Text="" TextWrapping="Wrap" VerticalAlignment="Top" Width="222" Grid.Column="1"/>
        <Label x:Name="label2_Copy2" Content="Parameter Type" Grid.ColumnSpan="2" HorizontalAlignment="Left" Margin="11,105,0,0" VerticalAlignment="Top"/>
        <TextBox x:Name="ParameterType" Grid.ColumnSpan="2" HorizontalAlignment="Left" Height="20" Margin="121,108,0,0" Text="string" TextWrapping="Wrap" VerticalAlignment="Top" Width="153"/>
        <Label x:Name="label3" Content="Condition*" Grid.ColumnSpan="2" HorizontalAlignment="Left" Margin="13,132,0,0" VerticalAlignment="Top"/>
        <TextBox x:Name="Condition" Grid.ColumnSpan="2" HorizontalAlignment="Left" Margin="123,137,0,0" Text="" TextWrapping="Wrap" VerticalAlignment="Top" Width="500"/>
        <Border BorderThickness="1" BorderBrush="Black" Grid.ColumnSpan="2" HorizontalAlignment="Left" Height="1" Margin="10,162,0,0" VerticalAlignment="Top" Width="634"/>
        <Label x:Name="label4" Content="Parameter Validations" Grid.ColumnSpan="2" HorizontalAlignment="Left" Margin="7,166,0,0" VerticalAlignment="Top"/>
        <CheckBox x:Name="ValidateNotNullOrEmpty" Content="ValidateNotNullorEmpty" Grid.ColumnSpan="2" HorizontalAlignment="Left" Margin="39,196,0,0" VerticalAlignment="Top"/>
        <Label x:Name="label5" Content="ValidateCount" Grid.ColumnSpan="2" HorizontalAlignment="Left" Margin="35,212,0,0" VerticalAlignment="Top"/>
        <TextBox x:Name="ValidateCount" HorizontalAlignment="Left" Margin="124,216,0,0" Text="" TextWrapping="Wrap" VerticalAlignment="Top" Width="60" Grid.Column="1"/>
        <Label x:Name="label5_Copy" Content="ValidateLength" HorizontalAlignment="Left" Margin="210,212,0,0" VerticalAlignment="Top" Grid.Column="1"/>
        <TextBox x:Name="ValidateLength" HorizontalAlignment="Left" Margin="303,216,0,0" Text="" TextWrapping="Wrap" VerticalAlignment="Top" Width="60" Grid.Column="1"/>
        <CheckBox x:Name="ValueFromPipelineByPropertyName" Content="ValueFromPipelineByPropertyName" Grid.ColumnSpan="2" HorizontalAlignment="Left" Margin="201,195,0,0" VerticalAlignment="Top"/>
        <Label x:Name="label6" Content="ValidateRange" Grid.ColumnSpan="2" HorizontalAlignment="Left" Margin="394,212,0,0" VerticalAlignment="Top"/>
        <TextBox x:Name="ValidateRange" Grid.ColumnSpan="2" HorizontalAlignment="Left" Margin="481,216,0,0" Text="" TextWrapping="Wrap" VerticalAlignment="Top" Width="120"/>
        <Label x:Name="label5_Copy1" Content="ValidatePattern" Grid.ColumnSpan="2" HorizontalAlignment="Left" Margin="35,242,0,0" VerticalAlignment="Top"/>
        <TextBox x:Name="ValidatePattern" HorizontalAlignment="Left" Margin="125,245,0,0" Text="" TextWrapping="Wrap" VerticalAlignment="Top" Width="150" Grid.Column="1"/>
        <Label x:Name="label5_Copy2" Content="ValidateScript" Grid.ColumnSpan="2" HorizontalAlignment="Left" Margin="35,270,0,0" VerticalAlignment="Top"/>
        <TextBox x:Name="ValidateScript" AcceptsReturn = "True" VerticalScrollBarVisibility="Auto" Grid.ColumnSpan="2" HorizontalAlignment="Left" Margin="121,274,0,0" Text="" TextWrapping="Wrap" VerticalAlignment="Top" Width="250" Height="70"/>
        <Label x:Name="label7" Content="ValidateSet" Grid.ColumnSpan="2" HorizontalAlignment="Left" Margin="34,351,0,0" VerticalAlignment="Top"/>
        <TextBox x:Name="ValidateSet" Grid.ColumnSpan="2" HorizontalAlignment="Left" Height="16" Margin="117,356,0,0" Text="" TextWrapping="Wrap" VerticalAlignment="Top" Width="328"/>
     </Grid>
  </Window>
"@

    $reader = New-Object System.Xml.XmlNodeReader $xaml
    $Window = [Windows.Markup.XamlReader]::Load($reader)

    #get all parameters
    $all = (Get-Command New-PSDynamicParameter).parameters
    #filter out common parameters
    $common = [System.Management.Automation.Cmdlet]::CommonParameters
    $paramList = $all.GetEnumerator().where({$common -notcontains $_.key}).key

    #get controls
    foreach ($item in $paramList) {
    Write-Verbose "Processing control $item"
        Try {
            $tmp = New-Variable -Name $item -Value ($Window.FindName($item)) -ErrorAction Stop -PassThru
            #add a help tool tip
            $tip = $all[$item].attributes.where({$_.typeid.name -eq 'parameterattribute'}).helpMessage
            write-Verbose "Found help $tip"
            $tmp.Value.ToolTip = $tip
            $list.Add((Get-Variable -Name $item))
        }
        Catch {
            Write-Verbose "Skipping $item"
        }
    }

    #hook up code to buttons
    $OK = $Window.FindName("OK")
    $OK.ToolTip = "Create the dynamic parameter code and copy to the clipboard.`nThis will NOT close the form."

    $OK.Add_Click({
        Write-Verbose "Defining dynamic parameter $($ParameterName.text)"

        $splat = @{}
        $list | where-object {$_.value.text} | foreach-object {
        $splat.Add($_.Name,$_.value.Text)
         }
         #add switches
        $list | where-object {$_.value.IsChecked} | foreach-object {
         $splat.Add($_.Name,$True)
        }

        #turn values into arrays as needed
        $Names = "ValidateSet","ValidateCount","ValidateRange","ValidateLength"
        foreach ($n in $names) {
            if ($splat[$n]) {
                $splat[$n] = $splat[$n].split(",")
            }
        }

        #convert ValidateScript text into a scriptblock
        if ($splat["ValidateScript"]) {
            $splat["ValidateScript"] = [scriptblock]::Create($splat["ValidateScript"])
        }
        New-PSDynamicParameter @splat | Set-Clipboard
        Write-Host "Your dynamic parameter code has been copied to the clipboard. Paste it into your script file." -ForegroundColor Green
    })
    $Quit = $Window.FindName("Quit")
    $Quit.Add_Click({$window.close()})

    [void]$window.Activate()
    [void]$window.ShowDialog()
}

#add scripting editor shortcuts or you can run the functions in the editor's console window.
if ($host.name -eq 'Visual Studio Code Host') {
    Register-EditorCommand -Name "DynamicParameterForm" -DisplayName "Define a dynamic parameter" -ScriptBlock (Get-Item -path Function:\New-PSDynamicParameterForm).scriptblock -SuppressOutput
}
elseif ($host.name -match "PowerShell ISE") {
    if ($psise.CurrentPowerShellTab.AddOnsMenu.Submenus.DisplayName -notcontains "New Dynamic Parameter") {
        $action = {New-PSDynamicParameterForm}
        [void]($Psise.CurrentPowerShellTab.AddOnsMenu.Submenus.Add("New Dynamic Parameter", $action, "Ctrl+Alt+D"))
    }
}

