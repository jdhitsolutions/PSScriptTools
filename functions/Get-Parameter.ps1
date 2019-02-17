
Function Get-ParameterInfo {

    [cmdletbinding()]
    [Outputtype("PSCustomobject")]
    [alias("gpi")]

    Param(
        [Parameter(Position = 0, Mandatory,
            ValueFromPipeline, ValueFromPipelineByPropertyName,
            HelpMessage = "Enter a cmdlet name")]
        [ValidateNotNullorEmpty()]
        [Alias("name")]
        [string]$Command,
        [string]$Parameter
    )

    Begin {
        Write-Verbose "Starting $($myinvocation.MyCommand)"
        #define the set of common parameters to exclude
        $common = @("Verbose",
            "Debug",
            "ErrorAction",
            "ErrorVariable",
            "WarningAction",
            "WarningVariable",
            "OutVariable",
            "OutBuffer",
            "WhatIf",
            "Confirm",
            "InformationAction",
            "InformationVariable",
            "pipelinevariable"
        )
    } #begin

    Process {
        Write-Verbose "Processing $command for parameter information"
        Try {
            $data = (Get-Command -Name $command -errorAction "Stop").parameters
        }
        Catch {
            Write-Warning "Failed to find command $command"
        }
        #keep going if parameters were found
        if ($data.count -gt 0) {
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
                Write-Verbose "Getting parameter all non-common parameters"
                $params = $data.keys | where-object {$common -notcontains $_}
            }
            $count = ($params | measure-object).count
            #only keep going if non-common parameters were found
            write-verbose "Found $count non-common parameters for $command"

            if ($count -gt 0) {
                #get information from each parameter

                $params | foreach-object {
                    $name = $_
                    Write-Verbose "Analyzing $name"
                    $type = $data.item($name).ParameterType
                    $aliases = $data.item($name).Aliases -join ","

                    $sets = $data.item($name).ParameterSets.Keys

                    foreach ($set in $sets) {

                        #retrieve parameter attribute class
                        $attributes = $data.item($name).Attributes | where-object {$_ -is [system.management.automation.parameterAttribute] -AND $_.ParameterSetName -eq $set}

                        #a parameter could have different positions in different property sets
                        if ($attributes.position -ge 0) {
                            $position = $attributes.position
                        }
                        else {
                            $position = "Named"
                        }

                        #write a custom object to the pipeline
                        [PSCustomObject]@{
                            Name                            = $name
                            Aliases                         = $aliases
                            Mandatory                       = $attributes.mandatory
                            Position                        = $position
                            ValueFromPipeline               = $attributes.ValueFromPipeline
                            ValueFromPipelineByPropertyName = $attributes.ValueFromPipelineByPropertyName
                            Type                            = $type
                            ParameterSet                    = $attributes.ParameterSetName
                        }

                    } #foreach set
                } #foreach object
            } #if $count
        } #if $data
        else {
            Write-warning "$command has no defined parameters"
        }
    } #process

    End {
        Write-Verbose "Ending $($myinvocation.MyCommand)"
    } #end

} #end function


