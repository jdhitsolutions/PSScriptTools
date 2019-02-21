


Function ConvertTo-WPFGrid {

    [cmdletbinding()]
    [Alias("cwg")]
    [outputtype("none")]

    Param(
        [Parameter(ValueFromPipeline)]
        [psobject]$InputObject,
        [string]$Title = "ConvertTo-WPFGrid",
        [ValidateScript( {$_ -ge 5})]
        [int]$Timeout,
        [switch]$Refresh
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
        $psCmd = [PowerShell]::Create().AddScript( {
                Param(
                    [string]$Title = "ConvertTo-WPFGrid",
                    [ValidateScript( {$_ -ge 5})]
                    [int]$Timeout = 0,
                    [switch]$CenterScreen,
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

                #define a handler when the form is loaded. The scriptblock uses variables defined later
                #in the script
                $form.add_Loaded( {
                        foreach ($col in $datagrid.Columns) {
                            #because of the way I am loading data into the grid
                            #it appears I need to set the sorting on each column
                            $col.CanUserSort = $True
                            $col.SortMemberPath = $col.Header
                        }

                        $form.Height = $datagrid.actualHeight + $status.actualHeight + 50
                        $form.width = $datagrid.actualwidth + 50

                        $datagrid.Items.Refresh()
                        $status.Width = $datagrid.ActualWidth
                        If ($Timeout -gt 0) {
                            $timer.IsEnabled = $True
                            $Timer.Start()
                        }

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
                $stack = New-Object System.Windows.Controls.StackPanel
                $stack.HorizontalAlignment = "center"

                #create a datagrid
                $datagrid = New-Object System.Windows.Controls.DataGrid
                $datagrid.VerticalAlignment = "top"
                $datagrid.HorizontalAlignment = "center"
                $datagrid.ColumnWidth = "Auto"
                #autosize the datagrid
                $datagrid.Height = "Auto"
                $datagrid.Width = "Auto"
                $datagrid.CanUserSortColumns = $True
                $datagrid.CanUserResizeColumns = $True
                $datagrid.CanUserReorderColumns = $True
                $datagrid.AutoGenerateColumns = $True
                #enable alternating color rows
                $datagrid.AlternatingRowBackground = "gainsboro"
                $datagrid.ItemsSource = $data

                $stack.AddChild($datagrid)

                $status = New-Object System.Windows.Controls.TextBlock
                $status.Height = 20
                $status.Background = "lightgray"
                $status.VerticalAlignment = "top"
                $status.HorizontalAlignment = "center"

                $stack.AddChild($status)

                $form.AddChild($stack)

                $Now = Get-Date
                # define a timer to automatically dismiss the form. The timer uses a 1 second interval tick
                if ($Timeout -gt 0) {
                    [int]$script:count = $Timeout
                    $timer = New-Object System.Windows.Threading.DispatcherTimer
                    [datetime]$script:terminate = $now.AddSeconds($timeout)
                    $timer.Interval = [TimeSpan]"0:0:1.00"

                    $timer.add_tick( {
                            if ((Get-Date) -lt $script:terminate) {
                                $status.text = " Last updated $Now - refresh in $script:count seconds"
                                $status.UpdateLayout()
                                $script:count--
                            }
                            else {
                                $timer.stop()
                                if ($Refresh) {
                                    $datagrid.itemssource = Invoke-Command -ScriptBlock $cmd
                                    $datagrid.items.refresh()
                                    $script:count = $timeout
                                    $now = Get-Date
                                    [datetime]$script:terminate = $now.AddSeconds($timeout)
                                    $status.text = " Last updated $Now - refresh in $script:count seconds"
                                    $status.UpdateLayout()
                                    $Timer.Start()
                                }
                            }
                        })
                }
                else {
                    $status.text = " last updated $Now"
                }

                $form.ShowDialog()
            })

        #initialize an array to hold all processed objects
        $data = @()
    } #begin

    Process {
        #add each incoming object to the data array
        $data += $Inputobject
    } #process

    End {
        Write-Verbose "Updating PSBoundparameters"
        $PSBoundParameters.Data = $data
        $PSBoundParameters.remove("Inputobject") | Out-Null

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

        $psboundparameters.cmd = $cmd
        Write-Verbose "Refresh command: $cmd"
        Write-Verbose "Sending PSBoundparameters to runspace"
        
        $psCmd.AddParameters($PSBoundParameters) | Out-Null
        $psCmd.Runspace = $newRunspace
        Write-Verbose "Begin Invoke()"
        $psCmd.BeginInvoke() | Out-Null

        Write-Verbose "Ending $($MyInvocation.MyCommand)"

    } #end

} #close function