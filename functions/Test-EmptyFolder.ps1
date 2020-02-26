Function Test-EmptyFolder {
    [CmdletBinding()]
    [OutputType("Boolean", "EmptyFolder")]

    Param(
        [Parameter(Position = 0, Mandatory, HelpMessage = "Enter a file system path like C:\Scripts.", ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [alias("PSPath")]
        [string[]]$Path,
        [Parameter(HelpMessage = "Write a test object to the pipeline")]
        [switch]$Passthru
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

                If ($psversiontable.psversion.major -gt 5  ) {
                    #this .NET class is not available in Windows PowerShell 5.1
                    $opt = [System.IO.EnumerationOptions]::new()
                    $opt.RecurseSubdirectories = $True
                    $opt.AttributesToSkip = "SparseFile", "ReparsePoint"

                    $files = $d.GetFiles("*", $opt)
                } #if newer that Windows PowerShell 5.1
                else {
                    Write-Verbose "Using legacy code"
                    $files = $d.GetFiles("*", "AllDirectories")
                }

                If ($files.count -eq 0) {
                    $Empty = $True
                }
                else {
                    Write-Verbose "Found $($files.count) files"
                    $Empty = $False
                }
                if ($Passthru) {
                    [PSCustomObject]@{
                        PSTypeName = 'EmptyFolder'
                        Path       = $cPath
                        Name       = (Split-Path -Path $Cpath -leaf)
                        IsEmpty    = $Empty
                    }
                }
                else {
                    $Empty
                }
            }
            else {
                Write-Warning "Can't find $Path on $([System.Environment]::MachineName)"
            }
        } #foreach item
    }
    End {
        Write-Verbose "Ending $($MyInvocation.MyCommand)"
    }
}