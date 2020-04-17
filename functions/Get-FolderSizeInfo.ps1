
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
                    #need to account for errors when accessing folders without permissions
                    #a function to recurse and get all non-hidden directories

                    Function _enumdir {
                        [cmdletbinding()]
                        Param([string]$Path, [switch]$Hidden)
                        # write-host $path -ForegroundColor cyan
                        $path = Convert-Path -literalpath $path
                        $ErrorActionPreference = "Stop"
                        try {
                            $di = [System.IO.DirectoryInfo]::new($path)
                            if ($hidden) {
                                $top = $di.GetDirectories()
                            }
                            else {
                                $top = ($di.GetDirectories()).Where( {$_.attributes -notmatch "hidden"})
                            }
                            $top
                            foreach ($t in $top) {
                                $params = @{
                                    Path   = $t.fullname
                                    Hidden = $Hidden
                                }
                                _enumdir @params
                            }
                        }
                        Catch {
                            Write-Warning "Failed on $path. $($_.exception.message)."
                        }
                    } #enumdir

                    # get files in the root of the folder
                    if ($hidden) {
                        Write-Verbose "Including hidden files"
                        $data = $d.GetFiles()
                    }
                    else {
                        #get files in current location
                        $data = $($d.GetFiles()).Where({$_.attributes -notmatch "hidden"})
                    }

                    if ($data.count -gt 1) {
                        $files.AddRange($data)
                    }
                    elseif ($data.count -eq 1) {
                        [void]($files.Add($data))
                    }

                    #get a list of all non-hidden subfolders
                    Write-Verbose "Getting subfolders (Hidden = $Hidden)"
                    $eParam = @{
                        Path   = $cpath
                        Hidden = $hidden
                    }
                    $all = _enumdir @eparam

                    #get the files in each subfolder
                    Write-Verbose "Getting files from $($all.count) subfolders"

                    ($all).Foreach( {
                            Write-Verbose $_.fullname
                            $ErrorActionPreference = "Stop"
                            Try {
                                if ($hidden) {
                                    $data = (([System.IO.DirectoryInfo]"$($_.fullname)").GetFiles())
                                }
                                else {
                                    $data = (([System.IO.DirectoryInfo]"$($_.fullname)").GetFiles()).where({$_.Attributes -notmatch "Hidden"})
                                }
                                if ($data.count -gt 1) {
                                    $files.AddRange($data)
                                }
                                elseif ($data.count -eq 1) {
                                    [void]($files.Add($data))
                                }
                            }
                            Catch {
                                Write-Warning "Failed on $path. $($_.exception.message)."
                                #clearing the variable as a precaution
                                Clear-variable data
                            }
                        })
                } #else 5.1

                If ($files.count -gt 0) {
                    Write-Verbose "Found $($files.count) files"
                    # there appears to be a bug with the array list in Windows PowerShell
                    # where it doesn't always properly enumerate. Passing the list
                    # items via ForEach appears to solve the problem and doesn't
                    # adversely affect PowerShell 7. Addeed in v2.22.0. JH
                    $stats = $files.foreach( {$_}) | Measure-Object -property length -sum
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
            } #test path
            else {
                Write-Warning "Can't find $Path on $([System.Environment]::MachineName)"
            }

        } #foreach item
    } #process
    End {
        Write-Verbose "Ending $($MyInvocation.MyCommand)"
    }
} #close function

<#
C:\Windows from Explorer
Contains 206345 files
contains 61817 folders
total size 30.6gb
size on disk 30.7 gb
#>