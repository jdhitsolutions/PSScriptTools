
Function Get-CimClassProperty {
    [cmdletbinding(DefaultParameterSetName = 'property')]
    [OutputType('CimClassProperty')]
    Param(
        [Parameter(
            Position = 0,
            Mandatory,
            ValueFromPipeline,
            HelpMessage = 'Specify a CIM Class'
        )]
        [ArgumentCompleter({
                #argument completer uses local classes to populate the list
                param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
                if ($fakeBoundParameters.NameSpace -match '^root') {
                    (Get-CimClass -Namespace $fakeBoundParameters.NameSpace ).Where({ $_.CimClassName -notMatch '^__' }).CimClassName | Where-Object { $_ -like "*$wordToComplete*" }
                }
                else {
                    (Get-CimClass -Namespace 'Root\Cimv2').Where({ $_.CimClassName -notMatch '^__' }).CimClassName | Where-Object { $_ -like "*$wordToComplete*" }
                }
            })]
        [ValidateNotNullOrEmpty()]
        [string]$ClassName,

        [Parameter(HelpMessage = 'Specify the class namespace beginning with ROOT')]
        [ValidateNotNullOrEmpty()]
        [ValidatePattern('^Root\\')]
        [Alias('NS')]
        [string]$Namespace = 'Root\Cimv2',

        [Parameter(ParameterSetName = 'property', HelpMessage = 'Specify a property name. Wildcards are permitted.')]
        [ValidateNotNullOrEmpty()]
        [SupportsWildcards()]
        [string]$Property = '*',

        [Parameter(ParameterSetName = 'key', HelpMessage = 'Only show Key properties')]
        [switch]$KeyOnly,

        [Parameter(ValueFromPipeline, HelpMessage = 'Specify a computer name or an existing CimSession object.')]
        [ValidateNotNullOrEmpty()]
        [Alias('CN')]
        [CimSession]$CimSession = $ENV:COMPUTERNAME
    )

    Begin {
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Starting $($MyInvocation.MyCommand)"
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Running under PowerShell version $($PSVersionTable.PSVersion)"
        #initialize a list for output. I want to write sorted output to the pipeline.
        $out = [System.Collections.Generic.List[object]]::new()

        #initialize variables for the CimSession connection
        New-Variable -Name ci
        New-Variable -Name ce
    } #begin

    Process {
        if ($CimSession.TestConnection([ref]$ci, [ref]$ce)) {
            Try {
                Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Querying properties for $ClassName on $($CimSession.ComputerName.ToUpper())"
                $rawClass = $CimSession.GetClass($Namespace, $ClassName)
            }
            Catch {
                Throw $_
            }
            if ($PSCmdlet.ParameterSetName -eq 'property') {
                Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Filtering by property $Property"
                $rawProperties = ($rawClass.CimClassProperties).Where({ $_.name -like $Property })
            }
            else {
                Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Filtering by key property"
                $rawProperties = ($rawClass.CimClassProperties).Where({ $_.flags -match 'Key' })
            }
            Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Found $($rawProperties.count) matching properties"
            foreach ($item in $rawProperties) {
                $isKey = $item.Flags -match 'Key'
                If (($KeyOnly -AND $IsKey) -OR (-Not $KeyOnly)) {
                    $result = [PSCustomObject]@{
                        PSTypeName = 'CimClassProperty'
                        Namespace  = $rawClass.CimSystemProperties.Namespace
                        ClassName  = $rawClass.CimSystemProperties.ClassName
                        Property   = $item.Name
                        ValueType  = $item.CimType
                        IsKey      = $isKey      #hidden in default table format
                        Flags      = $item.Flags
                    }
                    $out.Add($result)
                } #if
            } #foreach item
        }
        else {
            Write-Warning "Unable to connect to $($CimSession.ComputerName.ToUpper()). $($ce.Message)"
        }
    } #process

    End {
        if ($out.Count -gt 0) {
            $out | Sort-Object -Property Property
        }
        else {
            Write-Verbose "[$((Get-Date).TimeOfDay) END    ] No matching properties detected"
        }
        Write-Verbose "[$((Get-Date).TimeOfDay) END    ] Ending $($MyInvocation.MyCommand)"
    } #end

} #close Get-CimClassProperty

