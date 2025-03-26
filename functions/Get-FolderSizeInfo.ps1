Function Get-FolderSizeInfo {
    [cmdletbinding()]
    [alias('gsi')]
    [OutputType('FolderSizeInfo')]

    Param(
        [Parameter(
            Position = 0,
            Mandatory,
            HelpMessage = 'Enter a file system path like C:\Scripts.',
            ValueFromPipeline,
            ValueFromPipelineByPropertyName
        )]
        [ValidateNotNullOrEmpty()]
        [alias('PSPath')]
        [string[]]$Path,
        [Parameter(HelpMessage = 'Include hidden directories')]
        [switch]$Hidden,
        [Parameter(HelpMessage = 'Enable support for long file and folder names.')]
        [alias('lfn', 'EnableLN')]
        [switch]$EnableLongFileName
    )

    Begin {
        Write-Verbose "Starting $($MyInvocation.MyCommand)"

        #a function to recurse and get all non-hidden directories
        #This function will only be called on Windows PowerShell systems.
        Function _EnumDir {
            [cmdletbinding()]
            Param([string]$Path, [switch]$Hidden)
            # write-host $path -ForegroundColor cyan
            $path = Convert-Path -LiteralPath $path
            $ErrorActionPreference = 'Stop'
            try {
                $di = [System.IO.DirectoryInfo]::new($path)
                if ($hidden) {
                    $top = ($di.GetDirectories()).Where( { $_.attributes -NotMatch 'ReparsePoint'})
                }
                else {
                    $top = ($di.GetDirectories()).Where( { $_.attributes -NotMatch 'hidden|ReparsePoint' })
                }
                $top
                foreach ($t in $top) {
                    $params = @{
                        Path   = $t.FullName
                        Hidden = $Hidden
                    }
                    _EnumDir @params
                }
            }
            Catch {
                Write-Warning "Failed on $path. $($_.exception.message)."
            }
        } # _EnumDir
    } #Begin

    Process {
        foreach ($item in $path) {
            #Enable long file name support Issue #134
            if ($EnableLongFileName) {
                Write-Verbose 'Enabling long file name support'
                $item = if ($item -match '^\\\\') {
                    "\\?\UNC\$($item.substring(2))"
                }
                else {
                    "\\?\$item"
                }
            }
            #need to convert to file system paths
            $cPath = (Convert-Path -LiteralPath $item)
            Write-Verbose "Measuring $cPath on $([System.Environment]::MachineName)"

            if (Test-Path -LiteralPath $cPath) {
                $d = [System.IO.DirectoryInfo]::new($cPath)

                #Changed from ArrayList to generic list 28 Feb 2023 JDH
                #suggestion from @ScriptingStudio Issue #134
                #[System.Collections.ArrayList]::new()
                $files = [System.Collections.Generic.list[System.IO.FileInfo]]::New()

                If ($PSVersionTable.PSVersion.major -gt 5  ) {
                    #this .NET class is not available in Windows PowerShell 5.1
                    $opt = [System.IO.EnumerationOptions]::new()
                    $opt.RecurseSubdirectories = $True

                    if ($hidden) {
                        Write-Verbose 'Including hidden files'
                        $opt.AttributesToSkip = 'SparseFile', 'ReparsePoint'
                    }
                    else {
                        $opt.AttributesToSkip = 'Hidden','SparseFile', 'ReparsePoint'
                    }
                    Write-Verbose "Skipping attributes $($opt.AttributesToSkip)"
                    [System.IO.FileInfo[]]$data = $($d.GetFiles('*', $opt))
                    Write-Verbose "Found $($data.count) files(s)"
                    if ($data -AND $data.count -gt 1) {
                        $files.AddRange($data)
                    }
                    elseif ($data -AND $data.count -eq 1) {
                        $files.Add($data[0])
                    }

                } #if newer than Windows PowerShell 5.1
                else {
                    Write-Verbose 'Using legacy code'
                    #need to account for errors when accessing folders without permissions

                    # get files in the root of the folder
                    if ($hidden) {
                        Write-Verbose 'Including hidden files'
                        $data = $d.GetFiles()
                    }
                    else {
                        #get files in current location
                        $data = $($d.GetFiles()).Where({ $_.attributes -NotMatch 'hidden|ReparsePoint' })
                    }

                    Write-Verbose "Found $($data.count) files"
                    if ($data -AND $data.count -gt 1) {
                        $files.AddRange([System.IO.FileInfo[]]$data)
                    }
                    elseif ($data -AND $data.count -eq 1) {
                        $files.Add($data[0])
                    }

                    #get a list of all non-hidden sub-folders
                    Write-Verbose "Getting sub-folders (Hidden = $Hidden)"
                    $eParam = @{
                        Path   = $cPath
                        Hidden = $hidden
                    }
                    $all = _EnumDir @eParam

                    #get the files in each subfolder
                    if ($all) {
                        Write-Verbose "Getting files from $($all.count) sub-folders"

                    ($all).Foreach( {
                            $currentFolder = $_.FullName
                            Write-Verbose $CurrentFolder
                            $ErrorActionPreference = 'Stop'
                            Try {
                                if ($hidden) {
                                    $data = (([System.IO.DirectoryInfo]$CurrentFolder).GetFiles())
                                }
                                else {
                                    $data = (([System.IO.DirectoryInfo]$CurrentFolder).GetFiles()).where({ $_.Attributes -NotMatch 'Hidden' })
                                }
                                Write-Verbose "Found $($data.count) files"
                                if ($data -AND $data.count -gt 1) {
                                    $files.AddRange([System.IO.FileInfo[]]$data)
                                }
                                elseif ($data -AND $data.count -eq 1) {
                                    $files.Add($data[0])
                                }
                            }
                            Catch {
                                Write-Warning "Failed on $CurrentFolder. $($_.exception.message)."
                                #clearing the variable as a precaution
                                Clear-Variable data
                            }
                        })
                    } #if $all
                } #else 5.1

                If ($files.count -gt 0) {
                    Write-Verbose "Found $($files.count) total files"
                    $stats = $Files | Measure-Object -Property length -Sum
                    $totalFiles = $stats.count
                    $totalSize = $stats.sum
                }
                else {
                    Write-Verbose 'Found an empty folder'
                    $totalFiles = 0
                    $totalSize = 0
                }

                [PSCustomObject]@{
                    PSTypename   = 'FolderSizeInfo'
                    Computername = [System.Environment]::MachineName
                    Path         = $cPath
                    Name         = $(Split-Path -Path $cPath -Leaf)
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