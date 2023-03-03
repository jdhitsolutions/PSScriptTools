
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
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Starting $($MyInvocation.MyCommand)"
        Write-Debug "[$((Get-Date).TimeOfDay) BEGIN  ] Initializing list"
        $UniqueList = [System.Collections.Generic.list[object]]::new()
    } #begin

    Process {
        foreach ($item in $InputObject) {
            if ($UniqueList.Exists( { -not(Compare-Object $args[0].PSObject.properties.value $item.PSObject.Properties.value) })) {
                Write-Debug "[$((Get-Date).TimeOfDay) PROCESS] Skipping: $($item |Out-String)"
            }
            else {
                Write-Debug "[$((Get-Date).TimeOfDay) PROCESS] Adding as unique: $($item | Out-String)"
                $UniqueList.add($item)
            }
        }
    } #process

    End {
        Write-Verbose "[$((Get-Date).TimeOfDay) END    ] Found $($UniqueList.count) unique objects"
        Write-Debug "[$((Get-Date).TimeOfDay) END    ] Writing results to the pipeline"
        $UniqueList
        Write-Verbose "[$((Get-Date).TimeOfDay) END    ] Ending $($MyInvocation.MyCommand)"
    } #end
}
