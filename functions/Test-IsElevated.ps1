function Test-IsElevated {
    [cmdletbinding()]
    [OutputType('Boolean')]
    [Alias('isAdmin')]
    param()

    #tags are used for categorizing the command
    #cmdTags = scripting

    Write-Verbose "Starting $($MyInvocation.MyCommand)"
    Write-Verbose "Running under PowerShell version $($PSVersionTable.PSVersion)"

    if ($ISWindows -or $PSEdition -eq 'Desktop') {
        Write-Verbose 'Windows detected'
        $user = [Security.Principal.WindowsIdentity]::GetCurrent();
        (New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
    }
    else {
        Write-Verbose 'Non-Windows detected'
        #Assuming the same non-Windows code works until someone gives me feedback
        if ( (id -u) -eq 0) { $True } else { $False }
    }
    Write-Verbose "Ending $($MyInvocation.MyCommand)"
}
#EOF
