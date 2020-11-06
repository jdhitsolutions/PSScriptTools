Function Select-First {
    [CmdletBinding()]
    [Alias("First")]
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [psobject]$InputObject,

        [Parameter(Position = 0, Mandatory, HelpMessage = "How many items do you want to select?")]
        [ValidateRange(0, 2147483647)]
        [int]$First,

        [Parameter(Position = 1, HelpMessage = "Select a property to sort on before selecting the first number of objects.")]
        [ValidateNotNullOrEmpty()]
        [string]$Property,

        [Parameter()]
        [ValidateRange(0, 2147483647)]
        [int]$Skip = 0,

        [Parameter()]
        [switch]$Descending
    )

    Begin {

        Write-Verbose "[BEGIN  ] Starting $($MyInvocation.Mycommand)"

        if ($PSBoundParameters.ContainsKey("Property")) {
            $sortParams = @{Property = $Property }
            Write-Verbose "[BEGIN  ] Sorting on $Property"
        }
        if ($PSBoundParameters.ContainsKey("Descending")) {
            if ($sortParams) {
                $sortParams.Add("Descending", $True)
            }
            else {
                #it is possible to sort without a property say on a string or number
                $sortParams = @{"Descending" = $True }
            }
        }

        $data = [System.Collections.generic.list[object]]::new()

        Write-Verbose "[BEGIN  ] Selecting first $First, skipping $skip."

    } #begin

    Process {

        #save input objects so they can be sorted
        if ($data.count -eq 0) {
            Write-Verbose "[PROCESS] Processing input"
        }
        #verify property
        if ($property -AND $InputObject.psobject.properties.name -notcontains $property) {
            $exception = [system.argumentexception]::new("Cannot find property $property on the inputobject.")
            Throw $exception
        }
        else {
            $data.add($InputObject)
        }

    } #process

    End {
        If ($sortparams) {
            Write-Verbose "[END    ] Sort parameters"
            Write-Verbose ($sortParams | Out-String)
            $data = $data | Sort-Object @sortparams
        }
        $data | Microsoft.PowerShell.Utility\Select-Object -First $first -Skip $skip

        Write-Verbose "[END    ] Ending $($MyInvocation.Mycommand)"

    } #end

} #end function Select-First

Function Select-Last {
    [CmdletBinding()]
    [Alias("Last")]
    param(
        [Parameter(Mandatory, ValueFromPipeline )]
        [psobject]$InputObject,

        [Parameter(Position = 0, Mandatory, HelpMessage = "How many items do you want to select?")]
        [ValidateRange(0, 2147483647)]
        [int]$Last,

        [Parameter(Position = 1, HelpMessage = "Sort on this property and then select the last number of items")]
        [ValidateNotNullOrEmpty()]
        [string]$Property,

        [Parameter()]
        [ValidateRange(0, 2147483647)]
        [int]$Skip = 0,

        [Parameter()]
        [switch]$Descending
    )

    Begin {
        Write-Verbose "[BEGIN  ] Starting $($MyInvocation.Mycommand)"

        if ($PSBoundParameters.ContainsKey("Property")) {
            $sortParams = @{Property = $Property }
            Write-Verbose "[BEGIN  ] Sorting on $Property"
        }
        if ($PSBoundParameters.ContainsKey("Descending")) {
            if ($sortParams) {
                $sortParams.Add("Descending", $True)
            }
            else {
                #it is possible to sort without a property say on a string or number
                $sortParams = @{"Descending" = $True }
            }
        }

        $data = [System.Collections.generic.list[object]]::new()

        Write-Verbose "[BEGIN  ] Selecting Last $Last, skipping $skip."

    } #begin

    Process {
        #save input objects so they can be sorted
        if ($data.count -eq 0) {
            Write-Verbose "[PROCESS] Processing input"
        }
        #verify property
        if ($property -AND $InputObject.psobject.properties.name -notcontains $property) {
            $exception = [system.argumentexception]::new("Cannot find property $property on the inputobject.")
            Throw $exception
        }
        else {
            $data.add($InputObject)
        }
    } #process

    End {
        If ($sortparams) {
            Write-Verbose "[END    ] Sorting parameters"
            Write-Verbose ($sortParams | Out-String)
            $data = $data | Sort-Object @sortparams
        }
        $data | Select-Object -Last $Last -Skip $skip

        Write-Verbose "[END    ] Ending $($MyInvocation.Mycommand)"

    } #end

} #end function Select-Last


