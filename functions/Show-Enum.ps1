function Show-Enum {
    [CmdletBinding()]
    [OutputType('enumInfo')]
    param(
        [Parameter(
            Position = 0,
            Mandatory,
            ValueFromPipelineByPropertyName,
            HelpMessage = 'Specify an enum type name like ConsoleColor'
        )]
        [ValidateScript({
            if (($_ -as [Type]).BaseType.Name -eq 'enum') {
                return $true
            }
            else {
                Write-Warning "[$_] does not appear to be an Enum."
                return $False
            }
        }
        )]
        [alias('Class', 'PropertyType')]
        [Type]$EnumType
    )
    begin {
        #tags are used for categorizing the command
        #cmdTags = scripting

        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Starting $($MyInvocation.MyCommand)"
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Running under PowerShell version $($PSVersionTable.PSVersion)"
    } #begin
    process {
        Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Analyzing $($EnumType.FullName)"

        [Enum]::GetNames($EnumType) | ForEach-Object {
            #Create a custom object
            [PSCustomObject]@{
                PSTypeName = 'enumInfo'
                Typename   = $EnumType.FullName
                Name       = $_
                Value      = [int]($_ -as $EnumType)
            }
        } #foreach
    } #process
    end {
        Write-Verbose "[$((Get-Date).TimeOfDay) END    ] Ending $($MyInvocation.MyCommand)"
    } #end
}

function Test-IsEnum {
    [cmdletbinding()]
    [OutputType('Boolean')]
    param(
        [Parameter(
            Position = 0,
            Mandatory,
            ValueFromPipelineByPropertyName,
            HelpMessage = 'Specify an enum type name like ConsoleColor'
        )]
        [alias('Class', 'PropertyType')]
        [Type]$EnumType
    )
    begin {
        #tags are used for categorizing the command
        #cmdTags = scripting
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Starting $($MyInvocation.MyCommand)"
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Running under PowerShell version $($PSVersionTable.PSVersion)"
    } #begin
    process {
        Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Analyzing $($EnumType.FullName)"
        $enumType.IsEnum
    }
    end {
        Write-Verbose "[$((Get-Date).TimeOfDay) END    ] Ending $($MyInvocation.MyCommand)"
    } #end
}
#EOF
