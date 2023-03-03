#functions to get and modify the ANSI file map

if ($IsCoreCLR) {
    $escString = "``e"
    $esc = "`e"
}
else {
    $escString = "`$([char]27)"
    $esc = $([char]27)
}

Function Get-PSAnsiFileMap {
    [cmdletbinding()]
    [OutputType("PSAnsiFileEntry")]
    Param( )
    Begin {
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Starting $($MyInvocation.MyCommand)"
    } #begin

    Process {
        if ($host.name -match 'PowerShell ISE') {
            Write-Warning "This command doesn't work properly in the PowerShell ISE."
            #bail out
            return
        }
        Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Getting ANSIFile map from `$PSAnsiFileMap "
        if ($PSAnsiFileMap) {
            $PSAnsiFileMap | ForEach-Object {
                [PSCustomObject]@{
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
        Write-Verbose "[$((Get-Date).TimeOfDay) END    ] Ending $($MyInvocation.MyCommand)"
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
        [switch]$PassThru
    )
    Begin {
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Starting $($MyInvocation.MyCommand)"
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
                Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Updating $Description"
                $index = $PSAnsiFileMap.FindIndex( { $args[0].description -eq $Description })
                if ($Pattern -AND ($PSCmdlet.ShouldProcess($Description, "Set pattern $pattern"))) {
                    $PSAnsiFileMap.Item($index).Pattern = $pattern
                }
                if ($Ansi -AND ($PSCmdlet.ShouldProcess($Description, "Set Ansi pattern"))) {
                    $PSAnsiFileMap.Item($index).ansi = $ansi
                }
            }
            else {
                Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Adding $Description"
                $new = [PSCustomObject]@{
                    PSTypename  = "PSAnsiFileEntry"
                    Description = $Description
                    Pattern     = $Pattern
                    Ansi        = $ansi
                }
                If ($PSCmdlet.ShouldProcess($Description, "Add PSAnsiFileMapEntry")) {
                    $global:PSAnsiFileMap.Add($new)
                }
            }
            if ($PassThru -AND (-Not $WhatIfPreference)) { Get-PSAnsiFileMap }
        }
        else {
            Write-Warning "You need to specify a pattern and/or ANSI sequence."
        }
    } #process

    End {
        Write-Verbose "[$((Get-Date).TimeOfDay) END    ] Ending $($MyInvocation.MyCommand)"
    } #end

} #close Set-PSAnsiFileMap


Function Export-PSAnsiFileMap {
    [cmdletbinding(SupportsShouldProcess)]
    [OutputType("None", "System.IO.FileInfo")]
    Param(
        [switch]$PassThru
    )
    Begin {
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Starting $($MyInvocation.MyCommand)"
        $Path = Join-Path -Path $HOME -ChildPath "psansifilemap.json"
    } #begin

    Process {
        if ($host.name -match 'PowerShell ISE') {
            Write-Warning "This command doesn't work properly in the PowerShell ISE."
            #bail out
            return
        }
        Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS]  Exporting to $Path "
        if ($PSCmdlet.ShouldProcess($path)) {
            $PSAnsiFileMap | ConvertTo-Json | Out-File -FilePath $Path
            If ($PassThru) {
                Get-Item -Path $Path
            }
        }
    } #process

    End {
        Write-Verbose "[$((Get-Date).TimeOfDay) END    ] Ending $($MyInvocation.MyCommand)"
    } #end

} #close Export-PSAnsiFileMap


Function Remove-PSAnsiFileEntry {
    [cmdletbinding(SupportsShouldProcess)]
    [OutputType("None", "PSAnsiFileEntry")]
    Param(
        [Parameter(Position = 0, Mandatory, HelpMessage = "Specify the description of the entry to remove.")]
        [ArgumentCompleter( { $global:PSAnsiFileMap.Description })]
        [string]$Description,
        [switch]$PassThru
    )
    Begin {
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Starting $($MyInvocation.MyCommand)"
    } #begin

    Process {
        if ($host.name -match 'PowerShell ISE') {
            Write-Warning "This command doesn't work properly in the PowerShell ISE."
            #bail out
            return
        }
        if ($global:PSAnsiFileMap.description -contains $Description) {
            Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Removing entry for $Description"
            if ($PSCmdlet.ShouldProcess($Description)) {
                $index = $PSAnsiFileMap.FindIndex( { $args[0].description -eq $Description })
                $PSAnsiFileMap.RemoveAt($index)
                if ($PassThru -AND (-Not $WhatIfPreference)) { Get-PSAnsiFileMap }
            }
        }
        else {
            Write-Warning "Can't find an entry for $Description"
        }
    } #process

    End {
        Write-Verbose "[$((Get-Date).TimeOfDay) END    ] Ending $($MyInvocation.MyCommand)"
    } #end

} #close Remove-PSAnsiFileEntry