Function Compare-Script {

    [cmdletbinding()]
    [OutputType("PSCustomObject")]
    [alias("csc")]

    Param (
        [Parameter(
            Position = 0,
            ValueFromPipelineByPropertyName
        )]
        [ValidateNotNullorEmpty()]
        [Alias("scriptname")]
        [string]$Name,
        [ValidateNotNullorEmpty()]
        [string]$Gallery = "PSGallery"
    )

    Begin {

        Write-Verbose "[BEGIN  ] Starting: $($MyInvocation.Mycommand)"

        $progParam = @{
            Activity         = $MyInvocation.MyCommand
            Status           = "Getting installed scripts"
            CurrentOperation = "Get-InstalledScript"
            PercentComplete  = 25
        }

        Write-Progress @progParam

    } #begin

    Process {

        $gscParams = @{}
        if ($Name) {
            $gscParams.Add("Name", $Name)
        }

        $installed = @(Get-InstalledScript @gscParams)

        if ($installed) {

            $progParam.Status = "Getting online scripts"
            $progParam.CurrentOperation = "Find-Script -Repository $Gallery"
            $progParam.PercentComplete = 50
            Write-Progress @progParam

            $fscParams = @{
                Repository  = $Gallery
                ErrorAction = "Stop"
            }
            if ($Name) {
                $fscParams.Add("Name", $Name)
            }
            Try {
                $online = @(Find-Script @fscParams)
            }
            Catch {
                Write-Warning "Failed to find online script(s). $($_.Exception.message)"
            }
            $progParam.status = "Comparing $($installed.count) installed scripts to $($online.count) online scripts."
            $progParam.percentComplete = 80
            Write-Progress @progParam

            $data = ($online).Where( {$installed.name -contains $_.name}) |
                Select-Object -property Name,
            @{Name = "OnlineVersion"; Expression = {$_.Version}},
            @{Name = "InstalledVersion"; Expression = {
                    #save the name from the incoming online object
                    $name = $_.Name
                    $installed.Where( {$_.name -eq $name}).Version -join ","}
            },
            PublishedDate,
            @{Name = "UpdateNeeded"; Expression = {
                    $name = $_.Name
                    #there could be multiple versions installed
                    #only need to compare the last one
                    $mostRecentVersion = $installed.Where( {$_.name -eq $name}).Version |
                    Sort-Object -Descending | Select-Object -first 1

                    #need to ensure that PowerShell compares version objects and not strings
                    If ([version]$_.Version -gt [version]$mostRecentVersion) {
                        $result = $True
                    }
                    else {
                        $result = $False
                    }
                    $result
                }
            } | Sort-Object -Property Name

            $progParam.PercentComplete = 100
            $progParam.Completed = $True
            Write-Progress @progparam

            #write the results to the pipeline
            $data
        }
        else {
            Write-Warning "No local script or scripts found"
        }
    } #Progress

    End {
        Write-Verbose "[END    ] Ending: $($MyInvocation.Mycommand)"
    } #end

} #close function
