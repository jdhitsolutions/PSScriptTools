Function Test-IsPSWindows {
    [cmdletbinding()]
    [outputtype([Boolean])]
    Param( )
    Begin {
        Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] Starting $($myinvocation.mycommand)"

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
        Write-Verbose "[$((Get-Date).TimeofDay) END    ] Ending $($myinvocation.mycommand)"

    } #end

} #close Test-IsPSWindows