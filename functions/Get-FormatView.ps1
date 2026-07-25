#display a listing of all defined formatting views

function Get-FormatView {
    [cmdletbinding()]
    [alias('gfv')]
    [OutputType('PSFormatView')]
    param(
        [Parameter(HelpMessage = 'Specify a typename such as System.Diagnostics.Process.', ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [string]$TypeName = '*',
        [Parameter(HelpMessage = 'Specify the version of PowerShell this cmdlet uses for the formatting data. Enter a two digit number separated by a period.')]
        [system.version]$PowerShellVersion = $PSVersionTable.PSVersion
    )
    begin {
        #tags are used for categorizing the command
        #cmdTags = general
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Starting $($MyInvocation.MyCommand)"
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Running under PowerShell version $($PSVersionTable.PSVersion)"
        #a regular expression pattern to match on the format type
        [regex]$rx = 'Table|List|Wide|Custom'
    } #begin

    process {
        try {
            $data = Get-FormatData -TypeName $Typename -PowerShellVersion $PowerShellVersion -ErrorAction Stop | Sort-Object -Property TypeName
        }
        catch {
            throw $_
        }
        if ($data) {
            Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Found $($data.count) type definitions"
            #$data | Out-String | Write-Verbose
            foreach ($item in $data) {
                #there might be a collection of TypeNames
                foreach ($tn in $item.TypeNames) {
                    #$tn | out-string | write-verbose

                    Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Getting formatting view for $($tn)"
                    foreach ($view in $item.FormatViewDefinition) {
                        [PSCustomObject]@{
                            PSTypename = 'PSFormatView'
                            Format     = $rx.Match($view.Control).value
                            Name       = $view.name
                            Typename   = $tn
                        }
                    }
                } #foreach tn
            } #foreach item
        } #if data

    } #process

    end {
        Write-Verbose "[$((Get-Date).TimeOfDay) END    ] Ending $($MyInvocation.MyCommand)"
    } #end

} #close Get-FormatView
#EOF
