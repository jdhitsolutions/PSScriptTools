
Function ConvertTo-WPFGrid {

    [cmdletbinding(DefaultParameterSetName = "input")]
    [Alias("cwg")]
    [outputtype("none")]

    Param(
        [Parameter(ValueFromPipeline, ParameterSetName = "Input")]
        [ValidateNotNullOrEmpty()]
        [psobject]$InputObject,

        [Parameter(ParameterSetName = "scriptblock", HelpMessage = "Enter a scriptblock that will generate data to be populated in the form")]
        [ValidateNotNullOrEmpty()]
        [Scriptblock]$Scriptblock,

        [string]$Title = "ConvertTo-WPFGrid",
        [ValidateScript( {$_ -ge 5})]
        [int]$Timeout,
        [switch]$Refresh,
        [Parameter(HelpMessage = "Load your PowerShell profiles into the background runspace")]
        [switch]$UseProfile
    )

    Begin {

        Write-Verbose "Starting $($MyInvocation.MyCommand)"

        if ($Refresh -AND $timeout -le 5) {
            Throw "You must specify a timeout value when using -Refresh"
        }

        Write-Verbose "Creating new runspace"
        $newRunspace = [RunspaceFactory]::CreateRunspace()
        $newRunspace.ApartmentState = "STA"
        $newRunspace.ThreadOptions = "ReuseThread"
        $newRunspace.Open()

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
                [switch]$Refresh
            )

            # It may not be necessary to add these types but it doesn't hurt to include them
            Add-Type -AssemblyName PresentationFramework
            Add-Type -AssemblyName PresentationCore
            Add-Type -AssemblyName WindowsBase

            $form = New-Object System.Windows.Window
            $form.Title = $Title

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

                    $status.Width = $datagrid.ActualWidth

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
            #Create a stack panel to hold the datagrid
            $Grid = new-object System.Windows.Controls.Grid
            #New-Object System.Windows.Controls.StackPanel

            $Grid.HorizontalAlignment = "center"

            #create a datagrid
            $datagrid = New-Object System.Windows.Controls.DataGrid
            $datagrid.VerticalAlignment = "top"
            $datagrid.HorizontalAlignment = "center"
            $datagrid.ColumnWidth = "Auto"

            $datagrid.VerticalScrollBarVisibility = [System.Windows.Controls.ScrollBarVisibility]::Auto
            $datagrid.CanUserSortColumns = $True
            $datagrid.CanUserResizeColumns = $True
            $datagrid.CanUserReorderColumns = $True
            $datagrid.AutoGenerateColumns = $True
            #enable alternating color rows
            $datagrid.AlternatingRowBackground = "gainsboro"
            $datagrid.ItemsSource = $data

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
            $status.HorizontalAlignment = "center"
            $status.Width = $datagrid.ActualWidth

            $Grid.AddChild($status)

            $form.AddChild($Grid)

            $script:Now = Get-Date
            # define a timer to automatically dismiss the form. The timer uses a 1 second interval tick
            if ($Timeout -gt 0) {
                [int]$script:count = $Timeout
                $timer = New-Object System.Windows.Threading.DispatcherTimer
                [datetime]$script:terminate = $now.AddSeconds($timeout)
                $timer.Interval = [TimeSpan]"0:0:1.00"

                $timer.add_tick( {

                        $status.Width = $datagrid.actualWidth
                        $status.UpdateLayout()

                        if ((Get-Date) -lt $script:terminate -AND $Refresh) {
                            $status.text = " Last updated $script:Now - refresh in $script:count seconds"
                            $script:count--
                        }
                        elseif ( (Get-Date) -lt $script:terminate) {

                            $status.text = " Last updated $script:Now - closing in $script:count seconds"
                            $script:count--
                        }
                        else {
                            $timer.stop()
                            if ($Refresh) {
                                $datagrid.itemssource = Invoke-Command -ScriptBlock $cmd
                                $datagrid.items.refresh()
                                foreach ($col in $datagrid.Columns) {
                                    #because of the way I am loading data into the grid
                                    #it appears I need to set the sorting on each column
                                    $col.CanUserSort = $True
                                    $col.SortMemberPath = $col.Header
                                }
                                $script:count = $timeout
                                $script:now = Get-Date
                                [datetime]$script:terminate = $now.AddSeconds($timeout)
                                $status.text = " Last updated $script:Now - refresh in $script:count seconds"
                                # $status.UpdateLayout()
                                $Timer.Start()
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
            $profiles = $profile.AllUsersAllHosts, $profile.AllUsersCurrentHost,
            $profile.CurrentUserAllHosts, $profile.CurrentUserCurrentHost
            foreach ($file in $profiles) {
                if (Test-Path -path $file) {
                    $psCmd.AddScript($file) | Out-Null
                }
            }
        }

        $pscmd.AddScript($gridScript) | Out-Null

        #initialize an array to hold all processed objects
        $data = @()
    } #begin

    Process {
        #add each incoming object to the data array
        if ($psCmdlet.ParameterSetName -eq 'Input') {
            $data += $Inputobject
        }
        else {
            Write-Verbose "Invoking scriptblock"
            $data = Invoke-Command -ScriptBlock $Scriptblock
        }
    } #process

    End {
        Write-Verbose "Updating PSBoundparameters"
        $PSBoundParameters.Data = $data
        $PSBoundParameters.remove("Inputobject") | Out-Null
        if ($PSBoundParameters.ContainsKey("UseProfile")) {
            $PSBoundParameters.Remove("UseProfile") | Out-Null
        }

        if ($psCmdlet.ParameterSetName -eq 'input') {

            #parse the invocation to get the pipelined expression up to this command
            #Write-verbose $($myinvocation | Out-string)
            Write-Verbose "Parsing $($myinvocation.line) into a scriptblock"
            Try {
                $cmd = [scriptblock]::Create($myinvocation.line.substring(0, $myinvocation.line.LastIndexOf("|")))
            }
            Catch {
                write-warning "Error created the cmd scriptblock: $($_.exception.message)"
                if ($Refresh) {
                    Write-Warning "Failed create an invocation scriptblock. In order to refresh run your pipelined expression as a single expression with no breaks."
                }
            }
        }
        else {
            $cmd = $Scriptblock
        }
        if ($Refresh) {
            $psboundparameters.cmd = $cmd
            Write-Verbose "Refresh command: $cmd"
        }
        Write-Verbose "Sending PSBoundparameters to runspace"

        $psCmd.AddParameters($PSBoundParameters) | Out-Null
        $psCmd.Runspace = $newRunspace
        Write-Verbose "Begin Invoke()"
        $psCmd.BeginInvoke() | Out-Null

        Write-Verbose "Ending $($MyInvocation.MyCommand)"

    } #end

} #close function