Function New-ANSIBar {
    [cmdletbinding(DefaultParameterSetName = "standard")]
    [alias('nab')]
    [OutputType([System.String])]

    Param(
        [Parameter(Mandatory, HelpMessage = "Enter a range of 256 color values, e.g. (232..255)")]
        [ValidateNotNullOrEmpty()]
        [int[]]$Range,
        [Parameter(HelpMessage = "How many characters do you want in the bar of each value? This will increase the overall length of the bar.")]
        [int]$Spacing = 1,
        [Parameter(ParameterSetName = "standard", HelpMessage = "Specify a character to use for the bar.")]
        [ValidateSet("FullBlock", "LightShade", "MediumShade", "DarkShade", "BlackSquare", "WhiteSquare")]
        [string]$Character = "FullBlock",
        [Parameter(ParameterSetName = "custom", HelpMessage = "Specify a custom character.")]
        [char]$Custom,
        [Parameter(HelpMessage = "Display as a single gradient from the first value to the last.")]
        [switch]$Gradient
    )

    Write-Verbose "Starting $($MyInvocation.MyCommand)"
    Write-Verbose "Using parameter set $($PSCmdlet.ParameterSetName)"

    if ($PSCmdlet.ParameterSetName -eq "Standard") {
        Write-Verbose "Using standard character $character"
        Switch ($Character) {
            "FullBlock" {
                $ch = $([char]0x2588)
            }
            "LightShade" {
                $ch = $([char]0x2591)
            }
            "MediumShade" {
                $ch = $([char]0x2592)
            }
            "DarkShade" {
                $ch = $([char]0x2593)
            }
            "BlackSquare" {
                $ch = $([char]0x25A0)
            }
            "WhiteSquare" {
                $ch = [char]0x25A1
            }
        }
    }
    else {
        Write-Verbose "Using custom character $custom (which may not display here)"
        $ch = $Custom
    }
    $esc = "$([char]0x1b)"
    $out = @()
    $blank = "$($ch)"*$spacing

    if ($Gradient) {
        Write-Verbose "Creating gradient ANSI bar from $($range[0]) to $($range[-1])"
        $out += $range | ForEach-Object { "$esc[38;5;$($_)m$($blank)$esc[0m" }
    }
    else {
        Write-Verbose "Creating standard ANSI bar from $($range[0]) to $($range[-1])"
        $out += $range | ForEach-Object {
            "$esc[38;5;$($_)m$($blank)$esc[0m"
        }

        $out += $range | Sort-Object -Descending | ForEach-Object {
            "$esc[38;5;$($_)m$($blank)$esc[0m"
        }
    }
    $out -join ""

    Write-Verbose "Starting $($MyInvocation.MyCommand)"

} #close function