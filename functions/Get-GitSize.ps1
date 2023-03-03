
Function Get-GitSize {
    [cmdletbinding()]
    [OutputType("gitSize")]
    Param (
        [Parameter(Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [alias("pspath")]
        [ValidateScript({Test-Path $_})]
        [string]$Path = "."
    )

    Begin {
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN] Starting $($MyInvocation.MyCommand)"
    } #begin
    Process {
        $full = Convert-Path -Path $Path
        Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Processing path $full"
        $git = Join-Path -Path $full -ChildPath ".git"
        Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Testing $git"
        if (Test-Path -Path $git) {
            Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Measuring $git"
            #get the total size of all files in the .git folder
            #$stat = Get-ChildItem -Path $git -Recurse -File | Measure-Object -Property length -sum
            #1 March 2023 - switched to Get-FolderSizeInfo which is faster -JDH
            $stat = Get-FolderSizeInfo -Path $git -hidden
            [PSCustomObject]@{
                PSTypeName   = "gitSize"
                Name         = (Split-Path -Path $full -leaf)
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
    End {
        Write-Verbose "[$((Get-Date).TimeOfDay) END    ] Ending $($MyInvocation.MyCommand)"
    } #end
}
