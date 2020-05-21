
Function Write-ANSIProgress {
    [cmdletbinding()]
    [alias("wap")]
    [OutputType([System.String])]

    Param (
        [Parameter(Position = 0,Mandatory, ValueFromPipeline, HelpMessage = "Enter a percentage in decimal value like .25")]
        [ValidateScript({$_ -gt 0 -AND $_ -le 1})]
        [double]$PercentComplete,

        [Parameter(HelpMessage = "Specify an ANSI escape sequence for the progress bar color.")]
        [string]$ProgressColor = "$([char]0x1b)[38;5;51m",

        [Parameter(HelpMessage = "Specify what shape to use for the progress bar.")]
        [ValidateSet("Box", "Block", "Circle")]
        [string]$BarSymbol = "Box",

        [Parameter(HelpMessage = "Specify the cursor position")]
        [System.Management.Automation.Host.Coordinates]$Position = $host.ui.rawui.CursorPosition
        )

    Begin {
        Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] Starting $($myinvocation.mycommand)"

        #Validate the progress color. The normal parameter validation techniques don't like the regex pattern
        if ( -Not [regex]::IsMatch($ProgressColor, "$([char]0x1b)\[\d+[\d;]+m")) {
            Throw "You entered an invalid ANSI escape sequence"
        }
        #the closing ANSI sequence
        $end = "$([char]0x1b)[0m"

        #a length of 50 is the max or 100%
        $max = 50
        Switch ($BarSymbol) {
            "box" { $block = [char]9632 }
            "block" { $block = [char]9608}
            "circle" { $block = [char]9679 }
        }

        #these values will be used to set the progress bar position
        $x = $position.x
        $y = $position.y + 1
        #may need to insert a line in case we are at the bottom of a console or terminal screen
        if ($env:WT_SESSION -AND ($position.y + 1 -ge $host.ui.RawUI.BufferSize.Height)) {
            Write-Output "`n"
        }

    } #begin

    Process {
        If ($host.Name -match "PowerShell ISE") {
            Write-Warning "This command will not work in the PowerShell ISE."
            #bail out
            return
        }
        Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] $PercentComplete %"
        [int]$len = $max * $PercentComplete
        #get current cursor position if in Windows Terminal
        if ($env:WT_SESSION -AND ($position.y + 1 -ge $host.ui.RawUI.BufferSize.Height)) {
            $y = $host.ui.RawUI.CursorPosition.Y-1
        }
        [System.Console]::SetCursorPosition($x, $y)
        #align and pad the percentage value
        $pct = "$($percentComplete*100)%".PadLeft(4)
        "$pct $ProgressColor$($($Block.toString())*$len)$End"
    } #process

    End {
        Write-Verbose "[$((Get-Date).TimeofDay) END    ] Ending $($myinvocation.mycommand)"
    } #end

} #close Write-ANSIProgress
