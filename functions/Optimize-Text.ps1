Function Optimize-Text {

    [cmdletbinding(DefaultParameterSetName = "default")]
    [OutputType([System.String], ParameterSetName = "default")]
    [OutputType([psobject], ParameterSetName = "object")]
    [Alias("ot")]

    Param(
        [Parameter(Position = 0, HelpMessage = "Enter some text", ValueFromPipeline, ParameterSetName = "default")]
        [Parameter(ParameterSetName = "object")]
        [string[]]$Text,

        [Parameter(ParameterSetName = "object")]
        [Parameter(ParameterSetName = "default")]
        [regex]$Filter,

        [Parameter(ParameterSetName = "object")]
        [string]$PropertyName,

        [Alias("comment")]
        [Parameter(ParameterSetName = "object")]
        [Parameter(ParameterSetName = "default")]
        [string]$Ignore,

        [Parameter(ParameterSetName = "object")]
        [Parameter(ParameterSetName = "default")]
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