Function Select-After {
    [CmdletBinding()]
    [alias("after")]
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [psobject]$InputObject,

        [Parameter(Position = 0, Mandatory, HelpMessage = "Enter the cutoff date")]
        [DateTime]$After,

        [Parameter(HelpMessage = "Enter the property name to select on. It needs to be a datetime object.")]
        [ValidateNotNullOrEmpty()]
        [string]$Property = "LastWriteTime"
    )

    begin {
        Write-Verbose "[BEGIN  ] Starting $($MyInvocation.Mycommand)"
        Write-Verbose "[BEGIN  ] Selecting objects after $after based on the $Property property"
    } #begin

    process {
        #verify property
        if ($InputObject.psobject.properties.name -notcontains $property) {
            $exception = [system.argumentexception]::new("Cannot find property $property on the inputobject.")
            Throw $exception
        }
        else {
            $InputObject | Where-Object { $_.$property -ge $After }
        }
    } #process

    end {
        Write-Verbose "[END    ] Ending $($MyInvocation.Mycommand)"
    } #end

} #end function

Function Select-Before {
    [CmdletBinding()]
    [alias("before")]
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [psobject]$InputObject,

        [Parameter(Position = 0, Mandatory, HelpMessage = "Enter the cutoff date")]
        [DateTime]$Before,

        [Parameter(HelpMessage = "Enter the property name to select on. It must be a datetime object.")]
        [ValidateNotNullOrEmpty()]
        [string]$Property = "LastWriteTime"
    )

    begin {
        Write-Verbose "[BEGIN  ] Starting $($MyInvocation.Mycommand)"
        Write-Verbose "[BEGIN  ] Selecting objects before $before based on the $Property property"
    } #begin

    process {
        #verify property
        if ($InputObject.psobject.properties.name -notcontains $property) {
            $exception = [system.argumentexception]::new("Cannot find property $property on the inputobject.")
            Throw $exception
        }
        else {
            $InputObject | Where-Object { $_.$property -le $Before }
        }
    } #process

    end {
        Write-Verbose "[END    ] Ending $($MyInvocation.Mycommand)"
    } #end

} #end function

function Select-Newest {
    [CmdletBinding()]
    [alias("newest")]
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [psobject]$InputObject,

        [Parameter(Position = 0, Mandatory, HelpMessage = "Enter the number of newest items to get")]
        [ValidateRange(0, 2147483647)]
        [Int]$Newest,

        [Parameter(HelpMessage = "Enter the property name to select on. It must be a datetime object.")]
        [ValidateNotNullOrEmpty()]
        [string]$Property = "LastWriteTime"
    )

    begin {
        Write-Verbose "[BEGIN  ] Starting $($MyInvocation.Mycommand)"
        $data = [System.Collections.generic.list[object]]::new()
    } #begin

    process {
        if ($data.count -eq 0) {
            Write-Verbose "[PROCESS] Processing input"
        }
        #verify property
        if ($InputObject.psobject.properties.name -notcontains $property) {
            $exception = [system.argumentexception]::new("Cannot find property $property on the inputobject.")
            Throw $exception
        }
        else {
            $data.add($InputObject)
        }
    } #process

    end {
        Write-Verbose "[END    ] Selecting newest $newest object(s) based on $property"
        $data | Sort-Object -Property $property -Descending | Select-Object -First $Newest
        Write-Verbose "[END    ] Ending $($MyInvocation.Mycommand)"
    } #end

}

function Select-Oldest {
    [CmdletBinding()]
    [alias("oldest")]
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [psobject]$InputObject,

        [Parameter(Position = 0, Mandatory, HelpMessage = "Enter the number of Oldest items to get")]
        [ValidateRange(0, 2147483647)]
        [Int]$Oldest,

        [Parameter(HelpMessage = "Enter the property name to select on. It must be a datetime object.")]
        [ValidateNotNullOrEmpty()]
        [string]$Property = "LastWriteTime"
    )

    begin {
        Write-Verbose "[BEGIN  ] Starting $($MyInvocation.Mycommand)"
        $data = [System.Collections.generic.list[object]]::new()
    } #begin

    process {
        if ($data.count -eq 0) {
            Write-Verbose "[PROCESS] Processing input"
        }
        #verify property
        if ($InputObject.psobject.properties.name -notcontains $property) {
            $exception = [system.argumentexception]::new("Cannot find property $property on the inputobject.")
            Throw $exception
        }
        else {
            $data.add($InputObject)
        }
    } #process

    end {
        Write-Verbose "[END    ] Selecting oldest $oldest object(s) based on $property"
        $data | Sort-Object -Property $property | Select-Object -First $Oldest
        Write-Verbose "[END    ] Ending $($MyInvocation.Mycommand)"
    } #end
}
