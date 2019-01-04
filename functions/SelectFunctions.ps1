Function Select-First {

    
    [CmdletBinding(DefaultParameterSetName = 'DefaultParameter')]
    [Alias("First")]
    param(
        [Parameter(
            ParameterSetName = 'DefaultParameter',
            Mandatory, 
            ValueFromPipeline )]
        [psobject]$InputObject,
    
        [Parameter(
            ParameterSetName = 'DefaultParameter',
            Position = 0,
            Mandatory,
            HelpMessage = "How many items do you want to select?")]
        [ValidateRange(0, 2147483647)]
        [int]$First,
        
        [Parameter(
            Position = 1,
            ParameterSetName = 'DefaultParameter')]
        [ValidateNotNullOrEmpty()]
        [string]$Property,
    
        [Parameter(ParameterSetName = 'DefaultParameter')]
        [ValidateRange(0, 2147483647)]
        [int]$Skip = 0,
    
        [Parameter(ParameterSetName = 'DefaultParameter')]
        [switch]$Descending
    )
    
    Begin {
    
        Write-Verbose "[BEGIN  ] Starting $($MyInvocation.Mycommand)"
        Write-Verbose "[BEGIN  ] Using parameter set $($PSCmdlet.ParameterSetName)"
        if ($PSBoundParameters.ContainsKey("Property")) {
            $sortParams = @{Property = $Property}
            write-verbose "Sorting on $Property"
        }
        if ($PSBoundParameters.ContainsKey("Descending")) {
            if ($sortParams) {
                $sortParams.Add("Descending", $True)
            }
            else {
                #it is possible to sort without a property say on a string or number
                $sortParams = @{"Descending" = $True}
            }
        }
            
        $data = @()
    
        Write-Verbose "Selecting first $First, skipping $skip."
    
    } #begin
    
    Process {
    
        #save input objects so they can be sorted
        $data += $InputObject  
    
    } #process
    
    End {
        If ($sortparams) {
            Write-Verbose ($sortParams | out-string)
            $data = $data | Sort-Object @sortparams 
        }
        $data | Microsoft.PowerShell.Utility\Select-object -First $first -Skip $skip
    
        Write-Verbose "[END    ] Ending $($MyInvocation.Mycommand)"
    
    } #end
    
} #end function Select-First
    
Function Select-Last {
    
    
    [CmdletBinding(DefaultParameterSetName = 'DefaultParameter')]
    [Alias("Last")]
    param(
        [Parameter(
            ParameterSetName = 'DefaultParameter',
            Mandatory, 
            ValueFromPipeline )]
        [psobject]$InputObject,
    
        [Parameter(
            ParameterSetName = 'DefaultParameter',
            Position = 0,
            Mandatory,
            HelpMessage = "How many items do you want to select?")]
        [ValidateRange(0, 2147483647)]
        [int]$Last,
        
        [Parameter(
            Position = 1,
            ParameterSetName = 'DefaultParameter')]
        [ValidateNotNullOrEmpty()]
        [string]$Property,
    
        [Parameter(ParameterSetName = 'DefaultParameter')]
        [ValidateRange(0, 2147483647)]
        [int]$Skip = 0,
    
        [Parameter(ParameterSetName = 'DefaultParameter')]
        [switch]$Descending
    )
    
    Begin {
    
        Write-Verbose "[BEGIN  ] Starting $($MyInvocation.Mycommand)"
        Write-Verbose "[BEGIN  ] Using parameter set $($PSCmdlet.ParameterSetName)"
        if ($PSBoundParameters.ContainsKey("Property")) {
            $sortParams = @{Property = $Property}
            write-verbose "Sorting on $Property"
        }
        if ($PSBoundParameters.ContainsKey("Descending")) {
            if ($sortParams) {
                $sortParams.Add("Descending", $True)
            }
            else {
                #it is possible to sort without a property say on a string or number
                $sortParams = @{"Descending" = $True}
            }
        }
            
        $data = @()
    
        Write-Verbose "Selecting Last $Last, skipping $skip."
    
    } #begin
    
    Process {
    
        #save input objects so they can be sorted
        $data += $InputObject  
    
    } #process
    
    End {
        If ($sortparams) {
            Write-Verbose ($sortParams | out-string)
            $data = $data | Sort-Object @sortparams 
        }
        $data | Microsoft.PowerShell.Utility\Select-object -Last $Last -Skip $skip
    
        Write-Verbose "[END    ] Ending $($MyInvocation.Mycommand)"
    
    } #end
    
} #end function Select-Last
    
    
    