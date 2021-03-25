#functions to get and modify the ANSI file map

if ($IsCoreCLR) {
    $escString = "``e"
    $esc = "`e"
}
else {
    $escString = "`$([char]0x1b)"
    $esc = $([char]0x1b)
}

Function Get-PSAnsiFileMap {
    [cmdletbinding()]
    [OutputType("PSAnsiFileEntry")]
    Param( )
    Begin {
        Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] Starting $($myinvocation.mycommand)"
    } #begin

    Process {
        if ($host.name -match 'PowerShell ISE') {
            Write-Warning "This command doesn't work properly in the PowerShell ISE."
            #bail out
            return
        }
        Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Getting ANSIFile map from `$PSAnsiFileMap "
        if ($PSAnsiFileMap) {
            $PSAnsiFileMap | ForEach-Object {
                [pscustomobject]@{
                    PSTypeName  = "PSAnsiFileEntry"
                    Description = $_.description
                    Pattern     = $_.pattern
                    ANSI        = $_.ansi -replace $esc, $escString
                }
            } #foreach
        } #if psansifilemap
        else {
            Write-Warning "Can't find the `$PSAnsiFileMap variable in this session. Have you imported the PSScriptTools module?"
        }
    } #process

    End {
        Write-Verbose "[$((Get-Date).TimeofDay) END    ] Ending $($myinvocation.mycommand)"
    } #end

} #close Get-PSAnsiFileMap

Function Set-PSAnsiFileMap {
    [cmdletbinding(SupportsShouldProcess)]
    [OutputType("None", "PSAnsiFileEntry")]
    Param(
        [Parameter(Position = 0, Mandatory, HelpMessage = "Specify the file map entry. If it is a new entry it will be added.")]
        [ArgumentCompleter({$global:PSAnsiFileMap.Description})]
        [string]$Description,
        [Parameter(HelpMessage = "Specify a regex pattern")]
        [string]$Pattern,
        [Parameter(HelpMessage = "Specify an ANSI escape sequence")]
        [string]$Ansi,
        [switch]$Passthru
    )
    Begin {
        Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] Starting $($myinvocation.mycommand)"
    } #begin

    Process {
        if ($host.name -match 'PowerShell ISE') {
            Write-Warning "This command doesn't work properly in the PowerShell ISE."
            #bail out
            return
        }
        if (($PSBoundParameters.ContainsKey("Pattern")) -OR ($PSBoundParameters.ContainsKey("ansi"))) {
            #test if entry already exists
            if ($global:PSAnsiFileMap.description -contains $Description) {
                Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Updating $Description"
                $index = $PSAnsiFileMap.FindIndex( { $args[0].description -eq $Description })
                if ($Pattern -AND ($pscmdlet.shouldprocess($Description, "Set pattern $pattern"))) {
                    $PSAnsiFileMap.Item($index).Pattern = $pattern
                }
                if ($Ansi -AND ($pscmdlet.shouldprocess($Description, "Set Ansi pattern"))) {
                    $PSAnsiFileMap.Item($index).ansi = $ansi
                }
            }
            else {
                Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Adding $Description"
                $new = [pscustomobject]@{
                    PSTypename  = "PSAnsiFileEntry"
                    Description = $Description
                    Pattern     = $Pattern
                    Ansi        = $ansi
                }
                If ($pscmdlet.shouldprocess($Description, "Add PSAnsiFileMapEntry")) {
                    $global:PSAnsiFileMap.Add($new)
                }
            }
            if ($Passthru -AND (-Not $WhatIfPreference)) { Get-PSAnsiFileMap }
        }
        else {
            Write-Warning "You need to specify a pattern and/or ANSI sequence."
        }
    } #process

    End {
        Write-Verbose "[$((Get-Date).TimeofDay) END    ] Ending $($myinvocation.mycommand)"
    } #end

} #close Set-PSAnsiFileMap


Function Export-PSAnsiFileMap {
    [cmdletbinding(SupportsShouldProcess)]
    [OutputType("None", "System.IO.FileInfo")]
    Param(
        [switch]$Passthru
    )
    Begin {
        Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] Starting $($myinvocation.mycommand)"
        $Path = Join-Path -Path $HOME -ChildPath "psansifilemap.json"
    } #begin

    Process {
        if ($host.name -match 'PowerShell ISE') {
            Write-Warning "This command doesn't work properly in the PowerShell ISE."
            #bail out
            return
        }
        Write-Verbose "[$((Get-Date).TimeofDay) PROCESS]  Exporting to $Path "
        if ($PScmdlet.ShouldProcess($path)) {
            $PSAnsiFileMap | ConvertTo-Json | Out-File -FilePath $Path
            If ($Passthru) {
                Get-Item -Path $Path
            }
        }
    } #process

    End {
        Write-Verbose "[$((Get-Date).TimeofDay) END    ] Ending $($myinvocation.mycommand)"
    } #end

} #close Export-PSAnsiFileMap


Function Remove-PSAnsiFileEntry {
    [cmdletbinding(SupportsShouldProcess)]
    [OutputType("None", "PSAnsiFileEntry")]
    Param(
        [Parameter(Position = 0, Mandatory, HelpMessage = "Specify the description of the entry to remove.")]
        [ArgumentCompleter( { $global:PSAnsiFileMap.Description })]
        [string]$Description,
        [switch]$Passthru
    )
    Begin {
        Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] Starting $($myinvocation.mycommand)"
    } #begin

    Process {
        if ($host.name -match 'PowerShell ISE') {
            Write-Warning "This command doesn't work properly in the PowerShell ISE."
            #bail out
            return
        }
        if ($global:PSAnsiFileMap.description -contains $Description) {
            Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Removing entry for $Description"
            if ($pscmdlet.shouldProcess($Description)) {
                $index = $PSAnsiFileMap.FindIndex( { $args[0].description -eq $Description })
                $PSAnsiFileMap.RemoveAt($index)
                if ($Passthru -AND (-Not $WhatIfPreference)) { Get-PSAnsiFileMap }
            }
        }
        else {
            Write-Warning "Can't find an entry for $Description"
        }
    } #process

    End {
        Write-Verbose "[$((Get-Date).TimeofDay) END    ] Ending $($myinvocation.mycommand)"
    } #end

} #close Remove-PSAnsiFileEntry