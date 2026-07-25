function Get-MyVariable {
    [cmdletbinding()]
    [OutputType('System.Management.Automation.PSVariable', 'System.Management.Automation.LocalVariable')]
    [alias('gmv')]

    param(
        [Parameter(Position = 0)]
        [ValidateSet('Global', 'Local', 'Script', 'Private', 0, 1, 2, 3)]
        [ValidateNotNullOrEmpty()]
        [string]$Scope = 'Global',
        [switch]$IncludeTypeInformation
    )

    #tags are used for categorizing the command
    #cmdTags = general,scripting
    Write-Verbose 'Getting system defined variables'

    #create Powershell runspace
    $ps = [powershell]::Create()
    [void]$ps.commands.AddCommand('Get-Variable')
    $out = $ps.invoke()
    $PSVariables = $out.name
    $ps.Dispose()

    Write-Verbose "Found $($PSVariables.count) default variables"

    <#
    find all the variables where the name isn't in the variable we just created
    and also isn't a system variable generated after the shell has been running
    and also any from this function
    #>

    Write-Verbose "Getting current variables in $Scope scope"
    $variables = Get-Variable -Scope $Scope
    Write-Verbose "Found $($variables.count) variables in scope: $scope"

    Write-Verbose 'Filtering variables'
    #define variables to also exclude. Some of will exist in scripting scopes
    $skip = 'LastExitCode', '_', 'PSScriptRoot',
    'skip', 'PSCmdlet', 'PSVariables', 'variables', 'Scope',
    'args', 'input', 'MyInvocation', 'Profile', 'PSBoundParameters',
    'PSCommandPath'

    $PSVariables += $skip
    $out = $variables.Where({ $PSVariables -notcontains $_.name })

    if ($IncludeTypeInformation) {
        Write-Verbose 'Adding type information'
        $out | Add-Member -MemberType ScriptProperty -Name Type -Value { $this.Value.GetType().Name } -Force
        $out
    }
    else {
        Write-Verbose 'Writing default variables to the pipeline'
        $out
    }

    Write-Verbose 'Finished getting my variables'

} #end function


#EOF
