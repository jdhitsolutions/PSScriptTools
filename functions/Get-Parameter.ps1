
Function Get-ParameterInfo {
    [cmdletbinding()]
    [OutputType('PSParameterInfo')]
    [alias('gpi')]

    Param(
        [Parameter(
            Position = 0,
            Mandatory,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName,
            HelpMessage = 'Enter a cmdlet name'
        )]
        [ValidateNotNullOrEmpty()]
        [Alias('name')]
        [string]$Command,
        [string]$Parameter
    )

    Begin {
        Write-Verbose "Starting $($MyInvocation.MyCommand)"
        #define the set of common parameters to exclude
        #I could get these from PowerShell but it is just as easy to list them
        $common = @(
            'Verbose',
            'Debug',
            'ErrorAction',
            'ErrorVariable',
            'WarningAction',
            'WarningVariable',
            'OutVariable',
            'OutBuffer',
            'WhatIf',
            'Confirm',
            'InformationAction',
            'InformationVariable',
            'PipelineVariable'
        )
    } #begin

    Process {
        Write-Verbose "Processing $command for parameter information"
        Try {
            #need to account that the command might be an alias (Issue #101). 1/21/2021 JDH
            $cmd = Get-Command -Name $command -ErrorAction Stop
            if ($cmd.CommandType -eq 'alias') {
                Write-Verbose "Resolving the alias $Command to $($cmd.ResolvedCommand)"
                $data = (Get-Command -Name $cmd.ResolvedCommand -ErrorAction 'Stop').parameters
            }
            else {
                $data = $cmd.parameters
            }
        }
        Catch {
            Write-Warning "Failed to find command $command"
        }

        # keep going if parameters were found
        # Explicitly calling base, to prevent .count from being shadowed
        #
        if ($data.PSBase.Count -gt 0) {

            #$data is a hash table
            if ($Parameter) {
                Write-Verbose "Getting parameter $Parameter"
                if ($data.ContainsKey( $Parameter)) {
                    $params = $Parameter
                }
                else {
                    Throw "Can't find a parameter called $Parameter."
                }
            }
            else {
                Write-Verbose 'Getting parameter all non-common parameters'
                $params = $data.keys | Where-Object { $common -NotContains $_ }
            }
            $count = ($params | Measure-Object).count
            #only keep going if non-common parameters were found
            Write-Verbose "Found $count non-common parameters for $command"

            if ($count -gt 0) {
                #get information from each parameter

                $params | ForEach-Object {
                    $name = $_
                    Write-Verbose "Analyzing $name"
                    $type = $data.item($name).ParameterType
                    $aliases = $data.item($name).Aliases -join ','

                    $sets = $data.item($name).ParameterSets.Keys
                    $IsDynamic = $data.item($name).IsDynamic
                    foreach ($set in $sets) {

                        #retrieve parameter attribute class
                        $attributes = $data.item($name).Attributes | Where-Object { $_ -is [system.management.automation.parameterAttribute] -AND $_.ParameterSetName -eq $set }

                        #a parameter could have different positions in different property sets
                        if ($attributes.position -ge 0) {
                            $position = $attributes.position
                        }
                        else {
                            $position = 'Named'
                        }

                        #write a custom object to the pipeline
                        [PSCustomObject]@{
                            PSTypeName                      = 'PSParameterInfo'
                            Name                            = $name
                            Aliases                         = $aliases
                            Mandatory                       = $attributes.mandatory
                            Position                        = $position
                            ValueFromPipeline               = $attributes.ValueFromPipeline
                            ValueFromPipelineByPropertyName = $attributes.ValueFromPipelineByPropertyName
                            Type                            = $type
                            IsDynamic                       = $IsDynamic
                            ParameterSet                    = $attributes.ParameterSetName
                        }
                    } #foreach set
                } #foreach object
            } #if $count
        } #if $data
        else {
            Write-Warning "$command has no defined parameters"
        }
    } #process

    End {
        Write-Verbose "Ending $($MyInvocation.MyCommand)"
    } #end

} #end function
