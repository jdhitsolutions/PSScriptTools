Function Optimize-Text {

    [cmdletbinding(DefaultParameterSetName = "Default")]
    [OutputType([System.String], ParameterSetName = "Default")]
    [OutputType([psobject], ParameterSetName = "object")]
    [Alias("ot")]

    Param(
        [Parameter(Position = 0, HelpMessage = "Enter some text", ValueFromPipeline = $True)]
        [string[]]$Text,
        [regex]$Filter,
        [Parameter(ParameterSetName = "object")]
        [string]$PropertyName,
        [Alias("comment")]
        [string]$Ignore,
        [switch]$ToUpper
    )

    Begin {
        Write-Verbose "Starting $($MyInvocation.Mycommand)"  
 
    } #begin

    Process {
        foreach ($item in $text) {
            #filter out items that don't have at least one non-whitespace character
            if ($item -match "\S") {
                #trim spaces
                Write-Verbose "Trimming: $item"
                $output = $item.Trim()

                if ($Filter) {
                    Write-Verbose "Filtering"
                    $output = $output | where-object {$_ -match $filter}
                }

                #only continue if there is output
                if ($output) {
                    Write-Verbose "Post processing $output"
                    if ($ToUpper) {
                        $output = $output.toUpper()
                    } #if to upper

                    #filter out if using the comment character
                    if ($Ignore -AND ($output -match "^[\s+]?$Ignore")) {
                        Write-Verbose "Ignoring comment $output"
                    } #if ignore
                    else {
                        if ($PropertyName) {
                            #create a custom object with the specified property
                            New-Object -TypeName PSObject -Property @{$PropertyName = $Output}
                        }
                        else {
                            #just write the output to the pipeline
                            $output
                        }
                    } #else not ignoring
                } #if output
            } #if item matches non-whitespce
        } #foreach 

    } #process

    End {
        Write-Verbose "Ending $($MyInvocation.Mycommand)"
    } #end

} #end function
