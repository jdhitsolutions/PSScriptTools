function Show-Tree {

    [CmdletBinding(DefaultParameterSetName = "Path")]
    [alias("pstree","shtree")]

    Param(
        [Parameter(Position = 0,
            ParameterSetName = "Path",
            ValueFromPipeline,
            ValueFromPipelineByPropertyName
            )]
        [ValidateNotNullOrEmpty()]
        [string[]]$Path = ".",

        [Alias("PSPath")]
        [Parameter(Position = 0,
            ParameterSetName = "LiteralPath",
            ValueFromPipelineByPropertyName
            )]
        [ValidateNotNullOrEmpty()]
        [string[]]$LiteralPath,

        [Parameter(Position = 1)]
        [ValidateRange(0, 2147483647)]
        [int]$Depth = [int]::MaxValue,

        [Parameter()]
        [ValidateRange(1, 100)]
        [int]$IndentSize = 3,

        [Parameter()]
        [alias("files")]
        [switch]$ShowItem,

        [Parameter(HelpMessage = "Display item properties. Use * to show all properties or specify a comma separated list.")]
        [alias("properties")]
        [string[]]$ShowProperty
    )
    DynamicParam {
        #define the InColor parameter if running PowerShell 7 and the path is a FileSystem path
        if ($PSBoundParameters.containsKey("Path")) {
            $here = $psboundParameters["Path"]
        }
        elseif ($PSBoundParameters.containsKey("LiteralPath")) {
            $here = $psboundParameters["LiteralPath"]
        }
        else {
            $here = (Get-Location).path
        }
        if (((Get-Item -path $here).PSprovider.Name -eq 'FileSystem' )-OR ((Get-Item -literalpath $here).PSprovider.Name -eq 'FileSystem')) {
         $IsFileSystem = $True
        }
        if ($PSVersiontable.psversion.Major -ge 7 -AND $IsFileSystem) {
            #define a parameter attribute object
            $attributes = New-Object System.Management.Automation.ParameterAttribute
            $attributes.HelpMessage = "Show tree and item colorized."

            #add an alias
            $alias = [System.Management.Automation.AliasAttribute]::new("ansi")

            #define a collection for attributes
            $attributeCollection = New-Object -Type System.Collections.ObjectModel.Collection[System.Attribute]
            $attributeCollection.Add($attributes)
            $attributeCollection.Add($alias)

            #define the dynamic param
            $dynParam1 = New-Object -Type System.Management.Automation.RuntimeDefinedParameter("InColor", [Switch], $attributeCollection)

            #create array of dynamic parameters
            $paramDictionary = New-Object -Type System.Management.Automation.RuntimeDefinedParameterDictionary
            $paramDictionary.Add("InColor", $dynParam1)
            #use the array
            return $paramDictionary
        }
    }

    Begin {
        Write-Verbose "Starting $($myinvocation.MyCommand)"
        if (-Not $Path -and $psCmdlet.ParameterSetName -eq "Path") {
            $Path = Get-Location
        }

        if ($PSBoundParameters.containskey("InColor")) {
            $Colorize = $True
            $script:top = ($global:PSAnsiFileMap).where( {$_.description -eq 'TopContainer'}).Ansi
            $script:child = ($global:PSAnsiFileMap).where( {$_.description -eq 'ChildContainer'}).Ansi
        }
        function GetIndentString {
            [CmdletBinding()]
            Param([bool[]]$IsLast)

            Write-Verbose "Starting $($myinvocation.MyCommand)"
            #  $numPadChars = 1
            $str = ''
            for ($i = 0; $i -lt $IsLast.Count - 1; $i++) {
                $sepChar = if ($IsLast[$i]) {' '} else {'|'}
                $str += "$sepChar"
                $str += " " * ($IndentSize - 1)
            }

            #The \ indicates the item is the last in the container
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
            $propStr = "${indentStr} $Name = "
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
                [bool]$HasChildItems = $false,
                [switch]$Color,
                [ValidateSet("topcontainer","childcontainer","file")]
                [string]$ItemType
            )
            Write-Verbose "Starting $($myinvocation.MyCommand)"
            $PSBoundParameters | Out-String | Write-Verbose
            if ($IsLast.Count -eq 0) {
                if ($Color) {
                   # Write-Output "`e[38;2;0;255;255m$("$(Resolve-Path $Path)")`e[0m"
                    Write-Output "$($script:top)$("$(Resolve-Path $Path)")`e[0m"

                }
                else {
                    "$(Resolve-Path $Path)"
                }
            }
            else {
                $indentStr = GetIndentString $IsLast
                if ($Color) {
                    #ToDo - define a user configurable color map
                    Switch ($ItemType) {
                        "topcontainer" {
                            Write-Output "$indentStr$($script:top)$($Name)`e[0m"
                            #Write-Output "$indentStr`e[38;2;0;255;255m$("$Name")`e[0m"
                        }
                        "childcontainer" {
                            Write-Output "$indentStr$($script:child)$($Name)`e[0m"
                            #Write-Output "$indentStr`e[38;2;255;255;0m$("$Name")`e[0m"
                        }
                        "file" {

                            #only use map items with regex patterns
                            foreach ($item in ($global:PSAnsiFileMap | Where-object Pattern)) {
                                if ($name -match $item.pattern -AND (-not $done)) {
                                    write-Verbose "Detected a $($item.description) file"
                                    Write-Output "$indentStr$($item.ansi)$($Name)`e[0m"
                                    #set a flag indicating we've made a match to stop looking
                                    $done = $True
                                }
                            }
                            #no match was found so just write the item.
                            if (-Not $done) {
                                write-verbose "No ansi match for $Name"
                                Write-Output "$indentStr$Name`e[0m"
                            }
                        } #file
                        Default {
                            Write-Output "$indentStr$Name"
                        }
                    } #switch
                } #if color
                else {
                    "$indentStr$Name"
                }
            }

            if ($ShowProperty) {
                $IsLast += @($false)

                $excludedProviderNoteProps = 'PSChildName', 'PSDrive', 'PSParentPath', 'PSPath', 'PSProvider'
                $props = @(Get-ItemProperty $Path -ea 0)
                if ($props[0] -is [pscustomobject]) {
                    if ($ShowProperty  -eq "*") {
                        $props = @($props[0].psobject.properties | Where-object {$excludedProviderNoteProps -notcontains $_.Name })
                    }
                    else {
                        $props = @($props[0].psobject.properties |
                        Where-object {$excludedProviderNoteProps -notcontains $_.Name -AND $showproperty -contains $_.name})
                    }
                }

                for ($i = 0; $i -lt $props.Count; $i++) {
                    $prop = $props[$i]
                    $IsLast[-1] = ($i -eq $props.count - 1) -and (-Not $HasChildItems)
                    $showParams = @{
                        Name = $prop.Name
                        Value = $prop.Value
                        IsLast = $IsLast
                    }
                    ShowProperty @showParams
                }
            }
            Write-Verbose "Ending $($myinvocation.MyCommand)"
        }

        function ShowContainer {
            [CmdletBinding()]
            Param (
                [string]$Path,
                [string]$Name = $(Split-Path $Path -Leaf),
                [bool[]]$IsLast = @(),
                [switch]$IsTop,
                [switch]$Color
            )

            Write-Verbose "Starting $($myinvocation.MyCommand) on $Path"
            $PSBoundParameters | Out-String | Write-Verbose
            if ($IsLast.Count -gt $Depth) { return }

            $childItems = @()
            if ($IsLast.Count -lt $Depth) {
                try {
                    $rpath = Resolve-Path -literalpath $Path -ErrorAction stop
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
            $sParams = @{
                path          = $Path
                name          = $Name
                IsLast        = $IsLast
                hasChildItems = $hasChildItems
                Color         = $Color
                ItemType      =  If ($isTop) {"topcontainer"} else {"childcontainer"}
            }
            ShowItem @sParams

            # Process the children of this container
            $IsLast += @($false)
            for ($i = 0; $i -lt $childItems.count; $i++) {
                $childItem = $childItems[$i]
                $IsLast[-1] = ($i -eq $childItems.count - 1)
                if ($childItem.PSIsContainer) {
                    $iParams = @{
                        path   = $childItem.PSPath
                        name   = $childItem.PSChildName
                        isLast = $IsLast
                        Color  = $color
                    }
                    ShowContainer @iParams
                }
                elseif ($ShowItem) {
                    $unresolvedPath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($childItem.PSPath)
                    $name = Split-Path $unresolvedPath -Leaf
                    $iParams = @{
                        Path   = $childItem.PSPath
                        Name   = $name
                        IsLast = $IsLast
                        Color  = $Color
                       ItemType = "File"
                    }
                    ShowItem @iParams
                }
            }
            Write-Verbose "Ending $($myinvocation.MyCommand)"
        }
    } #begin

    Process {
        if ($psCmdlet.ParameterSetName -eq "Path") {
            # In the -Path (non-literal) resolve path in case it is wildcarded.
            $resolvedPaths = @($Path | Resolve-Path | Foreach-object { $_.Path})
        }
        else {
            # Must be -LiteralPath
            $resolvedPaths = @($LiteralPath)
        }
        Write-Verbose "Using these PSBoundParameters"
        $PSBoundParameters | Out-String | Write-Verbose

        foreach ($rpath in $resolvedPaths) {
            Write-Verbose "Processing $rpath"
            $showParams = @{
                Path  = $rpath
                Color = $colorize
                IsTop = $True
            }
            ShowContainer @showParams
          }
    } #process
    end {
        Write-Verbose "Ending $($myinvocation.MyCommand)"
    }
}
