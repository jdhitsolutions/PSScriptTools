Class DirectoryStat {
    [string]$Name
    [string]$Path
    [int64]$FileCount
    [int64]$FileSize
    [string]$Parent
    [string]$Computername = [System.Environment]::MachineName
} #close class definition

#function that use the class
Function Get-DirectoryInfo {
    [cmdletbinding()]
    [alias("dw")]
    [OutputType("DirectoryStat")]
    Param(
        [Parameter(Position = 0,HelpMessage = "Specify the top level path.")]
        [ValidateScript( { (Test-Path $_ ) -AND ((Get-Item $_).PSProvider.name -eq "FileSystem") })]
        [string]$Path = ".",
        [Parameter(HelpMessage = " The Depth parameter determines the number of subdirectory
    levels to recursively query.")]
        [int32]$Depth
    )

    Begin {
        Write-Verbose "Starting $($MyInvocation.MyCommand)"

        #initialize a collection to hold the results
        $data = [System.Collections.Generic.list[object]]::new()

        function _newDirectoryStat {
            [CmdletBinding()]
            Param(
                [Parameter(ValueFromPipelineByPropertyName, Mandatory)]
                [string]$PSPath
            )

            Begin {}
            Process {
                $path = Convert-Path $PSPath
                $name = Split-Path -Path $Path -Leaf
                $stat = Get-ChildItem -Path $path -File | Measure-Object -Property Length -Sum

                $ds = [DirectoryStat]::New()
                $ds.Name = $name
                $ds.Path = $Path
                $ds.FileCount = $stat.Count
                $ds.FileSize = $stat.Sum
                $ds.Parent = (Get-Item -Path $path).Parent.FullName
                $ds
            }
            end {}
        }

        Write-Verbose "PSBoundParameters"
        Write-Verbose ($PSBoundParameters | Out-String)
        #build a hashtable of parameters to splat to Get-ChildItem
        $gciParams = @{
            Path      = $Path
            Directory = $True
        }
        if ($PSBoundParameters["Depth"]) {
            $gciParams.Add("Depth", $PSBoundParameters["Depth"])
            $gciParams.Add("Recurse",$True)
        }

    } #begin
    Process {
        Write-Verbose "Processing $(Convert-Path $Path)"
        #add each result as a DirectoryStat object to the collection
        $data.Add((Get-ChildItem @gciParams | _newDirectoryStat))

    } #Process

    End {
        <#
        Use ForEach-Object to write individual DirectoryStat objects
        to the pipeline. Otherwise the output from this command is System.Object[].
        I'll also pre-sort the results alphabetically.
        #>
        $data | ForEach-Object {$_} | Sort-Object -Property Parent, Name
        Write-Verbose "Ending $($MyInvocation.MyCommand)"
    }
}

#define additional type extensions
Update-TypeData -TypeName DirectoryStat -MemberType ScriptProperty -MemberName NameCount -value {"$($this.name) [$($this.filecount)]"} -force
Update-TypeData -TypeName DirectoryStat -MemberType ScriptProperty -MemberName NameSize -Value { "$($this.name) [$($this.filesize)]" } -force

Update-TypeData -TypeName DirectoryStat -DefaultDisplayProperty NameCount -force
Update-TypeData -TypeName DirectoryStat -DefaultDisplayPropertySet Path,Name,FileCount,FileSize,Parent -Force
