
Function Get-WindowsVersion {

    [cmdletbinding()]
    [OutputType("custom object")]
    [alias('wver')]

    Param (
        [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string[]]$Computername = $env:COMPUTERNAME,
        [PSCredential]$Credential,
        [switch]$UseSSL,
        [Int32]$ThrottleLimit,
        [ValidateSet('Default', 'Basic', 'Credssp', 'Digest', 'Kerberos', 'Negotiate', 'NegotiateWithImplicitCredential')]
        [ValidateNotNullorEmpty()]
        [string]$Authentication = "default"
    )

    Begin {

        Write-Verbose "[BEGIN  ] Starting $($MyInvocation.Mycommand)"

        $sb = {
            $RegPath = 'HKLM:\SOFTWARE\Microsoft\Windows nt\CurrentVersion\'

            Get-ItemProperty -Path $RegPath | Select-Object -Property ProductName, EditionID, ReleaseID,
            @{Name = "Build"; Expression = {"$($_.CurrentBuild).$($_.UBR)"}},
            @{Name = "InstalledUTC"; Expression = { ([datetime]"1/1/1601").AddTicks($_.InstallTime) }},
            @{Name = "Computername"; Expression = {$env:computername}}

        } #close scriptblock

        #update PSBoundParameters so it can be splatted to Invoke-Command
        $PSBoundParameters.Add("ScriptBlock", $sb) | Out-Null
        $PSBoundParameters.add("HideComputername", $True) | Out-Null
    } #begin

    Process {
        if ((-NOT $IsWindows) -AND ($PSVersionTable.psedition -ne 'Desktop')) {
            Write-Warning "This requires a Windows platform"
            #bail out
            return
        }
        Write-Verbose "[PROCESS] Invoking command"
        if (-Not $PSBoundParameters.ContainsKey("Computername")) {
            #add the default value if nothing was specified
            $PSBoundParameters.Add("Computername", $Computername) | Out-Null
        }
        $PSBoundParameters | Out-String | Write-Verbose
        $results = Invoke-Command @PSBoundParameters | Select-Object -Property * -ExcludeProperty RunspaceID, PS*
        if ($Results) {
            foreach ($item in $results) {

                [pscustomobject]@{
                    PSTypeName   = "WindowsVersion"
                    ProductName  = $item.ProductName
                    EditionID    = $item.EditionID
                    Build        = $item.Build
                    InstalledUTC = $item.InstalledUTC
                    Computername = $item.Computername
                }
            }
        }

    } #process

    End {

        Write-Verbose "[END    ] Ending $($MyInvocation.Mycommand)"

    } #end
} #close function


Function Get-WindowsVersionString {

    [cmdletbinding()]
    [OutputType("system.string")]

    Param (
        [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string[]]$Computername = $env:COMPUTERNAME,
        [PSCredential]$Credential,
        [switch]$UseSSL,
        [Int32]$ThrottleLimit,
        [ValidateSet('Default', 'Basic', 'Credssp', 'Digest', 'Kerberos', 'Negotiate', 'NegotiateWithImplicitCredential')]
        [ValidateNotNullorEmpty()]
        [string]$Authentication = "default"
    )

    Begin {

        Write-Verbose "[BEGIN  ] Starting $($MyInvocation.Mycommand)"

    } #begin

    Process {
        Write-Verbose "[PROCESS] Calling Get-WindowsVersion"
        $results = Get-WindowsVersion @PSBoundParameters

        #write a version string for each computer
    `   foreach ($result in $results) {
            "{3} {0} Version {1} (OS Build {2})" -f $result.ProductName, $result.EditionID, $result.build,$result.computername
        }

    } #process

    End {
        Write-Verbose "[END    ] Ending $($MyInvocation.Mycommand)"
    } #end
}