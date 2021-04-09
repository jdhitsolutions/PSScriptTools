
Function Get-MyVariable {

    [cmdletbinding()]
    [OutputType([System.Management.Automation.PSVariable])]
    [Alias("gmv")]

    Param(
        [Parameter(Position = 0)]
        [ValidateSet("Global", "Local", "Script", "Private", 0, 1, 2, 3)]
        [ValidateNotNullOrEmpty()]
        [string]$Scope = "Global",
        [switch]$NoTypeInformation
    )

    Write-Verbose "Getting system defined variables"
    #get all global variables from the initial session state

    $PSVariables = [system.collections.generic.list[string]]::New()
    ((Get-Runspace 1).initialsessionstate.variables.name).foreach( { $PSVariables.Add($_) })

    Write-Verbose "Found $($psvariables.count) initial state variables"

    $skip = '?', 'args','ConsoleFileName', 'Error', 'esc',
    'ExecutionContext', 'false', 'HOME', 'Host', 'input', 'MaximumAliasCount',
    'MaximumDriveCount', 'MaximumErrorCount', 'MaximumFunctionCount', 'MaximumHistoryCount',
    'MaximumVariableCount', 'MyInvocation', 'null', 'Passthru', 'PID', 'PROFILE',
    'PSBoundParameters', 'PSCommandPath', 'PSCulture', 'PSDefaultParameterValues', 'PSEdition',
    'PSGetPath', 'PSHOME', 'PSScriptRoot', 'PSUICulture', 'PSVersionTable',
    'PWD', 'ShellId', 'true', 'verify', 'skip', 'scope', 'this', 'LastExitCode',
    '_', 'EnabledExperimentalFeatures'

    $skip.Foreach({ $PSVariables.Add($_) })

    #exclude variables defined by the PSScriptTools module
    $modVar = "PSAnsiFileMap","PSSamplePath","PSSpecialChar"
    $modvar.Foreach({ $PSVariables.Add($_) })
    <#
          find all the variables where the name isn't in the variable we just created
          and also isn't a system variable generated after the shell has been running
          and also any from this function
        #>

    Write-Verbose "Getting current variables in $Scope scope"
    $variables = Get-Variable -Scope $Scope

    Write-Verbose "Found $($variables.count) variables"
    Write-Verbose "Filtering variables"

    #filter out some automatic variables
    $filtered = $variables | Where-Object { $psvariables -notcontains $_.name }

    if ($NoTypeInformation) {
        #write results with not object types
        $filtered
    }
    else {
        #add type information for each variable
        Write-Verbose "Adding value type"
        $filtered | Select-Object Name, Value, @{Name = "Type"; Expression = { $_.Value.GetType().Name } }
    }

    Write-Verbose "Finished getting my variables"


} #end function

