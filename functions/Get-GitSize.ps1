
function Get-GitSize {
    [cmdletbinding()]
    [OutputType('gitSize')]
    param (
        [Parameter(
            Position = 0,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName
        )]
        [alias('PSPath')]
        [ValidateScript({ Test-Path $_ })]
        [string]$Path = '.'
    )

    begin {
        #tags are used for categorizing the command
        #cmdTags = scripting

        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Starting $($MyInvocation.MyCommand)"
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Running under PowerShell version $($PSVersionTable.PSVersion)"
    } #begin
    process {
        $full = Convert-Path -Path $Path
        Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Processing path $full"
        $git = Join-Path -Path $full -ChildPath '.git'
        Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Testing $git"
        if (Test-Path -Path $git) {
            Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Measuring $git"
            #get the total size of all files in the .git folder
            #$stat = Get-ChildItem -Path $git -Recurse -File | Measure-Object -Property length -sum
            #1 March 2023 - switched to Get-FolderSizeInfo which is faster -JDH
            $stat = Get-FolderSizeInfo -Path $git -Hidden
            [PSCustomObject]@{
                PSTypeName   = 'gitSize'
                Name         = (Split-Path -Path $full -Leaf)
                Path         = $full
                Files        = $stat.TotalFiles
                Size         = $stat.TotalSize
                Date         = (Get-Date)
                Computername = [System.Environment]::MachineName
            } #customobject

        } #if test-Path
        else {
            Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Did not find $git"
        }
    } #process
    end {
        Write-Verbose "[$((Get-Date).TimeOfDay) END    ] Ending $($MyInvocation.MyCommand)"
    } #end
}

#EOF
