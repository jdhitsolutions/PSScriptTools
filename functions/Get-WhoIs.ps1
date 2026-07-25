function Get-WhoIs {
    [cmdletbinding()]
    [OutputType('WhoIsResult')]
    param (
        [parameter(Position = 0,
            Mandatory,
            HelpMessage = 'Enter an IPV4 address to lookup with WhoIs',
            ValueFromPipeline,
            ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [ValidatePattern('^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$')]
        [ValidateScript( {
            #verify each octet is valid to simplify the regex
            $test = ($_.split('.')).where({ [int]$_ -gt 255 })
            if ($test) {
                throw "$_ does not appear to be a valid IPv4 address."
                $false
            }
            else {
                $true
            }
            })]
        [string]$IPAddress
    )

    begin {
        #tags are used for categorizing the command
        #cmdTags = general
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Starting $($MyInvocation.MyCommand)"
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Running under PowerShell version $($PSVersionTable.PSVersion)"
        $baseURL = 'http://whois.arin.net/rest'
        #default is XML anyway
        $header = @{'Accept' = 'application/xml' }
    } #begin

    process {
        Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Getting WhoIs information for $IPAddress"
        $url = "$baseUrl/ip/$IPAddress"
        try {
            $r = Invoke-RestMethod $url -Headers $header -ErrorAction stop
            Write-Verbose ($r.net | Out-String)
        }
        catch {
            $errMsg = "Sorry. There was an error retrieving WhoIs information for $IPAddress. $($_.exception.message)"
            $host.ui.WriteErrorLine($errMsg)
        }

        if ($r.net) {
            if ($r.net.orgRef) {
                Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Getting city information from $($r.net.orgRef.'#text')"
                $city = (Invoke-RestMethod $r.net.orgRef.'#text').org.city
            }
            else {
                $City = $Null
            }
            Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Creating result"

            [PSCustomObject]@{
                PSTypeName             = 'WhoIsResult'
                IP                     = $IPAddress
                Name                   = $r.net.name
                RegisteredOrganization = $r.net.orgRef.name
                City                   = $city
                StartAddress           = $r.net.StartAddress
                EndAddress             = $r.net.endAddress
                NetBlocks              = $r.net.netBlocks.netBlock | ForEach-Object { "$($_.StartAddress)/$($_.cidrLength)" }
                Updated                = $r.net.updateDate -as [datetime]
            }
        } #If $r.net
    } #Process

    end {
        Write-Verbose "[$((Get-Date).TimeOfDay) END    ] Ending $($MyInvocation.MyCommand)"
    } #end
}

#EOF
