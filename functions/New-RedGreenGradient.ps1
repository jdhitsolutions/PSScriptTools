
Function New-RedGreenGradient {
    [cmdletbinding()]
    [OutputType([System.String])]

    Param(
        [Parameter(Position = 0, HelpMessage = "Specify a percentage as a decimal value like .35")]
        [ValidateScript( {$_ -le 1})]
        [double]$Percent = 1,
        [Parameter(HelpMessage = "Specify a relative bar length. The smaller the number the longer the bar.")]
        [ValidateRange(2, 10)]
        [int]$Step = 5,
        [Parameter(HelpMessage = "Specify a character to use for the gradient bar")]
        [char]$Character = 0x2588
    )

    Write-Verbose "Starting $($MyInvocation.MyCommand)"
    $r = 255
    $g = 0
    Write-Verbose "Using a percentage of $Percent"
    [int]$max = $r*$Percent
    Write-Verbose "Using a calculated max value of $max"
    [string[]]$out = @()

    Write-Verbose "Looping from through with a step value of $step"
    for ($i = 0; $i -le $max; $i += $Step) {
        $out += "$([char]0x1b)[38;2;$r;$g;0m$Character$([char]0x1b)[0m"
        $r -= $Step
        $g += $Step
        if ($g -ge 256) {
            Write-Verbose "100% green has been reached"
            break
        }
    }

    Write-Verbose "Creating final ANSI gradient bar"
    $out -join ""

    Write-Verbose "Ending $($MyInvocation.MyCommand)"
} #end function