Function Get-CimClassPropertyQualifier {
    [cmdletbinding()]
    [OutputType('cimClassPropertyQualifier')]
    Param(
        [Parameter(
            Position = 0,
            Mandatory,
            ValueFromPipeline,
            HelpMessage = 'Specify a CIM Class'
        )]
        [ArgumentCompleter({
                param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
                if ($fakeBoundParameters.NameSpace -match '^root') {
                    (Get-CimClass -Namespace $fakeBoundParameters.NameSpace ).Where({ $_.CimClassName -notMatch '^__' }).CimClassName | Where-Object { $_ -like "$wordToComplete*" }
                }
                else {
                    (Get-CimClass -Namespace 'Root\Cimv2').Where({ $_.CimClassName -notMatch '^__' }).CimClassName | Where-Object { $_ -like "$wordToComplete*" }
                }
            })]
        [ValidateNotNullOrEmpty()]
        [string]$ClassName,

        [Parameter(HelpMessage = 'Specify a property name. Wildcards are permitted.')]
        [ValidateNotNullOrEmpty()]
        [SupportsWildcards()]
        [string]$Property = "*",

        [Parameter(HelpMessage = 'Specify the class namespace beginning with ROOT')]
        [ValidateNotNullOrEmpty()]
        [ValidatePattern('^Root\\')]
        [Alias('NS')]
        [string]$Namespace = 'Root\Cimv2',

        [Parameter(ValueFromPipeline, HelpMessage = 'Specify a computer name or an existing CimSession object.')]
        [ValidateNotNullOrEmpty()]
        [Alias('CN')]
        [CimSession]$CimSession = $ENV:COMPUTERNAME
    )

    Begin {
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Starting $($MyInvocation.MyCommand)"
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Running under PowerShell version $($PSVersionTable.PSVersion)"

        #initialize variables for the CimSession connection
        New-Variable -Name ci
        New-Variable -Name ce
    } #begin

    Process {
        if ($CimSession.TestConnection([ref]$ci, [ref]$ce)) {
            Try {
                Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Getting property information from $ClassName on $($CimSession.ComputerName.ToUpper())"
                $rawClass = $CimSession.GetClass($Namespace, $ClassName)
                $rawProperty = $CimSession.GetClass($Namespace, $ClassName).CimClassProperties.Where({$_.Name -like $Property})
            }
            Catch {
                Throw $_
            }
            If ($null -eq $rawProperty) {
                $msg = 'Failed to find a property called {0} on {1}:{2}' -f $property, $Namespace, $ClassName.ToUpper()
                Write-Warning $msg
            }
            else {
                Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Found $($rawProperty.count) matching properties"

                Foreach ($item in $rawProperty) {
                    Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Found $($item.Qualifiers.count) qualifiers for $($item.Name)"
                    foreach ($q in $item.Qualifiers) {
                        [PSCustomObject]@{
                            PSTypeName = 'cimClassPropertyQualifier'
                            Namespace  = $rawClass.CimSystemProperties.Namespace
                            ClassName  = $rawClass.CimClassName
                            Property   = $item.Name
                            Name       = $q.Name
                            Value      = $q.Value
                            CimType    = $q.CimType
                            Flags      = $q.Flags
                        }
                    } #foreach q
                } #foreach item
            }
        }
        else {
            Write-Warning "Unable to connect to $($CimSession.ComputerName.ToUpper()). $($ce.Message)"
        }
    } #process

    End {
        Write-Verbose "[$((Get-Date).TimeOfDay) END    ] Ending $($MyInvocation.MyCommand)"
    } #end

} #close Get-CimClassPropertyQualifier

