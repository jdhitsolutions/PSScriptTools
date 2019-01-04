function Show-Tree {

    [CmdletBinding(DefaultParameterSetName = "Path")]
    param(
        [Parameter(Position = 0, 
            ParameterSetName = "Path", 
            ValueFromPipeline = $true, 
            ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [string[]]$Path,
       
        [Alias("PSPath")]
        [Parameter(Position = 0, 
            ParameterSetName = "LiteralPath", 
            ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [string[]]$LiteralPath,
           
        [Parameter(Position = 1)]
        [ValidateRange(0, 2147483647)]
        [int]$Depth = [int]::MaxValue, 
       
        [Parameter()]
        [ValidateRange(1, 100)]
        [int]$IndentSize = 3, 
       
        [Parameter()]
        [switch]$ShowItem, 
       
        [Parameter()]
        [switch]$ShowProperty
    )

    Begin {
        Write-Verbose "Starting $($myinvocation.MyCommand)"
        if (!$Path -and $psCmdlet.ParameterSetName -eq "Path") {
            $Path = Get-Location
        }        
       
        function GetIndentString {
            [CmdletBinding()]
            Param([bool[]]$IsLast)

            Write-Verbose "Starting $($myinvocation.MyCommand)"
            $numPadChars = 1
            $str = ''
            for ($i = 0; $i -lt $IsLast.Count - 1; $i++) {
                $sepChar = if ($IsLast[$i]) {' '} else {'|'}
                $str += "$sepChar"
                $str += " " * ($IndentSize - 1)
            }

            $teeChar = if ($IsLast[-1]) {'\'} else {'+'}
            $str += "$teeChar"
            $str += "-" * ($IndentSize - 1)
            $str

            Write-Verbose "Ending $($myinvocation.MyCommand)"
        } 

        function ShowProperty() {
            [cmdletbinding()]
            Param(
                [string]$Name, 
                [string]$Value, 
                [bool[]]$IsLast
            )
            Write-Verbose "Starting $($myinvocation.MyCommand)"
            $indentStr = GetIndentString $IsLast
            $propStr = "${indentStr}Property: $Name = "
            $availableWidth = $host.UI.RawUI.BufferSize.Width - $propStr.Length - 1
            if ($Value.Length -gt $availableWidth) {
                $ellipsis = '...'
                $val = $Value.Substring(0, $availableWidth - $ellipsis.Length) + $ellipsis
            }
            else {
                $val = $Value
            }
            $propStr += $val
            $propStr
            Write-Verbose "Ending $($myinvocation.MyCommand)"
        }
        function ShowItem {
            [CmdletBinding()]
            Param(
            [string]$Path, 
            [string]$Name, 
            [bool[]]$IsLast, 
            [bool]$HasChildItems = $false
            )
            Write-Verbose "Starting $($myinvocation.MyCommand)"
            if ($IsLast.Count -eq 0) {
                "$(Resolve-Path $Path)"
            }
            else {
                $indentStr = GetIndentString $IsLast
                "$indentStr$Name" 
            }
           
            if ($ShowProperty) {
                $IsLast += @($false)

                $excludedProviderNoteProps = 'PSChildName', 'PSDrive', 'PSParentPath', 'PSPath', 'PSProvider'
                $props = @(Get-ItemProperty $Path -ea 0)
                if ($props[0] -is [pscustomobject]) {
                    $props = @($props[0].psobject.properties | Where-object {$excludedProviderNoteProps -notcontains $_.Name})
                }
               
                for ($i = 0; $i -lt $props.Count; $i++) {
                    $prop = $props[$i]
                    $IsLast[-1] = ($i -eq $props.count - 1) -and !$HasChildItems
                    ShowProperty $prop.Name $prop.Value $IsLast
                }
            }
            Write-Verbose "Ending $($myinvocation.MyCommand)"
        }

        function ShowContainer {  
            [CmdletBinding()]
            Param (
                [string]$Path, 
                [string]$Name = $(Split-Path $Path -Leaf), 
                [bool[]]$IsLast = @() 
            )

            Write-Verbose "Starting $($myinvocation.MyCommand) on $Path"
            if ($IsLast.Count -gt $Depth) { return }
           
            $childItems = @()  
            if ($IsLast.Count -lt $Depth) {
                try {
                    $rpath = Resolve-Path $Path -ErrorAction stop
                }
                catch {
                    Throw "Failed to resolve $path. This PSProvider and path may be incompatible with this command."
                    #bail out
                    return
                }
                $childItems = @(Get-ChildItem $rpath -ErrorAction $ErrorActionPreference | 
                        Where-object {$ShowItem -or $_.PSIsContainer})
            }
            $hasChildItems = $childItems.Count -gt 0

            # Show the current container
            ShowItem $Path $Name $IsLast $hasChildItems    

            # Process the children of this container
            $IsLast += @($false)
            for ($i = 0; $i -lt $childItems.count; $i++) {
                $childItem = $childItems[$i]
                $IsLast[-1] = ($i -eq $childItems.count - 1)
                if ($childItem.PSIsContainer) {
                    ShowContainer $childItem.PSPath $childItem.PSChildName $IsLast
                }
                elseif ($ShowItem) {
                    $unresolvedPath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($childItem.PSPath)
                    $name = Split-Path $unresolvedPath -Leaf
                    ShowItem $childItem.PSPath $name $IsLast    
                }
            }
            Write-Verbose "Ending $($myinvocation.MyCommand)"
        }
    } #begin

    Process {
        if ($psCmdlet.ParameterSetName -eq "Path") {
            # In the -Path (non-literal) resolve path in case it is wildcarded.
            $resolvedPaths = @($Path | Resolve-Path | Foreach-object {$_.Path})
        }
        else {
            # Must be -LiteralPath
            $resolvedPaths = @($LiteralPath)
        }

        foreach ($rpath in $resolvedPaths) {
            Write-Verbose "Processing $rpath"
            ShowContainer $rpath
        }  
    } #process
    end {
        Write-Verbose "Ending $($myinvocation.MyCommand)"
    }
}
