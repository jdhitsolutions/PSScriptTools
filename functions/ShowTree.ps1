function Show-Tree {

    [CmdletBinding(DefaultParameterSetName = 'Path')]
    [alias('pstree', 'shtree')]

    Param(
        [Parameter(
            Position = 0,
            ParameterSetName = 'Path',
            ValueFromPipeline,
            ValueFromPipelineByPropertyName
        )]
        [ValidateNotNullOrEmpty()]
        [alias('FullName')]
        [string[]]$Path = '.',

        [Parameter(
            Position = 0,
            ParameterSetName = 'LiteralPath',
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
        [alias('files')]
        [switch]$ShowItem,

        [Parameter(HelpMessage = 'Display item properties. Use * to show all properties or specify a comma separated list.')]
        [alias('properties')]
        [string[]]$ShowProperty
    )
    DynamicParam {
        #define the InColor parameter if the path is a FileSystem path
        if ($PSBoundParameters.ContainsKey('Path')) {
            $here = $PSBoundParameters['Path']
        }
        elseif ($PSBoundParameters.ContainsKey('LiteralPath')) {
            $here = $PSBoundParameters['LiteralPath']
        }
        else {
            $here = (Get-Location).path
        }
        if (((Get-Item -Path $here).PSprovider.Name -eq 'FileSystem' ) -OR ((Get-Item -LiteralPath $here).PSprovider.Name -eq 'FileSystem')) {

            #define a parameter attribute object
            $attributes = New-Object System.Management.Automation.ParameterAttribute
            $attributes.HelpMessage = 'Show tree and item colorized for the filesystem.'

            #add an alias
            $alias = [System.Management.Automation.AliasAttribute]::new('ansi')

            #define a collection for attributes
            $attributeCollection = New-Object -Type System.Collections.ObjectModel.Collection[System.Attribute]
            $attributeCollection.Add($attributes)
            $attributeCollection.Add($alias)

            #define the dynamic param
            $dynParam1 = New-Object -Type System.Management.Automation.RuntimeDefinedParameter('InColor', [Switch], $attributeCollection)

            #create array of dynamic parameters
            $paramDictionary = New-Object -Type System.Management.Automation.RuntimeDefinedParameterDictionary
            $paramDictionary.Add('InColor', $dynParam1)
            #use the array
            return $paramDictionary
        }
    } #DynamicParam

    Begin {
        Write-Verbose "Starting $($MyInvocation.MyCommand)"
        if (-Not $Path -and $PSCmdlet.ParameterSetName -eq 'Path') {
            $Path = Get-Location
        }

        if ($PSBoundParameters.ContainsKey('InColor')) {
            $Colorize = $True
            #30 May 2024 Use PSStyle.FileInfo if found
            if ($PSStyle.FileInfo) {
                $script:top = $PSstyle.FileInfo.Directory
                $script:child =  $PSstyle.FileInfo.Directory
            }
            else {
                $script:top = ($global:PSAnsiFileMap).where( { $_.description -eq 'TopContainer' }).Ansi
                $script:child = ($global:PSAnsiFileMap).where( { $_.description -eq 'ChildContainer' }).Ansi
            }
        }
        function GetIndentString {
            [CmdletBinding()]
            Param([bool[]]$IsLast)

            Write-Verbose "Starting $($MyInvocation.MyCommand)"
            #  $numPadChars = 1
            $str = ''
            for ($i = 0; $i -lt $IsLast.Count - 1; $i++) {
                $sepChar = if ($IsLast[$i]) { ' ' } else { '|' }
                $str += "$sepChar"
                $str += ' ' * ($IndentSize - 1)
            }

            #The \ indicates the item is the last in the container
            $teeChar = if ($IsLast[-1]) { '\' } else { '+' }
            $str += "$teeChar"
            $str += '-' * ($IndentSize - 1)
            $str

            Write-Verbose "Ending $($MyInvocation.MyCommand)"
        }

        function ShowProperty() {
            [cmdletbinding()]
            Param(
                [string]$Name,
                [string[]]$Value,
                [bool[]]$IsLast
            )
            Write-Verbose "Starting $($MyInvocation.MyCommand)"
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
            Write-Verbose "Ending $($MyInvocation.MyCommand)"
        }
        function ShowItem {
            [CmdletBinding()]
            Param(
                [string]$Path,
                [string]$Name,
                [bool[]]$IsLast,
                [bool]$HasChildItems = $false,
                [switch]$Color,
                [ValidateSet('TopContainer', 'ChildContainer', 'file')]
                [string]$ItemType
            )
            Write-Verbose "Starting $($MyInvocation.MyCommand)"
            $PSBoundParameters | Out-String | Write-Verbose
            if ($IsLast.Count -eq 0) {
                if ($Color) {
                    # Write-Output "$([char]27)[38;2;0;255;255m$("$(Resolve-Path $Path)")$([char]27)[0m"
                    Write-Output "$($script:top)$("$(Resolve-Path $Path)")$([char]27)[0m"
                }
                else {
                    "$(Resolve-Path $Path)"
                }
            }
            else {
                $indentStr = GetIndentString $IsLast
                if ($Color) {
                    Switch ($ItemType) {
                        'TopContainer' {
                            Write-Output "$indentStr$($script:top)$($Name)$([char]27)[0m"
                            #Write-Output "$indentStr$([char]27)[38;2;0;255;255m$("$Name")$([char]27)[0m"
                        }
                        'ChildContainer' {
                            Write-Output "$indentStr$($script:child)$($Name)$([char]27)[0m"
                            #Write-Output "$indentStr$([char]27)[38;2;255;255;0m$("$Name")$([char]27)[0m"
                        }
                        'file' {
                            #30 May 2024 Use PSStyle.FileInfo if found
                            if ($PSStyle.FileInfo) {
                                if ($name -match "\.exe$") {
                                    Write-Output "$indentStr$($PSStyle.FileInfo.Executable)$($Name)$([char]27)[0m"
                                }
                                else {
                                    $ext = $name.Split('.')[-1]
                                    Write-Output "$indentStr$($PSStyle.FileInfo.Extension[".$ext"])$($Name)$([char]27)[0m"
                                }
                                $done = $True
                            }
                            else {
                                #only use map items with regex patterns
                                foreach ($item in ($global:PSAnsiFileMap | Where-Object Pattern)) {
                                    if ($name -match $item.pattern -AND (-not $done)) {
                                        Write-Verbose "Detected a $($item.description) file"
                                        Write-Output "$indentStr$($item.ansi)$($Name)$([char]27)[0m"
                                        #set a flag indicating we've made a match to stop looking
                                        $done = $True
                                    }
                                }
                            }
                            #no match was found so just write the item.
                            if (-Not $done) {
                                Write-Verbose "No ansi match for $Name"
                                Write-Output "$indentStr$Name$([char]27)[0m"
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
                if ($props[0] -is [PSCustomObject]) {
                    if ($ShowProperty -eq '*') {
                        $props = @($props[0].PSObject.properties | Where-Object { $excludedProviderNoteProps -NotContains $_.Name })
                    }
                    else {
                        $props = @($props[0].PSObject.properties |
                            Where-Object { $excludedProviderNoteProps -NotContains $_.Name -AND $ShowProperty -contains $_.name })
                    }
                }

                for ($i = 0; $i -lt $props.Count; $i++) {
                    $prop = $props[$i]
                    $IsLast[-1] = ($i -eq $props.count - 1) -and (-Not $HasChildItems)
                    #30 May 2024 better accommodate binary values in the registry
                    if ($prop.Value -is [byte[]]) {
                        $Value = 'Binary or byte array'
                    }
                    else {
                        $Value = $prop.Value
                    }
                    $showParams = @{
                        Name   = $prop.Name
                        Value  = $Value
                        IsLast = $IsLast
                    }
                    ShowProperty @showParams
                }
            }
            Write-Verbose "Ending $($MyInvocation.MyCommand)"
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

            Write-Verbose "Starting $($MyInvocation.MyCommand) on $Path"
            $PSBoundParameters | Out-String | Write-Verbose
            if ($IsLast.Count -gt $Depth) { return }

            $childItems = @()
            if ($IsLast.Count -lt $Depth) {
                try {
                    $rPath = Resolve-Path -LiteralPath $Path -ErrorAction stop
                }
                catch {
                    Throw "Failed to resolve $path. This PSProvider and path may be incompatible with this command."
                    #bail out
                    return
                }
                $childItems = @(Get-ChildItem $rPath -ErrorAction $ErrorActionPreference |
                    Where-Object { $ShowItem -or $_.PSIsContainer })
            }
            $hasChildItems = $childItems.Count -gt 0

            # Show the current container
            $sParams = @{
                path          = $Path
                name          = $Name
                IsLast        = $IsLast
                hasChildItems = $hasChildItems
                Color         = $Color
                ItemType      = If ($isTop) { 'TopContainer' } else { 'ChildContainer' }
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
                        Path     = $childItem.PSPath
                        Name     = $name
                        IsLast   = $IsLast
                        Color    = $Color
                        ItemType = 'File'
                    }
                    ShowItem @iParams
                }
            }
            Write-Verbose "Ending $($MyInvocation.MyCommand)"
        }
    } #begin

    Process {
        Write-Verbose "Detected parameter set $($PSCmdlet.ParameterSetName)"
        if ($PSCmdlet.ParameterSetName -eq 'Path') {
            # In the -Path (non-literal) resolve path in case if it is wildcarded.
            $resolvedPaths = @($Path | Resolve-Path | ForEach-Object { $_.Path })
        }
        else {
            # Must be -LiteralPath
            $resolvedPaths = @($LiteralPath)
        }
        Write-Verbose 'Using these PSBoundParameters'
        $PSBoundParameters | Out-String | Write-Verbose

        foreach ($rPath in $resolvedPaths) {
            Write-Verbose "Processing $rPath"
            $showParams = @{
                Path  = $rPath
                Color = $colorize
                IsTop = $True
            }
            ShowContainer @showParams
        }
    } #process
    end {
        Write-Verbose "Ending $($MyInvocation.MyCommand)"
    }
}
