#This assumes you've already created a PowerShell Remoting session
#You must use a PSSession

#get the locally loaded function
# $f = $(Get-Item function:\Get-Foo).scriptblock

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
        [ValidateNotNullOrEmpty()]
        [string[]]$Name,
        [Parameter(Mandatory, HelpMessage = "Specify an existing PSSession")]
        [System.Management.Automation.Runspaces.PSSession]$Session,
        [switch]$Force
    )
    Begin {
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Starting $($MyInvocation.MyCommand)"
    } #begin

    Process {
        foreach ($item in $Name) {
            #verify the function Exists
            $funPath = Join-Path -Path Function: -ChildPath $item
            Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Validating $funPath"
            if (Test-Path -Path $funPath) {
                    Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Copying $item to $($session.computername)"
                    $f = $(Get-Item -Path $funPath).scriptblock
                    Invoke-Command -scriptblock { New-Item -Name $using:item -Path Function: -Value $($using:f) -force:$using:force} -session $Session

                } #if Test-Path
                Else {
                    Write-Warning "Can't find a local function called $item."
                }

            } #foreach item

        } #process

        End {
            Write-Verbose "[$((Get-Date).TimeOfDay) END    ] Ending $($MyInvocation.MyCommand)"

        } #end

    } #close Copy-PSFunction