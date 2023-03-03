#requires -version 7.1

using namespace System.Collections.generic

Function Get-FileExtensionInfo {
    [cmdletbinding()]
    [alias("gfei")]
    [OutputType("FileExtensionInfo")]
    Param(
        [Parameter(Position = 0, HelpMessage = "Specify the root directory path to search")]
        [ValidateNotNullOrEmpty()]
        [ValidateScript( { Test-Path $_ })]
        [string]$Path = ".",
        [Parameter(HelpMessage = "Recurse through all folders.")]
        [switch]$Recurse,
        [Parameter(HelpMessage = "Include files in hidden folders")]
        [switch]$Hidden,
        [Parameter(HelpMessage = "Add the corresponding collection of files")]
        [Switch]$IncludeFiles
    )

    Begin {
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Starting $($MyInvocation.MyCommand)"

        #convert the path to a file system path
        $cPath = Convert-Path -Path $Path
        #capture the current date and time for the audit date
        $report = Get-Date
        Try {
            $enumOpt = [System.IO.EnumerationOptions]::new()
        }
        Catch {
            Throw "This commands requires PowerShell 7."
        }

        if ($Recurse) {
            Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Getting files recursively"
        }
        $enumOpt.RecurseSubdirectories = $Recurse
        if ($Hidden) {
            Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Including hidden files"
            $enumOpt.AttributesToSkip -= 2
        }
        #initialize a list to hold the results
        $list = [list[object]]::new()

    } #begin

    Process {
        Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Processing $cPath"
        $dir = Get-Item -Path $cpath
        $files = $dir.getfiles('*', $enumOpt)

        Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Found $($files.count) files"
        $group = $files | Group-Object -Property extension

        #Group and measure
        foreach ($item in $group) {
            Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Measuring $($item.count) $($item.name) files"
            $measure = $item.Group | Measure-Object -Property length -Minimum -Maximum -Average -Sum

            #create a custom object
            $out = [PSCustomObject]@{
                PSTypeName   = "FileExtensionInfo"
                Path         = $cPath
                Extension    = $item.Name
                Count        = $item.Count
                TotalSize    = $measure.Sum
                SmallestSize = $measure.Minimum
                LargestSize  = $measure.Maximum
                AverageSize  = $measure.Average
                Computername = [system.environment]::MachineName
                ReportDate   = $report
                Files        = $IncludeFiles ? $item.group : $null
                IsLargest    = $False
            }
            $list.Add($out)
        }
    } #process

    End {
        #mark the extension with the largest total size
        ($list | Sort-Object -Property TotalSize,Count)[-1].IsLargest = $true
        #write the results to the pipeline
        $list
        Write-Verbose "[$((Get-Date).TimeOfDay) END    ] Ending $($MyInvocation.MyCommand)"
    } #end
}

Update-TypeData -TypeName FileExtensionInfo -MemberType AliasProperty -MemberName Total -Value TotalSize -Force

