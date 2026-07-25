function Test-EmptyFolder {
    [CmdletBinding()]
    [OutputType('Boolean', 'EmptyFolder')]

    param(
        [Parameter(
            Position = 0,
            Mandatory,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName,
            HelpMessage = 'Enter a file system path like C:\Scripts.'
        )]
        [ValidateNotNullOrEmpty()]
        [alias('PSPath')]
        [string[]]$Path,
        [Parameter(HelpMessage = 'Write a test object to the pipeline')]
        [switch]$PassThru
    )

    begin {
        #tags are used for categorizing the command
        #cmdTags = file
        Write-Verbose "Starting $($MyInvocation.MyCommand)"
        Write-Verbose "Running under PowerShell version $($PSVersionTable.PSVersion)"
    } #Begin

    process {
        foreach ($item in $path) {
            $cPath = (Convert-Path -LiteralPath $item)
            Write-Verbose "Measuring $cPath on $([System.Environment]::MachineName)"

            if (Test-Path -LiteralPath $cPath) {

                $d = [System.IO.DirectoryInfo]::new($cPath)

                if ($PSVersionTable.PSVersion.major -gt 5 ) {
                    #this .NET class is not available in Windows PowerShell 5.1
                    $opt = [System.IO.EnumerationOptions]::new()
                    $opt.RecurseSubdirectories = $True
                    $opt.AttributesToSkip = 'SparseFile', 'ReparsePoint'

                    try {
                        $files = $d.GetFiles('*', $opt)
                    }
                    catch {
                        Write-Warning $_.exception.message
                    }
                } #if newer that Windows PowerShell 5.1
                else {
                    Write-Verbose 'Using legacy code'
                    try {
                        $files = $d.GetFiles('*', 'AllDirectories')
                    }
                    catch {
                        Write-Warning $_.exception.message
                    }
                }

                if ($files.count -eq 0) {
                    $Empty = $True
                }
                else {
                    Write-Verbose "Found $($files.count) files"
                    $Empty = $False
                }
                if ($PassThru) {
                    [PSCustomObject]@{
                        PSTypeName   = 'EmptyFolder'
                        Path         = $cPath
                        Name         = (Split-Path -Path $cPath -Leaf)
                        IsEmpty      = $Empty
                        Computername = [System.Environment]::MachineName
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
    end {
        Write-Verbose "Ending $($MyInvocation.MyCommand)"
    }
}
#EOF
