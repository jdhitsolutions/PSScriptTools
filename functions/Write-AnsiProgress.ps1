Function Write-ANSIProgress {
    [cmdletbinding()]
    [alias("wap")]
    [OutputType("None","String")]

    Param (
        [Parameter(
            Position = 0,
            Mandatory,
            ValueFromPipeline,
            HelpMessage = "Enter a percentage in decimal value like .25"
            )]
        [ValidateScript({$_ -gt 0 -AND $_ -le 1})]
        [double]$PercentComplete,

        [Parameter(HelpMessage = "Specify an ANSI escape sequence or a PSStyle setting for the progress bar color.")]
        [string]$ProgressColor = "$([char]27)[38;5;51m",

        [Parameter(HelpMessage = "Specify what shape to use for the progress bar.")]
        [ValidateSet("Box", "Block", "Circle")]
        [string]$BarSymbol = "Box",

        [Parameter(HelpMessage = "Specify the cursor position")]
        [System.Management.Automation.Host.Coordinates]$Position = $host.UI.RawUI.CursorPosition,

        [Parameter(HelpMessage = "Write to the host not the pipeline")]
        [switch]$ToHost
        )

    Begin {
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Starting $($MyInvocation.MyCommand)"

        #Validate the progress color. The normal parameter validation techniques don't like the regex pattern
        if ( -Not [regex]::IsMatch($ProgressColor, "$([char]27)\[\d+[\d;]+m")) {
            Throw "You entered an invalid ANSI escape sequence"
        }
        #the closing ANSI sequence
        $end = "$([char]27)[0m"

        #a length of 50 is the max or 100%
        $max = 50
        Switch ($BarSymbol) {
            "box" { $block = [char]9632 }
            "block" { $block = [char]9608}
            "circle" { $block = [char]9679 }
        }

        #these values will be used to set the progress bar position
        $x = $position.x
        #modified July 12, 2024 to not add an extra line
        $y = $position.y #+ 1
        #may need to insert a line in case we are at the bottom of a console or terminal screen
        if ($env:WT_SESSION -AND ($position.y + 1 -ge $host.UI.RawUI.BufferSize.Height)) {
            #Write-Output "`n"
            Write-Host "`n"
        }
    } #begin

    Process {
        If ($host.Name -match "PowerShell ISE") {
            Write-Warning "This command will not work in the PowerShell ISE."
            #bail out
            return
        }
        Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] $PercentComplete %"
        [int]$len = $max * $PercentComplete
        #get current cursor position if in Windows Terminal
        if ($env:WT_SESSION -AND ($position.y + 1 -ge $host.UI.RawUI.BufferSize.Height)) {
            $y = $host.UI.RawUI.CursorPosition.Y-1
        }
        [System.Console]::SetCursorPosition($x, $y)
        #align and pad the percentage value
        $pct = "$($percentComplete*100)%".PadLeft(4)
        #Modified June 27, 2024 to write to the host so progress isn't part of any command output
        if ($ToHost) {
            Write-Host "$pct $ProgressColor$($($Block.ToString())*$len)$End"
        } else {
            Write-Output "$pct $ProgressColor$($($Block.ToString())*$len)$End"
        }
    } #process

    End {
        Write-Verbose "[$((Get-Date).TimeOfDay) END    ] Ending $($MyInvocation.MyCommand)"
    } #end

} #close Write-ANSIProgress
