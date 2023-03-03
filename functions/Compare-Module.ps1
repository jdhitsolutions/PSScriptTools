
Function Compare-Module {

    [cmdletbinding()]
    [OutputType("PSCustomObject")]
    [alias("cmo")]

    Param (
        [Parameter(
            Position = 0,
            ValueFromPipelineByPropertyName
        )]
        [ValidateNotNullOrEmpty()]
        [Alias("modulename")]
        [string]$Name,
        [ValidateNotNullOrEmpty()]
        [string]$Gallery = "PSGallery"
    )

    Begin {

        Write-Verbose "[BEGIN  ] Starting: $($MyInvocation.MyCommand)"

        $progParam = @{
            Activity         = $MyInvocation.MyCommand
            Status           = "Getting installed modules"
            CurrentOperation = "Get-Module -ListAvailable"
            PercentComplete  = 25
        }

        Write-Progress @progParam

    } #begin

    Process {

        $gmoParams = @{
            ListAvailable = $True
        }
        if ($Name) {
            $gmoParams.Add("Name", $Name)
        }

        $installed = Get-Module @gmoParams

        if ($installed) {

            $progParam.Status = "Getting online modules"
            $progParam.CurrentOperation = "Find-Module -repository $Gallery"
            $progParam.PercentComplete = 50
            Write-Progress @progParam

            $fmoParams = @{
                Repository  = $Gallery
                ErrorAction = "Stop"
            }
            if ($Name) {
                $fmoParams.Add("Name", $Name)
            }
            Try {
                $online = @(Find-Module @fmoParams)
            }
            Catch {
                Write-Warning "Failed to find online module(s). $($_.Exception.message)"
            }
            $progParam.status = "Comparing $($installed.count) installed modules to $($online.count) online modules."
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
            Write-Warning "No local module or modules found"
        }
    } #Progress

    End {
        Write-Verbose "[END    ] Ending: $($MyInvocation.MyCommand)"
    } #end

} #close function

