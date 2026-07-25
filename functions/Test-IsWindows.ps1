function Test-IsPSWindows {
    [cmdletbinding()]
    [OutputType([Boolean])]
    param()
    begin {
        #tags are used for categorizing the command
        #cmdTags = scripting

        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Starting $($MyInvocation.MyCommand)"
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Running under PowerShell version $($PSVersionTable.PSVersion)"
    } #begin

    process {
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

    end {
        Write-Verbose "[$((Get-Date).TimeOfDay) END    ] Ending $($MyInvocation.MyCommand)"
    } #end

} #close Test-IsPSWindows
#EOF
