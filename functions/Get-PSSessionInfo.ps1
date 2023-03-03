# Get details about the current PowerShell session
Function Get-PSSessionInfo {
    [cmdletbinding()]
    [Alias("gsin")]
    [OutputType("PSSessionInfo")]
    Param()
    Begin {
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Starting $($MyInvocation.MyCommand)"
    } #begin

    Process {
        Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Getting information for PSSession $PID "

        $proc = Get-Process -Id $PID
        #get the command line from CIM if in Windows PowerShell
        if ($PSEdition -eq 'Desktop') {
            $cim = Get-CimInstance -ClassName Win32_process -Filter "processID = $pid" -Property CommandLine, ParentProcessID
            $cmd = $cim.CommandLine
            $parent = Get-Process -Id $cim.ParentProcessId
        }
        else {
            $cmd = $proc.CommandLine
            $parent = $proc.parent
        }

        [PSCustomObject]@{
            PSTypeName = "PSSessionInfo"
            ProcessID  = $PID
            Command    = $cmd
            Host       = $Host.Name
            Started    = $proc.StartTime
            PSVersion  = $PSVersionTable.PSVersion
            Elevated   = Test-IsElevated
            Parent     = $parent
        }

    } #process

    End {
        Write-Verbose "[$((Get-Date).TimeOfDay) END    ] Ending $($MyInvocation.MyCommand)"
    } #end

} #close Get-PSSessionInfo

#add script properties to the custom object
Update-TypeData -TypeName PSSessionInfo -MemberType ScriptProperty -MemberName Runtime -Value { (Get-Date) - $this.Started } -Force
Update-TypeData -TypeName PSSessionInfo -MemberType ScriptProperty -MemberName Memory -Value { (Get-Process -Id $this.ProcessID).WorkingSet / 1MB -AS [int32] } -Force
