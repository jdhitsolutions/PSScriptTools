Function Test-IsPSWindows {
    [cmdletbinding()]
    [OutputType([Boolean])]
    Param( )
    Begin {
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Starting $($MyInvocation.MyCommand)"

    } #begin

    Process {
        if ($isWindows) {
            $True
        }
        elseif ($PSEdition -eq 'Desktop') {
            $True
        }
        else {
            $False
        }

    } #process

    End {
        Write-Verbose "[$((Get-Date).TimeOfDay) END    ] Ending $($MyInvocation.MyCommand)"

    } #end

} #close Test-IsPSWindows