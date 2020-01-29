# display WPF equivalent of the VBSCriptMessageBox


#todo: dynamic parameter to set button default?

Function New-WPFMessageBox {

    [cmdletbinding(DefaultParameterSetName = "standard")]
    [alias("nmb")]
    [Outputtype([int], [boolean], [string])]

    Param(
        [Parameter(Position = 0, Mandatory, HelpMessage = "Enter the text message to display.")]
        [string]$Message,
        [string]$Title = "Message",
        [ValidateSet("Information", "Warning", "Error", "Question", "Shield")]
        [string]$Icon = "Information",
        [Parameter(ParameterSetName = "standard")]
        [ValidateSet("OK", "OKCancel", "YesNo")]
        [string]$ButtonSet = "OK",
        [Parameter(ParameterSetName = "custom")]
        [System.Collections.Specialized.OrderedDictionary]$CustomButtonSet,
        [string]$Background,
        [switch]$Quiet
    )

    if ((Test-IsPSWindows)) {


        # It may not be necessary to add these types but it doesn't hurt to include them
        # but if they can't be laoded then this function will never work anwyway
        Try {

            Add-Type -AssemblyName PresentationFramework -ErrorAction stop
            Add-Type -assemblyName PresentationCore -ErrorAction stop
        }
        Catch {
            Throw $_
            #make sure we abort
            return
        }
        $form = New-Object System.Windows.Window
        #define what it looks like
        $form.Title = $Title
        $form.Height = 200
        $form.Width = 300
        $form.WindowStartupLocation = [System.Windows.WindowStartupLocation]::CenterScreen

        if ($Background) {
            Try {
                $form.Background = $Background
            }
            Catch {
                Write-Warning "See https://docs.microsoft.com/en-us/dotnet/api/system.windows.media.brushes?view=netframework-4.7.2 for help on selecting a proper color. You can enter a color by name or X11 color value."
                Throw $_
            }
        }

        $grid = New-Object System.Windows.Controls.Grid

        $img = New-Object System.Windows.Controls.Image
        $img.Source = Join-Path "$psscriptroot\..\icons" -ChildPath "$icon.png"
        $img.Width = 50
        $img.Height = 50
        $img.HorizontalAlignment = "left"
        $img.VerticalAlignment = "top"
        $img.Margin = "15,5,0,0"

        $grid.AddChild($img)

        $text = New-Object System.Windows.Controls.Textblock
        $text.text = $Message
        $text.Padding = 10
        $text.Width = 200
        $text.Height = 80
        $text.Margin = "75,5,0,0"
        $text.TextWrapping = [System.Windows.TextWrapping]::Wrap
        $text.VerticalAlignment = "top"

        $text.HorizontalAlignment = "left"
        $grid.AddChild($text)

        if ($PSCmdlet.ParameterSetName -eq 'standard') {

            Switch ($ButtonSet) {

                "OK" {
                    $btn = New-Object System.Windows.Controls.Button
                    $btn.Content = "_OK"
                    $btn.Width = 75
                    $btn.Height = 25
                    $btn.Margin = "0,80,0,0"
                    $btn.Add_click( {
                            $form.close()
                            $script:r = 1
                        })
                    $grid.AddChild($btn)
                    $form.add_Loaded( {$btn.Focus()})
                } #ok
                "OKCancel" {
                    $btnOK = New-Object System.Windows.Controls.Button
                    $btnOK.Content = "_OK"
                    $btnOK.Width = 75
                    $btnOK.Height = 25

                    $btnOK.Margin = "-75,75,0,0"
                    $btnOK.Add_click( {
                            $form.close()
                            $script:r = 1
                        })
                    $btnCan = New-Object System.Windows.Controls.Button
                    $btnCan.Content = "_Cancel"
                    $btnCan.Width = 75
                    $btnCan.Height = 25
                    $btnCan.Margin = "120,75,0,0"
                    $btnCan.Add_click( {
                            $form.close()
                            $script:r = 0
                        })
                    $grid.AddChild($btnOK)
                    $grid.AddChild($btnCan)
                    $form.add_Loaded( { $btnOK.Focus()})
                } #okcancel
                "YesNo" {
                    $btnY = New-Object System.Windows.Controls.Button
                    $btnY.Content = "_Yes"
                    $btnY.Width = 75
                    $btnY.Height = 25
                    $btnY.Margin = "-75,75,0,0"
                    $btnY.Add_click( {
                            $form.close()
                            $script:r = $True
                        })
                    $btnNo = New-Object System.Windows.Controls.Button
                    $btnNo.Content = "_No"
                    $btnNo.Width = 75
                    $btnNo.Height = 25
                    $btnNo.Margin = "120,75,0,0"
                    $btnNo.Add_click( {
                            $form.close()
                            $script:r = $False
                        })
                    $grid.AddChild($btnY)
                    $grid.AddChild($btnNo)
                    $form.add_Loaded( {$btnY.Focus()})
                } #yesno
            }
        }
        else {
            #create a custom set of buttons from the hashtable
            switch ($CustomButtonSet.keys.count) {
                1 {
                    $btn = New-Object System.Windows.Controls.Button
                    $btn.Content = "_$($customButtonSet.keys[0])"
                    $btn.Width = 75
                    $btn.Height = 25
                    $btn.Margin = "0,80,0,0"
                    $btn.Add_click( {
                            $form.close()
                            $script:r = $customButtonSet.values[0]
                        })
                    $grid.AddChild($btn)
                    $form.add_Loaded( {$btn.Focus()})
                }
                2 {
                    $btn1 = New-Object System.Windows.Controls.Button
                    $btn1.Content = "_$($customButtonSet.GetEnumerator().name[0])"
                    $btn1.Width = 75
                    $btn1.Height = 25
                    $btn1.Margin = "-75,75,0,0"
                    $btn1.Add_click( {
                            $form.close()
                            $script:r = $customButtonSet[0]
                        })
                    $btn2 = New-Object System.Windows.Controls.Button
                    $btn2.Content = "_$($customButtonSet.GetEnumerator().name[1])"
                    $btn2.Width = 75
                    $btn2.Height = 25
                    $btn2.Margin = "120,75,0,0"
                    $btn2.Add_click( {
                            $form.close()
                            $script:r = $customButtonSet[1]
                        })
                    $grid.AddChild($btn1)
                    $grid.AddChild($btn2)
                    $form.add_Loaded( {$btn1.Focus()})
                }
                3 {
                    $btn1 = New-Object System.Windows.Controls.Button
                    $btn1.Content = "_$($customButtonSet.GetEnumerator().name[0])"
                    $btn1.Width = 75
                    $btn1.Height = 25
                    $btn1.Margin = "-175,75,0,0"
                    $btn1.Add_click( {
                            $form.close()
                            $script:r = $customButtonSet[0]
                        })
                    $btn2 = New-Object System.Windows.Controls.Button
                    $btn2.Content = "_$($customButtonSet.GetEnumerator().name[1])"
                    $btn2.Width = 75
                    $btn2.Height = 25
                    $btn2.Margin = "0,75,0,0"
                    $btn2.Add_click( {
                            $form.close()
                            $script:r = $customButtonSet[1]
                        })
                    $btn3 = New-Object System.Windows.Controls.Button
                    $btn3.Content = "_$($customButtonSet.GetEnumerator().name[2])"
                    $btn3.Width = 75
                    $btn3.Height = 25
                    $btn3.Margin = "175,75,0,0"
                    $btn3.Add_click( {
                            $form.close()
                            $script:r = $customButtonSet[2]
                        })
                    $grid.AddChild($btn1)
                    $grid.AddChild($btn2)
                    $grid.AddChild($btn3)
                    $form.add_Loaded( {$btn1.Focus()})
                }
                Default {
                    Write-Warning "The form cannot accomodate more than 3 buttons."
                    #bail out
                    Return
                }
            }
        }

        #display the form
        $form.AddChild($grid)
        [void]$form.ShowDialog()

        #write the button result to the pipeline if not using -Quiet
        if (-Not $Quiet) {
            $script:r
        }
    }
    else {
        Write-Warning "Sorry. This command requires a Windows platform."

    }

} #end function