Function Get-CimClassMethod {
    [cmdletbinding()]
    [OutputType('CimClassMethod')]
    Param(
        [Parameter(
            Position = 0,
            Mandatory,
            ValueFromPipeline,
            HelpMessage = 'Specify a CIM Class'
        )]
        [ArgumentCompleter({
                param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
                if ($fakeBoundParameters.NameSpace -match '^root') {
                    (Get-CimClass -Namespace $fakeBoundParameters.NameSpace ).Where({ $_.CimClassName -notMatch '^__' }).CimClassName | Where-Object { $_ -like "$wordToComplete*" }
                }
                else {
                    (Get-CimClass -Namespace 'Root\Cimv2').Where({ $_.CimClassName -notMatch '^__' }).CimClassName | Where-Object { $_ -like "$wordToComplete*" }
                }
            })]
        [ValidateNotNullOrEmpty()]
        [string]$ClassName,

        [Parameter(HelpMessage = 'Specify a method name. Wildcards are permitted.')]
        [ValidateNotNullOrEmpty()]
        [SupportsWildcards()]
        [alias('Name')]
        [string]$Method = '*',

        [Parameter(HelpMessage = 'Specify the class namespace beginning with ROOT')]
        [ValidateNotNullOrEmpty()]
        [ValidatePattern('^Root\\')]
        [Alias('NS')]
        [string]$Namespace = 'Root\Cimv2',

        [Parameter(ValueFromPipeline, HelpMessage = 'Specify a computer name or an existing CimSession object.')]
        [ValidateNotNullOrEmpty()]
        [Alias('CN')]
        [CimSession]$CimSession = $ENV:COMPUTERNAME
    )

    Begin {
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Starting $($MyInvocation.MyCommand)"
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Running under PowerShell version $($PSVersionTable.PSVersion)"
        #initialize a list for output. I want to write sorted output to the pipeline.
        $out = [System.Collections.Generic.List[object]]::new()

        #initialize variables for the CimSession connection
        New-Variable -Name ci
        New-Variable -Name ce
    } #begin

    Process {
        if ($CimSession.TestConnection([ref]$ci, [ref]$ce)) {
            Try {
                Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Processing CimClass $($PSBoundParameters['ClassName']) from $Namespace on $($CimSession.ComputerName.ToUpper())"
                $rawClass = $CimSession.GetClass($Namespace, $PSBoundParameters['ClassName'])
                $Methods = ($rawClass.CimClassMethods).where({ $_.Name -like $Method })
                if ($methods.count -gt 0) {
                    Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Found $($methods.count) methods"
                    foreach ($methodItem in $Methods) {
                        $result = [PSCustomObject]@{
                            PSTypeName = 'CimClassMethod'
                            Namespace  = $rawClass.CimSystemProperties.Namespace
                            ClassName  = $rawClass.CimSystemProperties.ClassName
                            Name       = $methodItem.Name
                            ResultType = $methodItem.ReturnType
                            Parameters = $methodItem.Parameters
                        }
                        $out.Add($result)
                    } #foreach methodItem
                } #if methods.count > 0
                else {
                    $msg = 'No methods found for {0}:{1}' -f $Namespace, $PSBoundParameters['ClassName'].ToString().ToUpper()
                    Write-Warning $msg
                }
            } #Try
        Catch {
            Throw $_
        }
    } #if connected
        else {
            Write-Warning "Unable to connect to $($CimSession.ComputerName.ToUpper()). $($ce.Message)"
        }

    } #process

    End {
        if ($out.Count -gt 0) {
            $out | Sort-Object -Property Name
        }
        Write-Verbose "[$((Get-Date).TimeOfDay) END ] Ending $($MyInvocation.MyCommand)"
    } #end

} #close Get-CimClassMethod

