Function Show-ANSISequence {
    [cmdletbinding(DefaultParameterSetName = "basic")]
    [outputtype([system.string])]

    Param(
        [Parameter(ParameterSetName = "basic", HelpMessage = "Display basic ANSI escape sequences. This is the default setting.")]
        [switch]$Basic,
        [Parameter(ParameterSetName = "foreback", HelpMessage = "Display foreground ANSI escape sequences")]
        [switch]$Foreground,
        [Parameter(ParameterSetName = "foreback", HelpMessage = "Display background ANSI escape sequences")]
        [switch]$Background,
        [Parameter(ParameterSetName = "foreback")]
        [ValidateSet("All", "Simple", "8Bit")]
        [string]$Type = "All",
        [Parameter(ParameterSetName = "RGB", HelpMessage = "Specify an array of RGB values between 0 and 255")]
        [int[]]$RGB,
        [Parameter(HelpMessage = "Show the value as an unformatted string")]
        [switch]$AsString
    )

    Write-Verbose "Starting $($myinvocation.MyCommand)"
    Write-Debug "Using parameter set $($PSCmdlet.ParameterSetName)"
    Write-Debug "Bound parameters"
    $PSBoundParameters | Out-String | Write-Debug

    #default to Basic even if the user doesn't specify the -Basic parameter
    if ($PSCmdlet.parametersetname -eq 'basic') {
        $Basic = $True
    }
    elseif ($PSCmdlet.parametersetname -eq 'foreback') {
        if ( (-Not ($PSBoundParameters.ContainsKey('foreground'))) -OR (-Not ($PSBoundParameters.ContainsKey('background')))) {
            #default to foreground Issue # 110
            Write-Debug "Setting Foreground as default"
            $Foreground = $True
        }

    }

    # a private function to display results in columns on the screen
    Function display {
        Param([object]$all, [int]$Max)

        $c = 1
        [string]$row = ""

        for ($i = 0; $i -le $all.count; $i++) {
            if ($c -gt $max) {
                $row
                $c = 1
                $row = ""
            }
            else {
                $row += "$($all[$i]) `t"
                $c++
            }
        }
    }

    if ($IsCoreCLR) {
        Write-Debug "CoreCLR"
        $esc = "`e"
        $escText = '`e'
        $max = 3
    }
    else {
        Write-Debug "Desktop"
        $esc = $([char]27)
        $escText = '$([char]27)'
        $max = 2
    }

    #region basic
    if ($basic) {
        Write-Debug "Get basic settings"
        Add-Border "Basic Sequences" -ANSIText "$esc[1m" | Write-Host

        $basichash = @{
            1 = "Bold"
            2 = "Faint"
            3 = "Italic"
            4 = "Underline"
            5 = "SlowBlink"
            6 = "RapidBlink"
            7 = "Reverse"
            9 = "CrossedOut"
        }

        $basichash.GetEnumerator() | ForEach-Object {
            $sequence = "$esctext[$($_.name)m$($_.value)$esctext[0m"
            if ($AsString) {
                $sequence
            }
            else {
                "$esc[$($_.name)m$sequence$esc[0m"
            }
        }
    }
    #endregion

    #region foreground

    If ($Foreground) {
        Write-Debug "Getting foreground"
        if ($Type -match "All|Simple") {
            Add-Border "Foreground" -ANSIText "$esc[93m" | Write-Host
            $n = 30..37
            $n += 90..97

            $all = $n | ForEach-Object {
                $sequence = "$esctext[$($_)mHello$esctext[0m"
                if ($AsString) {
                    $sequence
                }
                else {
                    "$esc[$($_)m$sequence$esc[0m"
                }
            }

            display -all $all -Max $max

            Write-Host "`n"
        }
        if ($Type -match "All|8bit") {
            Add-Border "8-Bit Foreground" -ANSIText "$esc[38;5;10m" | Write-Host
            $all = 1..255 | ForEach-Object {
                $sequence = "$esctext[38;5;$($_)mHello$esctext[0m"
                if ($AsString) {
                    $sequence
                }
                else {
                    "$esc[38;5;$($_)m$sequence$esc[0m"
                }
            }
            display -all $all -Max $max
        }
    }
    #endregion

    #region background
    If ($Background) {
        Write-Debug "Getting background"
        if ($Type -match "All|Simple") {
            Add-Border "Background" -ANSIText "$esc[46m" | Write-Host
            $n = 40..47
            $n += 100..107
            $all = $n | ForEach-Object {
                $sequence = "$esctext[$($_)mHello$esctext[0m"
                if ($AsString) {
                    $sequence
                }
                else {
                    "$esc[1;$($_)m$sequence$esc[0m"
                }
            }

            display -all $all -Max $max

            Write-Host "`n"
        }

        if ($Type -match "All|8bit") {
            Add-Border "8-Bit Background" -ANSIText "$esc[7;38;5;10m" | Write-Host
            $all = 1..255 | ForEach-Object {
                $sequence = "$esctext[48;5;$($_)mHello$esctext[0m"
                if ($AsString) {
                    $sequence
                }
                else {
                    "$esc[1;48;5;$($_)m$sequence$esc[0m"
                }
            }
            display -all $all -Max $max
        }
    }

    #endregion

    #region RGB

    if ($RGB) {
        Write-Debug "Using RBG values"
        if ($rgb.count -ne 3) {
            Write-Warning "Wrong number of arguments. Specify RED,GREEN and BLUE values"
            return
        }
        $test = $rgb | Where-Object { $_ -gt 255 }
        if ($test.count -gt 0) {
            Write-Warning "Detected a value above 255"
            return $rgb
        }

        $r = $rgb[0]
        $g = $rgb[1]
        $b = $rgb[2]

        Write-Host "`r"
        $sequence = "$esctext[38;2;$r;$g;$($b)m256 Color (R:$r)(G:$g)(B:$b)$esctext[0m"
        if ($AsString) {
            $sequence
        }
        else {
            "$esc[38;2;$r;$g;$($b)m$sequence$esc[0m"
        }

    }
    #endregionm

    #insert a blank line to set off the results
    Write-Host "`r"

    Write-Verbose "Ending $($myinvocation.MyCommand)"
}