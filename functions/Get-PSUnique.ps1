
Function Get-PSUnique {
    [cmdletbinding()]
    [alias('gpsu')]
    [OutputType('object')]
    Param(
        [Parameter(Position = 0, Mandatory, ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [object]$InputObject,
        [string[]]$Property
    )

    Begin {
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Starting $($MyInvocation.MyCommand)"
        Write-Debug "[$((Get-Date).TimeOfDay) BEGIN  ] Initializing list"
        $UniqueList = [System.Collections.Generic.list[object]]::new()
    } #begin

    Process {
        if ($Property) {
            foreach ($item in $InputObject) {
                $props = $item.PSObject.Properties.where{ $_.name -in $Property }
                if (-not $props) { continue }
                if (-not $UniqueList.Exists({ -not (Compare-Object $args[0].PSObject.properties.where{ $_.name -in $Property }.value $props.value) })) {
                    $UniqueList.add($item)
                }
            }
        }
        else {
            foreach ($item in $InputObject) {
                Try {
                    if ($UniqueList.Exists( { -Not ( Compare-Object -ReferenceObject $args[0].PSObject.properties.value -DifferenceObject $item.PSObject.Properties.value )})) {
                        Write-Debug "[$((Get-Date).TimeOfDay) PROCESS] Skipping: $($item |Out-String)"
                    }
                    else {
                        Write-Debug "[$((Get-Date).TimeOfDay) PROCESS] Adding as unique: $($item | Out-String)"
                        $UniqueList.add($item)
                    }
                }
                Catch {
                    Write-Warning "The input object can't be compared based on the number of properties. Try again using the Property parameter."
                }

            }
        }
        <# foreach ($item in $InputObject) {
            if ($UniqueList.Exists( { -not(Compare-Object $args[0].PSObject.properties.value $item.PSObject.Properties.value) })) {
                Write-Debug "[$((Get-Date).TimeOfDay) PROCESS] Skipping: $($item |Out-String)"
            }
            else {
                Write-Debug "[$((Get-Date).TimeOfDay) PROCESS] Adding as unique: $($item | Out-String)"
                $UniqueList.add($item)
            }
        } #>
    } #process

    End {
        Write-Verbose "[$((Get-Date).TimeOfDay) END    ] Found $($UniqueList.count) unique objects"
        Write-Debug "[$((Get-Date).TimeOfDay) END    ] Writing results to the pipeline"
        $UniqueList
        Write-Verbose "[$((Get-Date).TimeOfDay) END    ] Ending $($MyInvocation.MyCommand)"
    } #end
}
