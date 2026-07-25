
<#
Modified 9/29/2020 so that Invoke-Command doesn't attempt to create a remoting session to the local machine.
#Issue 90
#>
function Get-WindowsVersion {
    [cmdletbinding()]
    [OutputType('WindowsVersion')]
    [alias('wver')]

    param (
        [Parameter(
            Position = 0,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName
        )]
        [ValidateNotNullOrEmpty()]
        [string[]]$Computername = $env:COMPUTERNAME,
        [ValidateNotNullOrEmpty()]
        [PSCredential]$Credential,
        [switch]$UseSSL,
        [Int32]$ThrottleLimit,
        [ValidateSet('Default', 'Basic', 'Credssp', 'Digest', 'Kerberos', 'Negotiate', 'NegotiateWithImplicitCredential')]
        [ValidateNotNullOrEmpty()]
        [string]$Authentication = 'default'
    )

    begin {
        #tags are used for categorizing the command
        #cmdTags = general
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Starting $($MyInvocation.MyCommand)"
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Running under PowerShell version $($PSVersionTable.PSVersion)"

        $sb = {
            $RegPath = 'HKLM:\SOFTWARE\Microsoft\Windows nt\CurrentVersion\'
            <#
            9/15/2022 JDH
            Revised to use `systeminfo to retrieve the operating system name and
            if that fails, fall back to using the registry entry.
            The registry entry for Windows 11 typically still shows Windows 10.
            #>
            $regData = Get-ItemProperty -Path $RegPath

            <#
            30 May 2024 It appears that SystemInfo is localized so I can't assume "OS Name"
            will always be the property name. I am trusting the output order will always be the
            same. Issue #142
            #>
            $tmpCsv = [system.io.path]::GetTempFileName()
            Start-Process systeminfo -ArgumentList '/fo csv' -Wait -WindowStyle Hidden -RedirectStandardOutput $tmpCSV
            if ((Get-Item $tmpCSV).Length -gt 0) {
                #$OSName = Import-CSV $tmpCsv | Select-Object -expand "OS Name"
                $in = Import-Csv $tmpCsv
                #getting properties from the PSObject
                $OSName = $in.PSObject.Properties | Select-Object -Skip 1 -First 1 -ExpandProperty Value
                Remove-Item -Path $tmpCsv
            }
            else {
                $OSName = $regData.ProductName
            }
            $regData | Select-Object -Property @{Name = 'ProductName'; Expression = { $OSName } }, EditionID, ReleaseID, BuildBranch,
            @{Name = 'Build'; Expression = { "$($_.CurrentBuild).$($_.UBR)" } }, DisplayVersion,
            @{Name = 'InstalledUTC'; Expression = { ([datetime]'1/1/1601').AddTicks($_.InstallTime) } },
            @{Name = 'Computername'; Expression = { $env:computername } }

        } #close scriptblock

        #update PSBoundParameters so it can be splatted to Invoke-Command
        [void]$PSBoundParameters.Add('ScriptBlock', $sb)

    } #begin

    process {
        if (Test-IsPSWindows) {
            if ($Computername -eq $ENV:Computername) {
                Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Processing the local host"
                #remove all any passed parameters
                'Credential', 'UseSSL', 'ThrottleLimit', 'Authentication' | ForEach-Object {
                    if ($PSBoundParameters.ContainsKey($_)) {
                        Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Removing parameter $_"
                        [void]($PSBoundParameters.Remove($_))
                    }
                }
            }
            else {
                [void]$PSBoundParameters.add('HideComputername', $True)
            }
            Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Invoking command"

            $PSBoundParameters | Out-String | Write-Verbose
            $results = Invoke-Command @PSBoundParameters | Select-Object -Property * -ExcludeProperty RunspaceID, PS*
            if ($Results) {
                foreach ($item in $results) {
                    [PSCustomObject]@{
                        PSTypeName     = 'WindowsVersion'
                        ProductName    = $item.ProductName
                        ReleaseVersion = $item.DisplayVersion
                        EditionID      = $item.EditionID
                        ReleaseID      = $item.ReleaseID
                        Build          = $item.Build
                        Branch         = $item.BuildBranch
                        InstalledUTC   = $item.InstalledUTC
                        Computername   = $item.Computername
                    }
                }
            }
        }
        else {
            Write-Warning 'This command requires a Windows platform'
        }

    } #process

    end {
        Write-Verbose "[$((Get-Date).TimeOfDay)END    ] Ending $($MyInvocation.MyCommand)"
    } #end
} #close function


function Get-WindowsVersionString {
    [cmdletbinding()]
    [OutputType('System.String')]
    [alias('wvers')]
    param (
        [Parameter(
            Position = 0,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName
        )]
        [ValidateNotNullOrEmpty()]
        [string[]]$Computername = $env:COMPUTERNAME,
        [PSCredential]$Credential,
        [switch]$UseSSL,
        [Int32]$ThrottleLimit,
        [ValidateSet('Default', 'Basic', 'Credssp', 'Digest', 'Kerberos', 'Negotiate', 'NegotiateWithImplicitCredential')]
        [ValidateNotNullOrEmpty()]
        [string]$Authentication = 'default',
        [Parameter(HelpMessage = 'Display an ANSI styled string.')]
        [switch]$UseStyle
    )

    begin {
        #tags are used for categorizing the command
        #cmdTags = general,ansi
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Starting $($MyInvocation.MyCommand)"
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Running under PowerShell version $($PSVersionTable.PSVersion)"
        $styleHash = @{
            CN      = "$([char]27)[93m"
            Version = "$([char]27)[92;3m"
            Build   = "$([char]27)[96m"
            Reset   = "$([char]27)[0m"
        }
        if ($PSBoundParameters.ContainsKey('UseStyle')) {
            [void]($PSBoundParameters.Remove('UseStyle'))
        }
    } #begin

    process {
        Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Calling Get-WindowsVersion"
        $results = Get-WindowsVersion @PSBoundParameters

        #write a version string for each computer
    `   foreach ($result in $results) {
            if ($UseStyle) {
                '{4}{3}{7} {5}{0} Version {1}{7} {6}(OS Build {2}){7}' -f $result.ProductName, $result.EditionID, $result.build, $result.computername, $styleHash.CN, $styleHash.Version, $styleHash.Build, $styleHash.Reset
            }
            else {
                '{3} {0} Version {1} (OS Build {2})' -f $result.ProductName, $result.EditionID, $result.build, $result.computername
            }
        }
    } #process

    end {
        Write-Verbose "[$((Get-Date).TimeOfDay) END    ] Ending $($MyInvocation.MyCommand)"
    } #end
}
#EOF
