#requires -version 5.0

# ToDo: Add option to use last position for Top and Left properties of the form or provide that as an option
# ToDo: Add statusbar for timer countdown and other information

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
        [int]$Width = 1024,
        [int]$Height = 768,
        [switch]$CenterScreen
    )
    
    Begin {
    
        Write-Verbose "Starting $($MyInvocation.MyCommand)"
    
        # ! It may not be necessary to add these types but it doesn't hurt to include them
        Add-Type -AssemblyName PresentationFramework
        Add-Type -assemblyName PresentationCore
        Add-Type -AssemblyName WindowsBase
            
        # define a timer to automatically dismiss the form. The timer uses a 5 second interval tick
        if ($Timeout -gt 0) {
            Write-Verbose "Creating a timer"
            $timer = new-object System.Windows.Threading.DispatcherTimer
            $terminate = (Get-Date).AddSeconds($timeout)
            Write-verbose "Form will close at $terminate"
            $timer.Interval = [TimeSpan]"0:0:5.00"
                
            $timer.add_tick( {
                    if ((Get-Date) -ge $terminate) {
                        $timer.stop()
                        $form.Close()
                    }
                })
        }
            
        Write-Verbose "Defining form: $Title ($width x $height)"
            
        $form = New-Object System.Windows.Window
        #define what it looks like
        $form.Title = $Title
        $form.Height = $Height
        $form.Width = $Width
            
        if ($CenterScreen) {
            Write-Verbose "Form will be center screen"
            $form.WindowStartupLocation = [System.Windows.WindowStartupLocation]::CenterScreen
        }
        #define a handler when the form is loaded. The scriptblock uses variables defined later
        #in the script
        $form.add_Loaded( {                
                foreach ($col in $datagrid.Columns) {
                    #because of the way I am loading data into the grid
                    #it appears I need to set the sorting on each column
                    $col.CanUserSort = $True
                    $col.SortMemberPath = $col.Header
                }
                $datagrid.Items.Refresh()
                $form.focus
            })
        #Create a stack panel to hold the datagrid
        $stack = New-object System.Windows.Controls.StackPanel
    
        #create a datagrid
        $datagrid = New-Object System.Windows.Controls.DataGrid
            
        $datagrid.VerticalAlignment = "Bottom"
        #adjust the size of the grid based on the form dimensions
        $datagrid.Height = $form.Height - 50
        $datagrid.Width = $form.Width - 50
        $datagrid.CanUserSortColumns = $True
        $datagrid.CanUserResizeColumns = $True
        $datagrid.CanUserReorderColumns = $True
        $datagrid.AutoGenerateColumns = $True
        #enable alternating color rows
        $datagrid.AlternatingRowBackground = "gainsboro"
            
        $stack.AddChild($datagrid)
        $form.AddChild($stack)
    
        #initialize an array to hold all processed objects
        $data = @()
    } #begin
    
    Process {
        #add each incoming object to the data array
        $data += $Inputobject 
    } #process
    
    End {
        Write-Verbose "Preparing form"
        $DataGrid.ItemsSource = $data
    
        #show the form
        If ($Timeout -gt 0) {
            Write-Verbose "Starting timer"
            $timer.IsEnabled = $True
            $Timer.Start()
        }
    
        Write-Verbose "Displaying form"
        $form.ShowDialog() | Out-Null
    
        write-verbose "Ending $($MyInvocation.MyCommand)"
    
    } #end
    
} #close function