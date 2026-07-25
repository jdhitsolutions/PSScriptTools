
function Get-PSUnique {
    [cmdletbinding()]
    [alias('gpsu')]
    [OutputType('object')]
    param(
        [Parameter(Position = 0, Mandatory, ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [object]$InputObject,
        [string[]]$Property
    )

    begin {
        #tags are used for categorizing the command
        #cmdTags = scripting

        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Starting $($MyInvocation.MyCommand)"
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Running under PowerShell version $($PSVersionTable.PSVersion)"
        Write-Debug "[$((Get-Date).TimeOfDay) BEGIN  ] Initializing list"
        $UniqueList = [System.Collections.Generic.list[object]]::new()
    } #begin

    process {
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
                try {
                    if ($UniqueList.Exists( { -not ( Compare-Object -ReferenceObject $args[0].PSObject.properties.value -DifferenceObject $item.PSObject.Properties.value ) })) {
                        Write-Debug "[$((Get-Date).TimeOfDay) PROCESS] Skipping: $($item |Out-String)"
                    }
                    else {
                        Write-Debug "[$((Get-Date).TimeOfDay) PROCESS] Adding as unique: $($item | Out-String)"
                        $UniqueList.add($item)
                    }
                }
                catch {
                    Write-Warning "The input object can't be compared based on the number of properties. Try again using the Property parameter."
                }

            }
        }
    } #process

    end {
        Write-Verbose "[$((Get-Date).TimeOfDay) END    ] Found $($UniqueList.count) unique objects"
        Write-Debug "[$((Get-Date).TimeOfDay) END    ] Writing results to the pipeline"
        $UniqueList
        Write-Verbose "[$((Get-Date).TimeOfDay) END    ] Ending $($MyInvocation.MyCommand)"
    } #end
}

#EOF
