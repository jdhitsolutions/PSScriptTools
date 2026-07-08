
Function Save-GitSetup {

    [CmdletBinding()]
    Param(
        [Parameter(Position = 0,HelpMessage = "Specify the location to store the downloaded file")]
        [ValidateNotNullOrEmpty()]
        [ValidateScript({ Test-Path $_ })]
        [string]$Path = $env:TEMP,

        [Parameter(HelpMessage = "Download the ARM64 standalone version")]
        [switch]$ARM64,

        [Parameter(HelpMessage = "Show the downloaded file.")]
        [switch]$PassThru
    )

    if ( (Test-IsPSWindows)) {

        Try {
            [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

            #download the latest 64bit version of Git for Windows
            # https://github.com/git-for-windows/git/releases/download/v2.55.0.windows.2/Git-2.55.0.2-64-bit.exe
            $uri = 'https://git-scm.com/install/windows'

            Write-Verbose "Getting latest version of git from $uri"
            #get the web page
            $page = Invoke-WebRequest -Uri $uri -UseBasicParsing -DisableKeepAlive -ErrorAction Stop
            Write-Information $page -Tags data
            #get the download link
            if ($ARM64) {
                Write-Verbose "Downloading ARM64"
                $dl = ($page.links | Where-Object outerHTML -match 'git-.*-Arm64.exe' | Select-Object -first 1 * ).href
            }
            else {
                Write-Verbose "Downloading x64"
                $dl = ($page.links | Where-Object outerHTML -match 'git-.*-64-bit.exe' | Select-Object -first 1 * ).href
            }
            Write-Information $dl -Tags data
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
        if ($PassThru) {
            Get-Item -Path $out
        }
    } #if windows
    else {
        Write-Warning "This command is intended for x64 Windows platforms."
    }
} #end function
