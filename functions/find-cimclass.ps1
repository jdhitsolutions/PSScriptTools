
#search WMI for a class
Function Find-CimClass {
    [CmdletBinding()]
    [alias('fcc')]
    [OutputType([Microsoft.Management.Infrastructure.CimClass])]

    Param(
        [Parameter(Position = 0, Mandatory, HelpMessage = 'Enter the name of a CIM/WMI class. Wildcards are permitted.')]
        [ValidateNotNullOrEmpty()]
        [string]$ClassName,

        [Parameter(HelpMessage = 'Enter a pattern for class names to EXCLUDE from the results. You can use wildcards or regular expressions.')]
        [SupportsWildcards()]
        [string]$Exclude,

        [Parameter(ValueFromPipeline, HelpMessage = 'Specify a computer name or an existing CimSession object.')]
        [ValidateNotNullOrEmpty()]
        [Alias('CN')]
        [CimSession]$CimSession = $ENV:COMPUTERNAME
    )

    Write-Verbose "[$((Get-Date).TimeOfDay)] Starting $($MyInvocation.MyCommand)"

    #the command requires CIM cmdlets which won't work on non-Windows platforms.

    if ((Test-IsPSWindows)) {

        #initialize variables for the CimSession connection
        New-Variable -Name ci
        New-Variable -Name ce

        #define a hashtable of parameters to splat to Write-Progress
        $progParams = @{
            Activity         = $MyInvocation.MyCommand
            PercentComplete  = 0
            Status           = "Enumerating namespaces on $($CimSession.ComputerName.ToUpper())"
            CurrentOperation = 'Validating connection'
        }

        Write-Progress @progParams
        if ($CimSession.TestConnection([ref]$ci, [ref]$ce)) {
            $progParams.CurrentOperation = 'Building namespace list'
            #build a list of namespaces
            $namespaces = Get-CimNamespace -CimSession $CimSession | Sort-Object

            #enumerate namespaces and search for the class
            Write-Verbose "[$((Get-Date).TimeOfDay)] Searching for class $ClassName"
            if ($Exclude) {
                Write-Verbose "[$((Get-Date).TimeOfDay)] Using an exclude pattern of $Exclude"
            }
            $i = 0
            foreach ($ns in $namespaces) {
                $i++
                $pct = ($i / $namespaces.count) * 100
                $progParams.PercentComplete = $pct
                $progParams.Status = "Searching for class $ClassName in $($namespaces.count) namespaces"
                $progParams.CurrentOperation = "processing \\$($CimSession.ComputerName.ToUpper())\$ns"
                Write-Progress @progParams
                Write-Verbose "[$((Get-Date).TimeOfDay)] Searching namespace $ns"
                Try {
                    $classes = $CimSession.EnumerateClasses($ns,"").where({$_.CimClassName -like $ClassName})
                    if ($classes -AND $Exclude) {
                        $classes.Where( { $_.cimClassName -notmatch $Exclude }) | Sort-Object -Property CimClassName
                    }
                    else {
                        $classes | Sort-Object -Property CimClassName
                    }
                }
                Catch {
                    #ignore error if class not found
                }
            } #foreach ns
        }
        else {
            Write-Warning "Unable to connect to $($CimSession.ComputerName.ToUpper())"
        }
    }
    else {
        Write-Warning 'This command requires a Windows platform.'
    }
    Write-Verbose "[$((Get-Date).TimeOfDay)] Ending $($MyInvocation.MyCommand)"

} #close function