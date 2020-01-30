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
            $cPath = (Convert-Path $item)
            Write-Verbose "Measuring $cPath on $([System.Environment]::MachineName)"

            if (Test-Path $cPath) {

                $d = [System.IO.DirectoryInfo]::new($cPath)

                If ($psversiontable.psversion.major -gt 5  ) {
                    #this .NET class is not available in Windows PowerShell 5.1
                    $opt = [System.IO.EnumerationOptions]::new()
                    $opt.RecurseSubdirectories = $True

                    if ($hidden) {
                        Write-Verbose "Including hidden files"
                        $opt.AttributesToSkip = "SparseFile", "ReparsePoint"
                    }

                    $files = $d.GetFiles("*",$opt)
                } #if newer that Windows PowerShell 5.1
                else {
                    Write-Verbose "Using legacy code"
                    if ($hidden) {
                        Write-Verbose "Including hidden files"
                        $files = $d.GetFiles("*","AllDirectories")
                    }
                    else {

                        $files = ($d.GetFiles()).Where({$_.attributes -notmatch "hidden"})
                        #a function to recurse and get all non-hidden directories
                        Function _enumdir {
                            [cmdletbinding()]
                            Param([string]$Path)
                            # write-host $path -ForegroundColor cyan
                            $di = [System.IO.DirectoryInfo]::new($path)
                            $top = ($di.GetDirectories()).Where({$_.attributes -notmatch "hidden"})
                            $top
                            foreach ($t in $top) {
                                _enumdir $t.fullname
                            }
                        }
                        #get a list of all non-hidden subfolders
                        Write-Verbose "Getting non-hidden subfolders"
                        $all = _enumdir $cpath
                        #get the files in each subfolder
                        Write-Verbose "Getting files from subfolders"
                        ($all).Foreach({ $files+= ([System.IO.DirectoryInfo]"$($_.fullname)").GetFiles() | where-object {$_.Attributes -notmatch "Hidden"}})
                    } #get non-hidden files
                }

                Write-Verbose "Found $($files.count) files"
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