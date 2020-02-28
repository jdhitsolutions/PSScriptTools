
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
            $cPath = (Convert-Path -literalpath $item)
            Write-Verbose "Measuring $cPath on $([System.Environment]::MachineName)"

            if (Test-Path -literalpath $cPath) {

                $d = [System.IO.DirectoryInfo]::new($cPath)

                $files = [system.collections.arraylist]::new()

                If ($psversiontable.psversion.major -gt 5  ) {
                    #this .NET class is not available in Windows PowerShell 5.1
                    $opt = [System.IO.EnumerationOptions]::new()
                    $opt.RecurseSubdirectories = $True

                    if ($hidden) {
                        Write-Verbose "Including hidden files"
                        $opt.AttributesToSkip = "SparseFile", "ReparsePoint"
                    }
                    else {
                        $opt.attributestoSkip = "Hidden"
                    }

                    $data = $($d.GetFiles("*", $opt))
                    if ($data.count -gt 1) {
                        $files.AddRange($data)
                    }
                    elseif ($data.count -eq 1) {
                        [void]($files.Add($data))
                    }

                } #if newer that Windows PowerShell 5.1
                else {
                    Write-Verbose "Using legacy code"
                    if ($hidden) {
                        Write-Verbose "Including hidden files"

                        $files.AddRange( $($d.GetFiles("*", "AllDirectories")) )
                    }
                    else {

                        $files.Addrange($($d.GetFiles()).Where( {$_.attributes -notmatch "hidden"}))
                        #a function to recurse and get all non-hidden directories
                        Function _enumdir {
                            [cmdletbinding()]
                            Param([string]$Path)
                            # write-host $path -ForegroundColor cyan
                            $path = Convert-Path -literalpath $path
                            $ErrorActionPreference = "Stop"
                            try {
                                $di = [System.IO.DirectoryInfo]::new($path)
                                $top = ($di.GetDirectories()).Where( {$_.attributes -notmatch "hidden"})
                                $top
                                foreach ($t in $top) {
                                    _enumdir $t.fullname
                                }
                            }
                            Catch {
                                Write-Warning "Failed on $path. $($_.exception.message)."
                            }
                        }
                        #get a list of all non-hidden subfolders
                        Write-Verbose "Getting non-hidden subfolders"
                        $all = _enumdir $cpath

                        #get the files in each subfolder
                        Write-Verbose "Getting files from subfolders"

                        ($all).Foreach( {
                                Write-Verbose $_.fullname
                                $ErrorActionPreference = "Stop"
                                Try {
                                    $data = (([System.IO.DirectoryInfo]"$($_.fullname)").GetFiles()).where( {$_.Attributes -notmatch "Hidden"})
                                    $files.AddRange($data)
                                }
                                Catch {
                                    Write-Warning "Failed on $path. $($_.exception.message)."
                                }
                            })
                    } #get non-hidden files
                }

                If ($files.count -gt 0) {
                    Write-Verbose "Found $($files.count) files"
                    $stats = $files | Measure-Object -property length -sum
                    $totalFiles = $stats.count
                    $totalSize = $stats.sum
                }
                else {
                    Write-Verbose "Found an empty folder"
                    $totalFiles = 0
                    $totalSize = 0
                }

                [pscustomobject]@{
                    PSTypename   = "FolderSizeInfo"
                    Computername = [System.Environment]::MachineName
                    Path         = $cPath
                    Name         = $(Split-Path $cpath -leaf)
                    TotalFiles   = $totalFiles
                    TotalSize    = $totalSize
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

