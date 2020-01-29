#requires -version 5.1

Function Get-FolderSizeInfo {

    [cmdletbinding()]
    [alias("gsi")]
    [OutputType("FolderSizeInfo")]

    Param(
        [Parameter(Position = 0, Mandatory, HelpMessage = "Enter a file system path like C:\Scripts.", ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [alias("PSPath")]
        [string[]]$Path,
        [Parameter(HelpMessage = "Include hidden directories")]
        [switch]$Hidden
    )

    Begin {
        Write-Verbose "Starting $($MyInvocation.MyCommand)"

    } #Begin

    Process {
        foreach ($item in $path) {
            Write-Verbose "Measuring $item on $([System.Environment]::MachineName)"

            $cPath = (Convert-Path $item)
            if (Test-Path $cPath) {

                $d = [System.IO.DirectoryInfo]::new($cPath)

                if ($hidden) {
                    $files = $d.GetFiles("*", "AllDirectories")
                }
                else {
                    $files = $d.GetFiles()
                }
                $stats = $files | Measure-Object -property length -sum

                [pscustomobject]@{
                    PSTypename   = "FolderSizeInfo"
                    Computername = [System.Environment]::MachineName
                    Path         = $cPath
                    TotalFiles   = $stats.Count
                    TotalSize    = $stats.Sum
                }
            }
            else {
                Write-Warning "Can't find $Path on $([System.Environment]::MachineName)"
            }

        } #foreach item
    } #process
    End {
        Write-Verbose "Ending $($MyInvocation.MyCommand)"
    }
} #close function

#load format data file if found
$fmt = "$PSScriptRoot\FolderSizeInfo.format.ps1xml"

if (Test-Path $fmt) {
Update-FormatData -AppendPath $fmt
}