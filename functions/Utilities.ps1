function Get-PowerShellEngine {
    [CmdletBinding()]
    [OutputType('String', 'PSEngine')]
    param([switch]$Detail)

    #tags are used for categorizing the command
    #cmdTags = general
    #get the current PowerShell process and the file that launched it
    $engine = Get-Process -Id $pid | Get-Item

    if ($Detail) {
        [PSCustomObject]@{
            PSTypeName     = 'PSEngine'
            Path           = $engine.FullName
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

function Out-More {
    [cmdletbinding()]
    [alias('om')]
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [object[]]$InputObject,

        [parameter(Position = 0, HelpMessage = 'Specify the approximate number of items to page.')]
        [ValidateRange(1, 1000)]
        [Alias('i', 'page')]
        [int]$Count = 50,

        [Alias('cls')]
        [Switch]$ClearScreen
    )

    begin {
        #tags are used for categorizing the command
        #cmdTags = console
        if ($ClearScreen) {
            Clear-Host
        }

        Write-Verbose "Starting: $($MyInvocation.MyCommand)"
        Write-Verbose "Using a count of $count"

        #initialize an array to hold objects
        Write-Verbose 'Initializing data array'
        $data = @()

        #initialize some variables to control flow
        $ShowAll = $False
        $ShowNext = $False
        $Ready = $False
        $Quit = $False

        #22 July 2026 ANSI code to clear the prompt when displaying the next page
        function _clearPrompt {
            $e = [char]27
            "$($e)[2A"
            "$($e)[K"
            "$($e)[3A"
            "$($e)[1G"
        }
    } #begin

    process {
        if ($Quit) {
            Write-Verbose 'Quitting'
            break
        }
        elseif ($ShowAll) {
            $InputObject
        }
        elseif ($ShowNext) {
            Write-Verbose 'Show Next'
            $ShowNext = $False
            $Ready = $True
            $data = , $InputObject
        }
        elseif ($data.count -lt $count) {
            Write-Verbose 'Adding data'
            $data += $InputObject
        }
        else {
            #write the data to the pipeline
            $data
            #reset data
            $data = , $InputObject
            $Ready = $True
        }

        if ($Ready) {
            #pause
            do {
                Write-Host '[M]ore [A]ll [N]ext [Q]uit ' -ForegroundColor Green -NoNewline
                $r = Read-Host
                if ($r.Length -eq 0 -or $r -match '^m') {
                    #don't really do anything
                    $Asked = $True
                    _clearPrompt
                }
                else {
                    switch -Regex ($r) {
                        '^n' {
                            _clearPrompt
                            $ShowNext = $True
                            $InputObject
                            $Asked = $True
                        }
                        '^a' {
                            _clearPrompt
                            $InputObject
                            $Asked = $True
                            $ShowAll = $True
                        }
                        '^q' {
                            #bail out
                            $Asked = $True
                            $Quit = $True
                            $ShowAll = $True
                        }
                        default {
                            $Asked = $False
                        }
                    } #Switch

                } #else
            } until ($Asked)

            $Ready = $False
            $Asked = $False
        } #else

    } #process

    end {
        #test if data is from a Get-Help command in
        #which case it will be a single string that needs
        #to be broken apart

        if ([regex]::Matches($data, "`n").count -gt 1) {
            [void]$PSBoundParameters.remove('InputObject')
            Write-Verbose 'Splitting input and re-running through Out-More'
            $data.split("`n") | Out-More @PSBoundParameters
        }
        elseif ($data[0].PSObject.TypeNames -contains 'MamlCommandHelpInfo') {
            Write-Verbose 'Help output detected'
            [void]$PSBoundParameters.remove('InputObject')
            ($data | Out-String).split("`n") | Out-More @PSBoundParameters
        }
        #display whatever is left in $data
        if ($data -and -not $ShowAll) {
            Write-Verbose 'Displaying remaining data'
            $data
        }
        Write-Verbose "Ending: $($MyInvocation.MyCommand)"
    } #end

} #end Out-More

function Invoke-InputBox {
    [cmdletbinding(DefaultParameterSetName = 'plain')]
    [alias('ibx')]
    [OutputType([System.String], ParameterSetName = 'plain')]
    [OutputType([System.Security.SecureString], ParameterSetName = 'secure')]

    param(
        [Parameter(ParameterSetName = 'secure')]
        [Parameter(HelpMessage = 'Enter the title for the input box. No more than 25 characters.',
            ParameterSetName = 'plain')]

        [ValidateNotNullOrEmpty()]
        [ValidateScript( { $_.length -le 25 })]
        [string]$Title = 'User Input',

        [Parameter(ParameterSetName = 'secure')]
        [Parameter(HelpMessage = 'Enter a prompt. No more than 50 characters.', ParameterSetName = 'plain')]
        [ValidateNotNullOrEmpty()]
        [ValidateScript( { $_.length -le 50 })]
        [string]$Prompt = 'Please enter a value:',

        [Parameter(HelpMessage = 'Use to mask the entry and return a secure string.',
            ParameterSetName = 'secure')]
        [switch]$AsSecureString,

        [string]$BackgroundColor = 'White'
    )

    #tags are used for categorizing the command
    #cmdTags = graphical
    if ((Test-IsPSWindows)) {
        Add-Type -AssemblyName PresentationFramework
        Add-Type -AssemblyName PresentationCore

        #remove the variable because it might get cached in the ISE or VS Code
        Remove-Variable -Name myInput -Scope script -ErrorAction SilentlyContinue

        $form = New-Object System.Windows.Window
        $stack = New-Object System.Windows.Controls.StackPanel

        #define what it looks like
        $form.Title = $title
        $form.Height = 150
        $form.Width = 350

        $form.Background = $BackgroundColor

        $label = New-Object System.Windows.Controls.Label
        $label.Content = "    $Prompt"
        $label.HorizontalAlignment = 'left'
        $stack.AddChild($label)

        if ($AsSecureString) {
            $InputBox = New-Object System.Windows.Controls.PasswordBox
        }
        else {
            $InputBox = New-Object System.Windows.Controls.TextBox
        }

        $InputBox.Width = 300
        $InputBox.HorizontalAlignment = 'center'

        $stack.AddChild($InputBox)

        $space = New-Object System.Windows.Controls.Label
        $space.Height = 10
        $stack.AddChild($space)

        $btn = New-Object System.Windows.Controls.Button
        $btn.Content = '_OK'

        $btn.Width = 65
        $btn.HorizontalAlignment = 'center'
        $btn.VerticalAlignment = 'bottom'

        #add an event handler
        $btn.Add_click( {
                if ($AsSecureString) {
                    $script:myInput = $InputBox.SecurePassword
                }
                else {
                    $script:myInput = $InputBox.text
                }
                $form.Close()
            })

        $stack.AddChild($btn)
        $space2 = New-Object System.Windows.Controls.Label
        $space2.Height = 10
        $stack.AddChild($space2)

        $btn2 = New-Object System.Windows.Controls.Button
        $btn2.Content = '_Cancel'

        $btn2.Width = 65
        $btn2.HorizontalAlignment = 'center'
        $btn2.VerticalAlignment = 'bottom'

        #add an event handler
        $btn2.Add_click( {
                $form.Close()
            })

        $stack.AddChild($btn2)

        #add the stack to the form
        $form.AddChild($stack)

        #show the form
        [void]$InputBox.Focus()
        $form.WindowStartupLocation = [System.Windows.WindowStartupLocation]::CenterScreen

        [void]$form.ShowDialog()

        #write the result from the input box back to the pipeline
        $script:myInput
    }
    else {
        Write-Warning 'Sorry. This command requires a Windows platform.'
        #bail out
        return
    }
}

function Set-ConsoleTitle {
    [cmdletbinding(SupportsShouldProcess)]
    [OutputType('None')]
    param(
        [Parameter(Position = 0, Mandatory, HelpMessage = 'Enter the title for the console window.')]
        [ValidateNotNullOrEmpty()]
        [string]$Title
    )
    begin {
        #tags are used for categorizing the command
        #cmdTags = console
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Starting $($MyInvocation.MyCommand)"
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Running under PowerShell version $($PSVersionTable.PSVersion)"
        $width = ($host.UI.RawUI.MaxWindowSize.Width * 2)
    } #begin

    process {
        if ($host.Name -ne 'ConsoleHost') {
            Write-Warning 'This command must be run from a PowerShell console session. Not the PowerShell ISE or Visual Studio Code or similar environments.'
        }
        elseif (($title.length -ge $width)) {
            Write-Warning "Your title is too long. It needs to be less than $width to fit your current console."
        }
        else {
            Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Setting console title to $Title"
            if ($PSCmdlet.ShouldProcess($Title)) {
                $host.UI.RawUI.WindowTitle = $Title
            }
        }
    } #process

    end {
        Write-Verbose "[$((Get-Date).TimeOfDay) END    ] Ending $($MyInvocation.MyCommand)"
    } #end

} #close Set-ConsoleTitle
function New-RunspaceCleanupJob {
    [cmdletbinding()]
    [OutputType('None', 'ThreadJob')]
    param(
        [Parameter(
            Mandatory,
            HelpMessage = 'This should be the System.Management.Automation.Runspaces.AsyncResult object from the BeginInvoke() method.'
        )]
        [ValidateNotNullOrEmpty()]
        [object]$Handle,
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PowerShell]$PowerShell,
        [Parameter(HelpMessage = 'Specify a sleep interval in seconds')]
        [ValidateRange(5, 600)]
        [int32]$SleepInterval = 10,
        [Parameter(HelpMessage = 'Pass the thread job object to the pipeline')]
        [switch]$PassThru
    )

    #tags are used for categorizing the command
    #cmdTags = scripting

    $job = Start-ThreadJob -ScriptBlock {
        param($handle, $ps, $sleep)
        #the Write-Host lines are so that if you look at the results of  the thread job
        #you'll see something you can use for debugging or troubleshooting.
        Write-Host "[$(Get-Date)] Sleeping in $sleep second loops"
        Write-Host 'Watching this runspace'
        Write-Host ($ps.runspace | Select-Object -Property * | Out-String)
        #loop until the handle shows as completed, sleeping the the specified
        #number of seconds
        do {
            Start-Sleep -Seconds $sleep
        } until ($handle.IsCompleted)
        Write-Host "[$(Get-Date)] Closing runspace"

        $ps.runspace.close()
        Write-Host "[$(Get-Date)] Disposing runspace"
        $ps.runspace.Dispose()
        Write-Host "[$(Get-Date)] Disposing PowerShell"
        $ps.dispose()
        Write-Host "[$(Get-Date)] Ending job"
    } -ArgumentList $Handle, $PowerShell, $SleepInterval

    if ($PassThru) {
        #Write the ThreadJob object to the pipeline
        $job
    }
}
#EOF
