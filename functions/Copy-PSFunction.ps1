#This assumes you've already created a PowerShell Remoting session
#You must use a PSSession

#get the locally loaded function
# $f = $(get-item function:\Get-Foo).scriptblock

#copy it to the remote session
# Invoke-Command { New-Item -Name Get-Foo -Path Function: -Value $($using:f)} -session $s

#now you can use it remotely
# Invoke-Command { Get-Foo } -session $s


Function Copy-PSFunction {
    [cmdletbinding()]
    [OutputType("Deserialized.System.Management.Automation.FunctionInfo")]
    [Alias("cpfun")]
    Param(
        [Parameter(Position = 1, Mandatory, ValueFromPipeline, HelpMessage = "Enter the name of a local function.")]
        [ValidateNotNullorEmpty()]
        [string[]]$Name,
        [Parameter(Mandatory, HelpMessage = "Specify an existing PSSession")]
        [System.Management.Automation.Runspaces.PSSession]$Session,
        [switch]$Force
    )
    Begin {
        Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] Starting $($myinvocation.mycommand)"
    } #begin

    Process {
        foreach ($item in $Name) {
            #verify the function Exists
            $funPath = Join-Path -path Function: -childpath $item
            Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Validating $funPath"
            if (Test-Path -path $funPath) {
                    Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Copying $item to $($session.computername)"
                    $f = $(Get-Item -path $funPath).scriptblock
                    Invoke-Command -scriptblock { New-Item -Name $using:item -Path Function: -Value $($using:f) -force:$using:force} -session $Session

                } #if Test-Path
                Else {
                    Write-Warning "Can't find a local function called $item."
                }

            } #foreach item

        } #process

        End {
            Write-Verbose "[$((Get-Date).TimeofDay) END    ] Ending $($myinvocation.mycommand)"

        } #end

    } #close Copy-PSFunction