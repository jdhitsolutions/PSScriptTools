

Function Get-PowerShellEngine {
    <#
    .Synopsis
    Get the path to the current PowerShell engine
    .Description
    Use this command to find the path to the PowerShell executable, or engine that is running your current session. The path for PowerShell 6 is different than previous versions.

    The default is to provide the path only. But you can also get detailed information
    .Parameter Detail
    Include additional information. Not all properties may have values depending on operating system and PowerShell version.
    .Example
    PS C:\> Get-PowerShellEngine
    C:\WINDOWS\System32\WindowsPowerShell\v1.0\powershell.exe
    .Example
    PS C:\> Get-PowerShellEngine -detail

    Path           : C:\WINDOWS\System32\WindowsPowerShell\v1.0\powershell.exe
    FileVersion    : 10.0.15063.0 (WinBuild.160101.0800)
    PSVersion      : 5.1.15063.502
    ProductVersion : 10.0.15063.0
    Edition        : Desktop
    Host           : Visual Studio Code Host
    Culture        : en-US
    Platform       :

    Result from running in the Visual Studio Code integrated PowerShell terminal

    .Example
    PS C:\> Get-PowerShellEngine -detail

    Path           : C:\Program Files\PowerShell\6.0.0-beta.5\powershell.exe
    FileVersion    :
    PSVersion      : 6.0.0-beta
    ProductVersion :
    Edition        : Core
    Host           : ConsoleHost
    Culture        : en-US
    Platform       : Win32NT

    Result from running in a PowerShell 6 session on Windows 10

    .Example
   PS /home/> get-powershellengine -Detail                           

    Path           : /opt/microsoft/powershell/6.0.0-beta.5/powershell
    FileVersion    : 
    PSVersion      : 6.0.0-beta
    ProductVersion : 
    Edition        : Core
    Host           : ConsoleHost
    Culture        : en-US
    Platform       : Unix

    Result from running in a PowerShell session on Linux

    .Link
    $PSVersionTable
    .Link
    $Host
    .Link
    Get-Process

    .Outputs
    [string]
    [pscustomobject]
    #>
    [CmdletBinding()]
    Param([switch]$Detail)
    
    #get the current PowerShell process and the file that launched it
    $engine = Get-Process -id $pid | Get-Item
    if ($Detail) {
        [pscustomobject]@{
            Path           = $engine.Fullname
            FileVersion    = $engine.VersionInfo.FileVersion
            PSVersion      = $PSVersionTable.PSVersion.ToString()
            ProductVersion = $engine.VersionInfo.ProductVersion
            Edition        = $PSVersionTable.PSEdition
            Host           = $host.name
            Culture        = $host.CurrentCulture
            Platform       = $PSVersionTable.platform
        }
    }
    else {
        $engine.FullName
    }
}

Function Out-More {
    <#
    .Synopsis
    Send "pages" of objects to the pipeline.
    .Description
    This function is designed to display groups or "pages" of objects to the PowerShell pipeline. It is modeled after the legacy More.com command line utility.
    By default the command will write out objects out to the pipeline in groups of 50. You will be prompted after each grouping. Pressing M or Enter will get the next group. Pressing A will stop paging and display all of the remaining objects. Pressing N will display the next object. Press Q to stop writing anything else to the pipeline.
    .Parameter ClearScreen
    Clear the screen prior to writing data to the pipeline. This parameter has an alias of cls.
    .Parameter Count
    The number of objects to group together in a page. This parameter has an alias of i.
    .Example
    PS C:\> get-process | out-more -count 10
    Handles  NPM(K)    PM(K)      WS(K) VM(M)   CPU(s)     Id  SI ProcessName                          
    -------  ------    -----      ----- -----   ------     --  -- -----------                          
       1031      75   122588      81092   841    31.30   1872   1 BoxSync                              
         57       3      488        968    12     0.02   1068   1 BoxSyncMonitor                       
        103       9     1448       4220    67     0.02   1632   0 BtwRSupportService                   
         80       9     3008       8588 ...27    21.00   5192   1 conhost                              
         40       5      752       2780 ...82     0.00   5248   0 conhost                              
         53       7      972       3808 ...07     0.02   6876   1 conhost                              
        482      17     1932       3692    56     0.91    708   0 csrss                                
        520      30     2488     134628   180    31.67    784   1 csrss                                
        408      18     6496      12436 ...35     0.56   1684   0 dasHost                              
        180      14     3348       6748    66     0.50   4688   0 devmonsrv                            
    [M]ore [A]ll [N]ext [Q]uit 
    Display processes in groups of 10.
    .Example
    PS C:\> dir c:\work -file -Recurse | out-more -ClearScreen | tee -Variable work
    List all files in C:\Work and page them to Out-More using the default count, but after clearing the screen first. 
    The results are then piped to Tee-Object which saves them to a variable.
    .Notes
    Learn more about PowerShell:
    http://jdhitsolutions.com/blog/essential-powershell-resources/
    .Link
    http://jdhitsolutions.com/blog/powershell/4707/a-better-powershell-more/
    .Inputs
    System.Object[]
    .Outputs
    System.Object
    #>
    
    [cmdletbinding()]
    Param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [object[]]$InputObject,
        [ValidateRange(1, 1000)]
        [Alias("i")]
        [int]$Count = 50,
        [Alias("cls")]
        [Switch]$ClearScreen
    )
    
    Begin {
        if ($ClearScreen) {
            Clear-Host
        }
        Write-Verbose "Starting: $($MyInvocation.Mycommand)"  
        Write-Verbose "Using a count of $count"
    
        #initialize an array to hold objects
        $data = @()
    
        #initialize some variables to control flow
        $ShowAll = $False
        $ShowNext = $False
        $Ready = $False
        $Quit = $False
    } #begin
    
    Process {
       
        if ($Quit) {
            Write-Verbose "Quitting"
            Break
        }
        elseif ($ShowAll) {
            $InputObject
        }
        elseif ($ShowNext) {
            Write-Verbose "Show Next"
            $ShowNext = $False
            $Ready = $True
            $data = , $InputObject
        }
        elseif ($data.count -lt $count) {
            Write-Verbose "Adding data"
            $data += $Inputobject
        }
        else {
            #write the data to the pipeline
            $data
            #reset data
            $data = , $InputObject
            $Ready = $True
        }
        
        If ($Ready) {   
            #pause
            Do {
                Write-Host "[M]ore [A]ll [N]ext [Q]uit " -ForegroundColor Green -NoNewline
                $r = Read-Host 
                if ($r.Length -eq 0 -OR $r -match "^m") {
                    #don't really do anything
                    $Asked = $True
                }
                else {
                    Switch -Regex ($r) {
            
                        "^n" {
                            $ShowNext = $True 
                            $InputObject 
                            $Asked = $True          
                        }
                        "^a" {
                            $InputObject
                            $Asked = $True
                            $ShowAll = $True
                        }
                        "^q" {
                            #bail out
                            $Asked = $True
                            $Quit = $True
                        }
                        Default {         
                            $Asked = $False
                        }
                    } #Switch
    
                } #else
            } Until ($Asked)
            
            $Ready = $False
            $Asked = $False
        } #else
    
    } #process
    
    End {
        #display whatever is left in $data
        if ($data -AND -Not $ShowAll) {
            Write-Verbose "Displaying remaining data"
            $data
        }
        Write-Verbose "Ending: $($MyInvocation.Mycommand)"
    } #end
    
} #end Out-More
    
