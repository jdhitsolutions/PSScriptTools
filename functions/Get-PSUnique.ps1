
Function Get-PSUnique {
    [cmdletbinding()]
    [alias("gpsu")]
    [OutputType("object")]
    Param(
        [Parameter(Position = 0, Mandatory, ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [object]$InputObject
    )

    Begin {
        Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] Starting $($myinvocation.mycommand)"
        Write-Debug "[$((Get-Date).TimeofDay) BEGIN  ] Initializing list"
        $UniqueList = [System.Collections.Generic.list[object]]::new()
    } #begin

    Process {
        foreach ($item in $InputObject) {
            if ($UniqueList.Exists( { -not(Compare-Object $args[0].psobject.properties.value $item.psobject.Properties.value) })) {
                Write-Debug "[$((Get-Date).TimeofDay) PROCESS] Skipping: $($item |Out-String)"
            }
            else {
                Write-Debug "[$((Get-Date).TimeofDay) PROCESS] Adding as unique: $($item | Out-String)"
                $UniqueList.add($item)
            }
        }
    } #process

    End {
        Write-Verbose "[$((Get-Date).TimeofDay) END    ] Found $($UniqueList.count) unique objects"
        Write-Debug "[$((Get-Date).TimeofDay) END    ] Writing results to the pipeline"
        $UniqueList
        Write-Verbose "[$((Get-Date).TimeofDay) END    ] Ending $($myinvocation.mycommand)"
    } #end
}
