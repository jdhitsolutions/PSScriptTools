Function Trace-Message {
    [cmdletbinding(DefaultParameterSetName = "message")]
    [alias("trace")]
    [OutputType("none")]

    Param(
        [Parameter(HelpMessage = "Specify a title for the trace window.", ParameterSetName = "init")]
        [ValidateNotNullOrEmpty()]
        [string]$Title = "Trace Messages",
        [Parameter(HelpMessage = "Specify a background color for the trace window", ParameterSetName = "init")]
        [ValidateNotNullOrEmpty()]
        [string]$BackgroundColor = "#FFFFF8DC",
        [Parameter(HelpMessage = "Specify the width of the trace window.", ParameterSetName = "init")]
        [ValidateNotNullOrEmpty()]
        [int32]$Width = 800,
        [Parameter(HelpMessage = "Specify the width of the trace window.", ParameterSetName = "init")]
        [ValidateNotNullOrEmpty()]
        [int32]$Height = 500,
        [Parameter(Position = 0, Mandatory,HelpMessage = "Specify a message to write to the trace window.", ValueFromPipeline, ParameterSetName = "message")]
        [string]$Message
    )

    Begin {
        Write-Verbose "Starting $($MyInvocation.MyCommand)"
        Function _SetTraceMessage {
            [cmdletbinding()]
            Param(
                [Parameter(Mandatory, ValueFromPipeline)]
                [string]$Message
            )
            Begin {
                $hash =  $global:traceSynchHash
            }
            Process {
                Write-Verbose "Adding message $message"
                $content = "$((Get-Date).TimeOfDay) - $message"
                $hash.TextBox.Dispatcher.Invoke([action] { $hash.TextBox.AppendText("$Content`n") }, "Normal")
            }
            End {}
        }
    } #begin

    Process {
        #must be running Windows
        if ($IsLinux -OR $IsMacOS) {
            Write-Warning "This command only works on Windows platforms."
            #bail out
            return
        }
        Write-Verbose "Using parameter set $($PSCmdlet.ParameterSetName)"
        if ($global:TraceEnabled) {
            if ($PSCmdlet.ParameterSetName -eq 'init') {

                Write-Verbose "Defining synchronized hashtable `$global:traceSynchHash"
                $global:traceSynchHash = [hashtable]::Synchronized(@{Date=(Get-Date)})

                Write-Verbose "Initializing a new runspace"
                $newRunspace = [RunspaceFactory]::CreateRunspace()
                $newRunspace.ApartmentState = "STA"
                $newRunspace.ThreadOptions = "ReuseThread"
                Write-Verbose "Open the new runspace"
                $newRunspace.Open()
                Write-Verbose "Setting synchronized hashtable variable"
                $newRunspace.SessionStateProxy.SetVariable("traceSynchHash", $global:traceSynchHash)
                $newRunspace.SessionStateProxy.GetVariable("traceSynchHash") | Out-String | Write-Verbose

                $formParams = @{
                    Title           = $title
                    BackgroundColor = $BackgroundColor
                    Width           = $width
                    Height          = $Height
                }
                Write-Verbose "Creating runspace script"
                $PSCmd = [PowerShell]::Create().AddScript( {
                        Param([string]$Title, [object]$BackgroundColor, [int]$width, [int]$height)

                        Add-Type -AssemblyName PresentationFramework -ErrorAction stop
                        Add-Type -AssemblyName PresentationCore -ErrorAction stop
                        Add-Type -AssemblyName System.Windows.Forms -ErrorAction Stop

                        $form = New-Object System.Windows.Window

                        $form.Title = $Title
                        $form.Height = $height
                        $form.Width = $width
                        $form.ResizeMode = "noResize"
                        $form.Background = $BackgroundColor
                        $Form.Left = 100
                        $form.Top = 100
                        #$form.WindowStartupLocation = [System.Windows.WindowStartupLocation]::CenterScreen

                        $grid = New-Object System.Windows.Controls.Grid

                        $text = New-Object System.Windows.Controls.TextBox
                        $text.text = ""
                        #$text.Text = "Starting...`n"
                        $text.Padding = 5
                        $text.Width = $form.width - 25
                        $text.Height = $form.Height - 100
                        $text.Margin = "5,5,5,5"
                        $text.TextWrapping = [System.Windows.TextWrapping]::Wrap
                        $text.VerticalAlignment = "top"
                        $text.IsEnabled = $True
                        $text.AcceptsReturn = $True
                        $text.VerticalScrollBarVisibility = "Auto"
                        $text.FontFamily = "Consolas"
                        $text.HorizontalAlignment = "stretch"
                        $text.VerticalAlignment = "top"

                        $grid.AddChild($text)

                        $Quit = New-Object System.Windows.Controls.Button
                        $quit.Content = "_Quit"
                        $quit.Width = 75
                        $quit.Height = 25
                        $quit.Margin = "10,10,0,10"
                        $quit.HorizontalAlignment = "Left"
                        $quit.VerticalAlignment = "bottom"
                        $quit.Add_click( {
                            $form.close()
                            $traceSynchHash.clear()
                            Remove-Variable -name traceSynchHash -Scope global
                        })
                        $grid.AddChild($quit)

                        $Save = New-Object System.Windows.Controls.Button
                        $save.Content = "_Save"
                        $save.Width = 75
                        $save.Height = 25
                        $save.Margin = "10,10,10,10"
                        $save.HorizontalAlignment = "right"
                        $save.VerticalAlignment = "bottom"
                        $save.Add_click( {
                                $SaveDialog = New-Object System.Windows.Forms.SaveFileDialog
                                $SaveDialog.InitialDirectory = "$ENV:Temp"
                                $SaveDialog.Filter = "txt Files (*.txt)|*.txt |All files (*.*)|*.*"
                                [void]$SaveDialog.ShowDialog()
                                if ($SaveDialog.Filename) {
                                    $text.text | Out-File -FilePath $SaveDialog.filename
                                    [System.Windows.Forms.MessageBox]::Show("Trace log exported to $($SaveDialog.Filename)", "Trace Export | Trace Message")
                                }
                            })

                        $grid.AddChild($Save)
                        $form.AddChild($grid)

                        #add keys to the synchronized hashtable
                        $traceSynchHash.TextBox = $text
                        $traceSynchHash.Form = $Form
                        #show the form
                        [void]$traceSynchHash.Form.ShowDialog()
                        $traceSynchHash.Error = $Error
                    })

                #add parameters
                [void]$PSCmd.AddParameters($formParams)
                $PSCmd.Runspace = $newRunspace
                Write-Verbose "Invoking runspace command"
                $handle = $PSCmd.BeginInvoke()

                Write-Verbose "Using this global synchronized hashtable"
                $global:traceSynchHash | Out-String | Write-Verbose

                #wait for hashtable to initialize with runspace values
                $i=0
                do {
                    $i++
                    start-sleep -Seconds 1
                    #uncomment for troubleshooting
                    #Write-host $i -ForegroundColor yellow -NoNewline
                } Until ($global:traceSynchHash.TextBox)

                Write-Verbose "Creating a runspace cleanup job"
                [void](New-RunspaceCleanupJob -Handle $handle -powerShell $PSCmd -sleep 30 -PassThru)

                Write-Verbose "Getting trace metadata"
                $elevated = ([Security.Principal.WindowsPrincipal]([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([System.Security.Principal.SecurityIdentifier]"S-1-5-32-544")
                $os = Get-CimInstance -ClassName Win32_OperatingSystem -Property Caption, Version, OSArchitecture

                $init = @(
                    "*************************************************",
                    "User         : $($env:USERDOMAIN)\$($env:USERNAME)",
                    "Elevated     : $Elevated",
                    "Computer     : $env:Computername",
                    "PSVersion    : $($PSVersionTable.PSVersion)",
                    "OS           : $($os.caption)",
                    "Version      : $($os.version)",
                    "Architecture : $($os.OSArchitecture)",
                    "*************************************************"
                )
                Write-Verbose "Init"
                $init | Write-Verbose
                Write-Verbose "Setting trace metadata"
                $init | _SetTraceMessage

            } #if init
            else {
                Write-Verbose "Setting message $message"
                _SetTraceMessage -Message $Message
            }
        }
        else {
            Write-Verbose "TraceEnabled is set to False"
        }
    } #process

    End {
        Write-Verbose "Ending $($MyInvocation.MyCommand)"
    } #end
}