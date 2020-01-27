
Function Save-GitSetup {

    [CmdletBinding()]
    Param(
        [Parameter(Position = 0,HelpMessage = "Specify the location to store the downloaded file")]
        [ValidateNotNullOrEmpty()]
        [ValidateScript({ Test-Path $_ })]
        [string]$Path = $env:TEMP,
        [Parameter(HelpMessage = "Show the downloaded file.")]
        [switch]$Passthru
    )

    if ($isWindows) {

        Try {
            [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

            #download the latest 64bit version of Git for Windows
            $uri = 'https://git-scm.com/download/win'

            Write-Verbose "Getting latest version of git from $uri"
            #get the web page
            $page = Invoke-WebRequest -Uri $uri -UseBasicParsing -DisableKeepAlive -ErrorAction Stop

            #get the download link
            $dl = ($page.links | Where-Object outerhtml -match 'git-.*-64-bit.exe' | Select-Object -first 1 * ).href
            Write-Verbose "Found download link $dl"

            #split out the filename
            $filename = Split-Path $dl -leaf

            #construct a filepath for the download
            $out = Join-Path -Path $path -ChildPath $filename
            Write-Verbose "Downloading $out from $dl"

            #download the file
            Try {
                Invoke-WebRequest -uri $dl -OutFile $out -UseBasicParsing -DisableKeepAlive -ErrorAction Stop
            }
            Catch {
                Throw $_
            }
        } #try

        Catch {
            Throw $_
        }
        Write-Verbose "Download complete"
        if ($Passthru) {
            Get-Item -Path $out
        }
    } #if windows
    else {
        Write-Warning "This command is intended for x64 Windows platforms."
    }
} #end function
