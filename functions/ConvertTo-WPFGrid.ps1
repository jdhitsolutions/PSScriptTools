
<#
There is a limitation with autogenerated columns if the property
contains a period or a slash.

https://social.msdn.microsoft.com/Forums/sqlserver/en-US/f5f752f6-f08d-4d46-9e1e-78a4496eaf12/why-does-not-datagrid-show-values-if-there-are-a-point-82208221-or-82208221-in-header?forum=wpf

#>
Function ConvertTo-WPFGrid {

    [cmdletbinding(DefaultParameterSetName = "input")]
    [Alias("cwg")]
    [OutputType("none")]

    Param(
        [Parameter(ValueFromPipeline, ParameterSetName = "Input")]
        [ValidateNotNullOrEmpty()]
        [PSObject]$InputObject,

        [Parameter(ParameterSetName = "scriptblock", HelpMessage = "Enter a scriptblock that will generate data to be populated in the form")]
        [ValidateNotNullOrEmpty()]
        [Scriptblock]$Scriptblock,

        [string]$Title = "ConvertTo-WPFGrid",
        [ValidateScript({$_ -ge 5})]
        [int]$Timeout,

        [switch]$Refresh,

        [Parameter(HelpMessage = "Control how grid lines are displayed")]
        [ValidateSet("All", "Horizontal", "None", "Vertical")]
        [ValidateNotNullOrEmpty()]
        [string]$GridLines = "All",

        [Parameter(HelpMessage = "Run this scriptblock to initialize the background runspace")]
        [scriptblock]$InitializationScript,

        [Parameter(HelpMessage = "Load locally defined variables into the background runspace")]
        [alias("var")]
        [string[]]$UseLocalVariable,

        [Parameter(HelpMessage = "Load your PowerShell profiles into the background runspace")]
        [alias("profile")]
        [switch]$UseProfile
    )

    Begin {
        Write-Verbose "Starting $($MyInvocation.MyCommand)"
        if ($Refresh -AND ($Timeout -lt 5)) {
            Write-Verbose "Detected a timeout value of $Timeout"
            Write-Verbose "Refresh is set to $Refresh"
            Throw "You must specify a timeout value in seconds when using -Refresh"
        }
        #set a flag for the process block
        if ((Test-IsPSWindows)) {
            #attempt to load the WPF related classes which might or might not be available depending
            #on operating system and PowerSell version

            Try {
                Write-Verbose "Attempting to load WPF assemblies"
                Add-Type -AssemblyName PresentationFramework -ErrorAction Stop
                Add-Type -AssemblyName PresentationCore -ErrorAction Stop

            }
            Catch {
                Write-Warning "Failed to load WPF required assemblies. This command isn't supported under this version of PowerShell on this platform. $($_.exception.Message)"

                #bail out out of the command
                break
            }

        Write-Verbose "Define new runspace"
        $newRunspace = [RunspaceFactory]::CreateRunspace()
        if ($newRunspace.ApartmentState) {
            $newRunspace.ApartmentState = "STA"
        }
        else {
            #This command probably won't run if the ApartmentState can't be set to STA
            #clean up
            $newRunspace.dispose()

            Write-Warning "Incompatible runspace detected. This command will most likely fail on this platform with this version of PowerShell."
            #bail out of the command
            break
        }
        $newRunspace.ThreadOptions = "ReuseThread"
        Write-Verbose "Opening new runspace"
        $newRunspace.Open()

        if ($UseLocalVariable) {
            Write-Verbose "Using local variables"
            Get-Variable -include $UseLocalVariable |
                ForEach-Object {
                Write-Verbose "...Adding $($_.name)"
                $newRunspace.sessionStateProxy.SetVariable($_.name, $_.value)
            }
        }

        Write-Verbose "Defining script command"
        $psCmd = [PowerShell]::Create()
        #code to display the WPF form
        $gridScript = {
            Param(
                [string]$Title = "ConvertTo-WPFGrid",
                [ValidateScript( {$_ -ge 5})]
                [int]$Timeout = 0,
                [object[]]$Data,
                [scriptblock]$cmd,
                [switch]$Refresh,
                [string]$GridLines
            )

            # It may not be necessary to add these types but it doesn't hurt to include them
            Add-Type -AssemblyName PresentationFramework
            Add-Type -AssemblyName PresentationCore

                Function _refresh {
                    #this is a function to refresh a UI element
                    Param($element)

                    $element.Dispatcher.invoke("render", [action] {})
                    [System.Threading.Thread]::Sleep(50)
                }

            #get maximum available working area on the screen
            $s = [System.Windows.SystemParameters]::WorkArea

            $form = New-Object System.Windows.Window
            $form.Title = $Title
            $form.MaxHeight = $s.Height
            $form.MaxWidth = $s.Width

            $form.SizeToContent = [System.Windows.SizeToContent]::WidthAndHeight

            #define a handler when the form is loaded. The scriptblock uses variables defined later
            #in the script
            $form.add_Loaded( {
                    $datagrid.UpdateLayout()

                    foreach ($col in $datagrid.Columns) {
                        #because of the way I am loading data into the grid
                        #it appears I need to set the sorting on each column
                        $col.CanUserSort = $True
                        $col.SortMemberPath = $col.Header
                    }

                    If ($Timeout -gt 0) {
                        $timer.IsEnabled = $True
                        $Timer.Start()
                    }

                    #calculate screen dimensions to center the form
                    $s = [System.Windows.SystemParameters]::WorkArea
                    $form.top = $s.Height / 2 - $form.ActualHeight / 2
                    $form.left = $s.width / 2 - $form.ActualWidth / 2
                    $form.UpdateLayout()
                    $form.focus
                })

            $Form.Add_closing( {
                    #reserved for future use
                })
            $Form.Add_closed( {
                    #reserved for future use
                })
            #Create a grid to hold the datagrid
            $Grid = New-Object System.Windows.Controls.Grid

            $Grid.HorizontalAlignment = "stretch"
            $grid.VerticalAlignment = "stretch"

            #add buttons to close and manually refresh (Issue #34)
            $btnRefresh = New-Object System.Windows.Controls.Button
            $btnRefresh.Content = "Refresh Now"
            $btnRefresh.Height = 25
            $btnRefresh.Width = 80
            $btnRefresh.HorizontalAlignment = "left"
            $btnRefresh.VerticalAlignment = "Top"
            $btnRefresh.Margin = "15,10,0,0"
            $btnRefresh.ToolTip = "click to refresh data from the command"

            $btnRefresh.add_click( {
                    [System.Windows.Input.Mouse]::OverrideCursor = [System.Windows.Input.Cursors]::Wait

                    $status.Text = "...refreshing content. Please wait."
                    _refresh $status

                    $timer.stop()
                    Start-Sleep -seconds 3

                    $datagrid.ItemsSource = Invoke-Command -ScriptBlock $cmd

                    foreach ($col in $datagrid.Columns) {
                        #because of the way I am loading data into the grid
                        #it appears I need to set the sorting on each column
                        $col.CanUserSort = $True
                        $col.SortMemberPath = $col.Header
                    }

                    $script:Now = Get-Date

                    if ($script:count) {
                        $script:count = $Timeout
                        [DateTime]$script:terminate = $now.AddSeconds($timeout)
                        $ts = New-TimeSpan -Seconds $script:count
                        $status.text = " Last updated $script:Now - refresh in $($ts.ToString())"
                    }
                    else {
                        $status.text = " last updated $Script:Now"
                    }
                    if ($refresh) {
                        $timer.start()
                    }
                    $form.title = $Title
                    [System.Windows.Input.Mouse]::OverrideCursor = [System.Windows.Input.Cursors]::Arrow
                })

            $grid.AddChild($btnRefresh)

            $btnClose = New-Object System.Windows.Controls.Button
            $btnClose.Content = "Close"
            $btnClose.Height = 25
            $btnClose.Width = 80
            $btnClose.HorizontalAlignment = "Right"
            $btnClose.VerticalAlignment = "Top"
            $btnClose.Margin = "0,10,15,0"
            $btnClose.ToolTip = "close the form and quit"

            $btnClose.add_click( {
                    $form.Close()
                })
            $grid.AddChild($btnClose)

            #create a datagrid
            $datagrid = New-Object System.Windows.Controls.DataGrid
            $datagrid.width = "Auto"
            $datagrid.Height = "Auto"
            $datagrid.VerticalAlignment = "stretch"
            $datagrid.HorizontalAlignment = "stretch"
            $datagrid.margin = "0,50,0,25"

            $datagrid.ColumnWidth = "Auto"
            $datagrid.GridLinesVisibility = $GridLines
            $datagrid.VerticalScrollBarVisibility = [System.Windows.Controls.ScrollBarVisibility]::Auto
            $datagrid.HorizontalScrollBarVisibility = [System.Windows.Controls.ScrollBarVisibility]::Auto
            $datagrid.CanUserSortColumns = $True
            $datagrid.CanUserResizeColumns = $True
            $datagrid.CanUserReorderColumns = $True
            $datagrid.AutoGenerateColumns = $False
            $datagrid.CanUserAddRows = $false
            $datagrid.CanUserDeleteRows = $false
            $datagrid.IsReadOnly = $True
            #enable alternating color rows
            $datagrid.AlternatingRowBackground = "gainsboro"

            $DataTable = New-Object System.Data.DataTable

            #create headers
            $data[0].PSObject.properties.Name |
            ForEach-Object {
                if ($DataTable.columns.caption -NotContains $_) {
                    [void]$DataTable.Columns.add($_)
                }
            }
            foreach ($obj in $data) {
                $props = $obj.PSObject.Properties
                [void]$DataTable.rows.add($props.value)
            }

            for ($i = 0; $i -lt $DataTable.Columns.Count; $i++) {
                $col = New-Object System.Windows.Controls.DataGridTextColumn
                $col.Header = $DataTable.Columns[$i].ColumnName
                $col.Binding = New-Object system.Windows.data.binding("[$i]")
                [void]$dataGrid.Columns.Add($col)
            }
            write-verbose "returning $($DataTable.Rows.Count) rows"

            $dataGrid.ItemsSource = $DataTable.DefaultView

            # $datagrid.ItemsSource = $data

            foreach ($col in $datagrid.Columns) {
                #because of the way I am loading data into the grid
                #it appears I need to set the sorting on each column
                $col.CanUserSort = $True
                $col.SortMemberPath = $col.Header
            }
            $Grid.AddChild($datagrid)

            $status = New-Object System.Windows.Controls.TextBlock
            $status.Height = 20
            $status.Background = "lightgray"
            $status.VerticalAlignment = "bottom"
            $status.HorizontalAlignment = "stretch"
            $status.Width = "Auto"

            $Grid.AddChild($status)

            $form.AddChild($Grid)

            $script:Now = Get-Date
            # define a timer to automatically dismiss the form. The timer uses a 1 second interval tick
            if ($Timeout -gt 0) {
                [int]$script:count = $Timeout
                $timer = New-Object System.Windows.Threading.DispatcherTimer
                [DateTime]$script:terminate = $now.AddSeconds($timeout)
                $timer.Interval = [TimeSpan]"0:0:1.00"

                $timer.add_tick( {
                        $ts = New-TimeSpan -seconds $script:count
                        if ((Get-Date) -lt $script:terminate -AND $Refresh) {
                            $status.text = " Last updated $script:Now - refresh in $($ts.ToString())"
                            $script:count--
                        }
                        elseif ( (Get-Date) -lt $script:terminate) {
                            $status.text = " Last updated $script:Now - closing in $($ts.ToString())"
                            $script:count--
                        }
                        else {
                            $timer.stop()
                            if ($Refresh) {
                                $form.Title = "$Title ...refreshing content. Please wait."
                                [System.Windows.Input.Mouse]::OverrideCursor = [System.Windows.Input.Cursors]::Wait
                                $datagrid.ItemsSource = Invoke-Command -ScriptBlock $cmd

                                foreach ($col in $datagrid.Columns) {
                                    #because of the way I am loading data into the grid
                                    #it appears I need to set the sorting on each column
                                    $col.CanUserSort = $True
                                    $col.SortMemberPath = $col.Header
                                }
                                $script:count = $timeout
                                $script:now = Get-Date
                                [DateTime]$script:terminate = $now.AddSeconds($timeout)
                                $ts = New-TimeSpan -Seconds $script:count
                                $status.text = " Last updated $script:Now - refresh in $($ts.ToString()) seconds"
                                $Timer.Start()
                                $form.title = $Title
                                [System.Windows.Input.Mouse]::OverrideCursor = [System.Windows.Input.Cursors]::Arrow
                            }
                            else {
                                $form.close()
                            }
                        }
                    })
            }
            else {
                $status.text = " last updated $Script:Now"
            }

            $form.ShowDialog()
        }

        If ($UseProfile) {
            Write-Verbose "Loading user profiles"
            $profiles = $profile.AllUsersAllHosts, $profile.AllUsersCurrentHost,
            $profile.CurrentUserAllHosts, $profile.CurrentUserCurrentHost
            foreach ($file in $profiles) {
                if (Test-Path -Path $file) {
                    [void]$psCmd.AddScript($file)
                }
            }
        }
        if ($InitializationScript) {
            Write-Verbose "Loading an initialization scriptblock"
            [void]$psCmd.AddScript($InitializationScript)
        }

        [void]$psCmd.AddScript($gridScript)

        #initialize a list to hold all processed objects
        $data = [System.Collections.Generic.list[object]]::new()
        }
        else {
            $bail = $True
            Write-Warning "This command requires a Windows platform"
            break
        }
    } #begin

    Process {
        #add each incoming object to the data array
        if ($psCmdlet.ParameterSetName -eq 'Input') {
            Write-Verbose "Adding input to data"
            if ($InputObject -is [array]) {
                $data.AddRange($InputObject)
            }
            else {
                $data.Add($InputObject)
            }
        }
        else {
            Write-Verbose "Invoking scriptblock"
            $data = Invoke-Command -ScriptBlock $Scriptblock
        }
    } #process

    End {
        Write-Verbose "Updating PSBoundParameters"
        $PSBoundParameters.Data = $data
        [void]$PSBoundParameters.remove("InputObject")
        if ($PSBoundParameters.ContainsKey("UseProfile")) {
            [void]$PSBoundParameters.Remove("UseProfile")
        }

        if ($psCmdlet.ParameterSetName -eq 'input') {

            #parse the invocation to get the pipelined expression up to this command
            #Write-verbose $($MyInvocation | Out-string)
            Write-Verbose "Parsing $($MyInvocation.line) into a scriptblock"
            Try {
                $cmd = [scriptblock]::Create($MyInvocation.line.substring(0, $MyInvocation.line.LastIndexOf("|")))
            }
            Catch {
                Write-Warning "Error created the cmd scriptblock: $($_.exception.message)"
                if ($Refresh) {
                    Write-Warning "Failed create an invocation scriptblock. In order to refresh run your pipelined expression as a single expression with no breaks."
                }
            }
        }
        else {
            $cmd = $Scriptblock
        }

        $PSBoundParameters.cmd = $cmd
        Write-Verbose "Refresh command: $cmd"

        Write-Verbose "Sending PSBoundParameters to runspace"

        [void]$psCmd.AddParameters($PSBoundParameters)
        $psCmd.Runspace = $newRunspace
        Write-Verbose "Begin Invoke()"
        $handle = $psCmd.BeginInvoke()

        $ThreadJob = New-RunspaceCleanupJob -Handle $handle -powerShell $psCmd -sleep 30 -PassThru
        Write-Verbose "Created monitoring ThreadJob $($ThreadJob.id)"
        Write-Verbose "Ending $($MyInvocation.MyCommand)"

    } #end

} #close function