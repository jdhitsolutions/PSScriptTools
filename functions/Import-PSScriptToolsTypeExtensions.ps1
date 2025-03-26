Function Import-PSScriptToolsTypeExtension {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('None')]
    Param(
        [Parameter(
            Position = 0,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName,
            HelpMessage = 'The TypeName of the custom type extension set'
        )]
        [ValidateNotNullOrEmpty()]
        [Alias('Type')]
        [SupportsWildcards()]
        [string]$TypeName = '*'
    )

    Begin {
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Starting $($MyInvocation.MyCommand)"
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Running under PowerShell version $($PSVersionTable.PSVersion)"
    } #begin

    Process {
        Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Importing $TypeName"
        $obj = Get-PSScriptToolsTypeExtension -TypeName $TypeName
        Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Found $($obj.Count) type extensions"
        foreach ($o in $obj) {
            Update-TypeData -AppendPath $obj.Path
        }
    } #process

    End {
        Write-Verbose "[$((Get-Date).TimeOfDay) END    ] Ending $($MyInvocation.MyCommand)"
    } #end

} #close

Function Get-PSScriptToolsTypeExtension {
    [cmdletbinding()]
    [OutputType('PSScriptToolsTypeExtension')]
    Param(
        [Parameter(
            Position = 0,
            ValueFromPipeline,
            HelpMessage = 'The name of the custom type extension set'
        )]
        [ValidateNotNullOrEmpty()]
        [SupportsWildcards()]
        [string]$TypeName = '*'
    )

    Begin {
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Starting $($MyInvocation.MyCommand)"
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Running under PowerShell version $($PSVersionTable.PSVersion)"
    } #begin

    Process {
        Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Getting PSScriptTools Type Extension $TypeName"

        Get-ChildItem -Path $PSScriptRoot\..\optional-typeextensions\*.ps1xml | ForEach-Object {
            [xml]$t = Get-Content -Path $_.FullName

            $members = $t.types.type.members.ChildNodes |
            Sort-Object LocalName |
            Select-Object @{Name = 'MemberType'; Expression = { $_.LocalName } },
            @{Name = 'MemberName'; Expression = { $_.Name } }

            [PSCustomObject]@{
                PSTypeName  = 'PSScriptToolsTypeExtension'
                Type        = $t.types.type.name
                Description = $t.'#comment'.Trim()
                Members     = $Members
                Path        = $_.FullName
            }
        } | Where-Object { $_.Type -like $TypeName } | Sort-Object Type

    } #process

    End {
        Write-Verbose "[$((Get-Date).TimeOfDay) END    ] Ending $($MyInvocation.MyCommand)"
    } #end

} #close