Function Get-CimNamespace {
    [cmdletbinding()]
    [OutputType([System.String])]

    Param(
        [Parameter(
            Position = 0,
            HelpMessage = 'Specify the root namespace to query. The default is ROOT.'
        )]
        [ValidateNotNullOrEmpty()]
        [string]$Namespace = 'Root',

        [Parameter(HelpMessage = 'Only list the top-level namespaces under the specified namespace.')]
        [switch]$TopLevelOnly,

        [Parameter(ValueFromPipeline, HelpMessage = 'Specify a computer name or an existing CimSession object.')]
        [ValidateNotNullOrEmpty()]
        [Alias('CN')]
        [CimSession]$CimSession = $ENV:COMPUTERNAME
    )

    Begin {
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN ] Starting $($MyInvocation.MyCommand)"

        #define a private function to do the heavy lifting
        function _enumspace {
            [cmdletbinding()]
            Param(
                [CimSession]$CimSession,
                [string]$Namespace,
                [switch]$TopLevelOnly
            )
            $CimSession.EnumerateInstances($Namespace, '__Namespace') | ForEach-Object {
                $child = Join-Path -Path $Namespace -ChildPath $_.Name
                if ($child) {
                    $child
                    if (-Not $TopLevelOnly) {
                        Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Recursing to $child"
                        $PSBoundParameters.namespace = $child
                        _enumspace @PSBoundParameters
                    }
                }
            } #foreach-object
        } #close function

        New-Variable -Name ci
        New-Variable -Name ce
    } #begin
    Process {
        if ($CimSession.TestConnection([ref]$ci, [ref]$ce)) {
            Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Querying namespaces under $Namespace on $($CimSession.ComputerName.ToUpper())."

            #invoke the private helper function$
            _enumspace -CimSession $CimSession -Namespace $Namespace -TopLevelOnly:$TopLevelOnly
        }
        else {
            Write-Warning "Unable to connect to $($CimSession.ComputerName.ToUpper()). $($ce.Message)"
        }
    } #process
    End {
        Write-Verbose "[$((Get-Date).TimeOfDay) END ] Ending $($MyInvocation.MyCommand)"
    } #end
} #close function

Function Get-CimMember {
    [cmdletbinding(DefaultParameterSetName = 'property')]
    [OutputType('CimClassProperty', ParameterSetName = 'property')]
    [OutputType('CimClassMethod', ParameterSetName = 'method')]
    [Alias('cmm')]
    Param(
        [Parameter(

            Mandatory,
            ValueFromPipelineByPropertyName,
            HelpMessage = 'Specify a CIM Class'
        )]
        [Parameter(ParameterSetName = 'property', Position = 0)]
        [Parameter(ParameterSetName = 'method', Position = 0)]
        [ArgumentCompleter({
                param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
                if ($fakeBoundParameters.NameSpace -match '^root') {
                (Get-CimClass -Namespace $fakeBoundParameters.NameSpace ).Where({ $_.CimClassName -notMatch '^__' }).CimClassName | Where-Object { $_ -like "$wordToComplete*" }
                }
                else {
                (Get-CimClass -Namespace 'Root\Cimv2').Where({ $_.CimClassName -notMatch '^__' }).CimClassName | Where-Object { $_ -like "$wordToComplete*" }
                }
            })]
        [Alias('CimClassName')]
        [ValidateNotNullOrEmpty()]
        [string]$ClassName,

        [Parameter(ParameterSetName = 'property', HelpMessage = 'Specify a property name. Wildcards are permitted.')]
        [ValidateNotNullOrEmpty()]
        [SupportsWildcards()]
        [string]$Property = '*',

        [Parameter(Mandatory, ParameterSetName = 'method', HelpMessage = 'Specify a method name. Wildcards are permitted.')]
        [ValidateNotNullOrEmpty()]
        [SupportsWildcards()]
        [alias('Name')]
        [string]$Method,

        [Parameter(HelpMessage = 'Specify the class namespace beginning with ROOT')]
        [ValidateNotNullOrEmpty()]
        [ValidatePattern('^Root\\')]
        [Alias('NS')]
        [string]$Namespace = 'Root\Cimv2',

        [Parameter(ValueFromPipeline, HelpMessage = 'Specify a computer name or an existing CimSession object.')]
        [ValidateNotNullOrEmpty()]
        [Alias('CN')]
        [CimSession]$CimSession = $ENV:COMPUTERNAME
    )

    Begin {
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN ] Starting $($MyInvocation.MyCommand)"
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN ] Running under PowerShell version $($PSVersionTable.PSVersion)"
    } #begin

    Process {
        Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Processing parameter set $($PSCmdlet.ParameterSetName)"
        Switch ($PSCmdlet.ParameterSetName) {
            'property' {
                Get-CimClassProperty -Namespace $Namespace -ClassName $ClassName -Property $Property -CimSession $CimSession
            }
            'method' {
                Get-CimClassMethod -Namespace $Namespace -ClassName $ClassName -Method $Method -CimSession $CimSession
            }
        } #switch $PSCmdlet.ParameterSetName
    } #process

    End {
        Write-Verbose "[$((Get-Date).TimeOfDay) END ] Ending $($MyInvocation.MyCommand)"
    } #end

} #close Get-CimMember

