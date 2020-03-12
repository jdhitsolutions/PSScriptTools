
Function Get-GitSize {

    [cmdletbinding()]
    [Outputtype("gitSize")]
    Param (
        [Parameter(Position = 0, ValueFromPipeline, ValueFromPipelinebyPropertyName)]
        [alias("pspath")]
        [ValidateScript({Test-Path $_})]
        [string]$Path = "."
    )

    Begin {
        Write-Verbose "[$((Get-Date).TimeofDay) BEGIN] Starting $($myinvocation.mycommand)"
    } #begin
    Process {
        $full = Convert-Path -Path $Path
        Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Processing path $full"
        $git = Join-Path -Path $full -childpath ".git"
        Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Testing $git"
        if (Test-Path -path $git) {
            Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Measuring $git"
            #get the total size of all files in the .git folder
            $stat = Get-ChildItem -path $git -Recurse -File | Measure-Object -Property length -sum

            [PSCustomObject]@{
                PSTypeName   = "gitSize"
                Name         = (Split-Path -path $full -leaf)
                Path         = $full
                Files        = $stat.count
                Size         = $stat.sum
                Date         = (Get-Date)
                Computername = [System.Environment]::MachineName
            } #customobject

        } #if test-path
        else {
            Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Did not find $git"
        }
    } #process
    End {
        Write-Verbose "[$((Get-Date).TimeofDay) END    ] Ending $($myinvocation.mycommand)"
    } #end
}