Function Invoke-InputBox {
    
        [cmdletbinding(DefaultParameterSetName="plain")]
        [OutputType([system.string],ParameterSetName='plain')]
        [OutputType([system.security.securestring],ParameterSetName='secure')]
    
        Param(
            [Parameter(ParameterSetName="secure")]
            [Parameter(HelpMessage = "Enter the title for the input box. No more than 25 characters.",
            ParameterSetName="plain")]        
    
            [ValidateNotNullorEmpty()]
            [ValidateScript({$_.length -le 25})]
            [string]$Title = "User Input",
    
            [Parameter(ParameterSetName="secure")]        
            [Parameter(HelpMessage = "Enter a prompt. No more than 50 characters.",ParameterSetName="plain")]
            [ValidateNotNullorEmpty()]
            [ValidateScript({$_.length -le 50})]
            [string]$Prompt = "Please enter a value:",
            
            [Parameter(HelpMessage = "Use to mask the entry and return a secure string.",
            ParameterSetName="secure")]
            [switch]$AsSecureString,
    
            [string]$BackgroundColor = "White"
        )
    
        if ($PSEdition -eq 'Core') {
            Write-Warning "Sorry. This command will not run on PowerShell Core."
            #bail out
            Return
        }
    
        Add-Type -AssemblyName PresentationFramework
        Add-Type -AssemblyName PresentationCore
        Add-Type -AssemblyName WindowsBase
    
        #remove the variable because it might get cached in the ISE or VS Code
        Remove-Variable -Name myInput -Scope script -ErrorAction SilentlyContinue
    
        $form = New-Object System.Windows.Window
        $stack = New-object System.Windows.Controls.StackPanel
    
        #define what it looks like
        $form.Title = $title
        $form.Height = 150
        $form.Width = 350
    
        $form.Background = $BackgroundColor
    
        $label = New-Object System.Windows.Controls.Label
        $label.Content = "    $Prompt"
        $label.HorizontalAlignment = "left"
        $stack.AddChild($label)
    
        if ($AsSecureString) {
            $inputbox = New-Object System.Windows.Controls.PasswordBox
        }
        else {
            $inputbox = New-Object System.Windows.Controls.TextBox
        }
    
        $inputbox.Width = 300
        $inputbox.HorizontalAlignment = "center"
    
        $stack.AddChild($inputbox)    
    
        $space = new-object System.Windows.Controls.Label
        $space.Height = 10
        $stack.AddChild($space)
    
        $btn = New-Object System.Windows.Controls.Button
        $btn.Content = "_OK"
    
        $btn.Width = 65
        $btn.HorizontalAlignment = "center"
        $btn.VerticalAlignment = "bottom"
    
        #add an event handler
        $btn.Add_click( {
                if ($AsSecureString) {
                    $script:myInput = $inputbox.SecurePassword
                }
                else {
                    $script:myInput = $inputbox.text
                }
                $form.Close()
            })
    
        $stack.AddChild($btn)
        $space2 = new-object System.Windows.Controls.Label
        $space2.Height = 10
        $stack.AddChild($space2)
    
        $btn2 = New-Object System.Windows.Controls.Button
        $btn2.Content = "_Cancel"
    
        $btn2.Width = 65
        $btn2.HorizontalAlignment = "center"
        $btn2.VerticalAlignment = "bottom"
    
        #add an event handler
        $btn2.Add_click( {
                $form.Close()
            })
    
        $stack.AddChild($btn2)
    
        #add the stack to the form
        $form.AddChild($stack)
    
        #show the form
        $inputbox.Focus() | Out-Null
        $form.WindowStartupLocation = [System.Windows.WindowStartupLocation]::CenterScreen
    
        $form.ShowDialog() | out-null
    
        #write the result from the input box back to the pipeline
        $script:myInput
    
    }
    
    
     