Function Get-CimClassListing {
    [cmdletbinding()]
    [OutputType('cimClassListing')]
    Param(
        [Parameter(Position = 0,HelpMessage = 'Enter a pattern for class names. You can use wildcards.')]
        [SupportsWildcards()]
        [ValidateNotNullOrEmpty()]
        [string]$Name="*",

        [Parameter(HelpMessage = 'Specify the class namespace beginning with Root')]
        [ValidateNotNullOrEmpty()]
        [ValidatePattern('^Root\\')]
        [Alias('NS')]
        [string]$Namespace = 'Root\Cimv2',

        [Parameter(HelpMessage = 'Enter a pattern for class names to EXCLUDE from the results. You can use wildcards.')]
        [SupportsWildcards()]
        [ValidateNotNullOrEmpty()]
        [string]$Exclude,

        [Parameter(ValueFromPipeline, HelpMessage = 'Specify a computer name or an existing CimSession object.')]
        [ValidateNotNullOrEmpty()]
        [Alias('CN')]
        [CimSession]$CimSession = $ENV:COMPUTERNAME
    )

    Begin {
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Starting $($MyInvocation.MyCommand)"
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Running under PowerShell version $($PSVersionTable.PSVersion)"
        #initialize variables for the CimSession connection
        New-Variable -Name ci
        New-Variable -Name ce

        $opt = [Microsoft.Management.Infrastructure.Options.CimOperationOptions]::new()
        $opt.ClassNamesOnly = $True
    } #begin

    Process {
        if ($CimSession.TestConnection([ref]$ci, [ref]$ce)) {
            $CimSession.EnumerateClasses($Namespace,"").where({($_.CimClassName -Like $Name) -AND ($_.CimClassName -NotMatch "^__") -AND $_.CimClassName -NotLike $Exclude}) | ForEach-Object {
                [PSCustomObject]@{
                    PSTypeName = 'cimClassListing'
                    Namespace  = $_.CimSystemProperties.Namespace
                    ClassName  = $_.CimClassName
                }
            } | Sort-Object -Property ClassName
        }
        else {
            Write-Warning "Unable to connect to $($CimSession.ComputerName.ToUpper()). $($ce.Message)"
        }
    } #process

    End {
        Write-Verbose "[$((Get-Date).TimeOfDay) END    ] Ending $($MyInvocation.MyCommand)"
    } #end

} #close Get-CimClassListing

#ArgumentCompleters
#enum all namespaces when this script is dot-sources and save to temp text file
#using a threadjob when the module is imported to speed up the process
Start-ThreadJob {
    #this is a stripped down version of the private function _enumspace
    Function _enumNamespace {
        [cmdletbinding()]
        Param(
            [string]$Namespace = 'Root',
            [string]$ClassName = '__Namespace'
        )

        $splat = @{
            Namespace = $Namespace
            ClassName = $ClassName
        }
        Get-CimInstance @splat | ForEach-Object {
            $child = Join-Path -Path $Namespace -ChildPath $_.Name
            if ($child) {
                $child
                $splat.namespace = $child
                _enumNamespace @splat
            }
        } #foreach-object
    } #close function

    _enumNamespace | Out-File $env:TEMP\CimNamespaceList.txt
} | Out-Null

Register-ArgumentCompleter -CommandName Get-CimMember,Get-CimClassMethod, Get-CimClassProperty, Get-CimClassPropertyQualifier,Get-CimClassListing -ParameterName Namespace -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)

    $CimNamespaceList = Get-Content $env:TEMP\CimNamespaceList.txt
    #PowerShell code to populate $wordToComplete
    ($CimNamespaceList).Where({ $_ -like "*$wordToComplete*" }) |
    ForEach-Object {
        [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
    }
}
