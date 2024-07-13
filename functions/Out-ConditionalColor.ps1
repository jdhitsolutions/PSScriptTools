#9 June 2024 this command has been removed from the module
RETURN
Function Out-ConditionalColor {
    #This command is marked as deprecated 3/3/2023
    [cmdletbinding(DefaultParameterSetName = "property")]
    [alias("occ")]

    Param(
        [Parameter(Position = 0,
            Mandatory,
            HelpMessage = "Enter an hashtable of conditional properties and colors.",
            ParameterSetName = "property"
        )]
        [ValidateScript( {
                #validate colors
                $allowed = [enum]::GetNames([system.consolecolor])
                $bad = $_.Values | Where-Object {$allowed -NotContains $_}
                if ($bad) {
                    $valid = $allowed -join ','
                    Throw "You are using one or more invalid colors: $($bad -join ','). Valid colors are $Valid"
                }
                else {
                    $True
                }
            })]
        [hashtable]$PropertyConditions,

        [Parameter(
            Position = 1,
            Mandatory,
            HelpMessage = "Enter a property name.",
            ParameterSetName = "property"
            )]
        [string]$Property,

        [Parameter(
            Position = 0,
            Mandatory,
            HelpMessage = "Enter an ordered hashtable of conditions and colors.",
            ParameterSetName = "conditions"
            )]
        [System.Collections.Specialized.OrderedDictionary]$Conditions,

        [Parameter(Mandatory, ValueFromPipeline)]
        [PSObject[]]$InputObject
    )

    Begin {
        Write-Verbose "Starting $($MyInvocation.MyCommand)"
        Write-Verbose "Using parameter set $($PSCmdlet.ParameterSetName)"
        #save original color
        $saved = $host.UI.RawUI.ForegroundColor

        Write-Verbose "Original foreground color is $saved"

        if ($PSCmdlet.ParameterSetName -eq 'conditions') {
            #we'll need this later in the Process script block
            #if doing complex processing
            Write-Verbose "Getting hash table enumerator and names"
            $compare = $conditions.GetEnumerator().name
            Write-Verbose $($compare | Out-String)
            #build an If/ElseIf construct on the fly
            #the Here-strings must be left justified
            $If = @"
 if ($($compare[0])) {
  `$host.UI.RawUI.ForegroundColor = '$($conditions.item($($compare[0])))'
 }
"@
            #now add the remaining comparisons as ElseIf
            for ($i = 1; $i -lt $conditions.count; $i++) {
                $If += "elseif ($($compare[$i])) {
         `$host.UI.RawUI.ForegroundColor = '$($conditions.item($($compare[$i])))'
         }
         "
            } #for

            #add the final else
            $if += @"
Else {
`$host.UI.RawUI.ForegroundColor = `$saved
}
"@

            Write-Verbose "Complex comparison:"
            Write-Verbose $If
        } #if complex parameter set

    } #Begin

    Process {

        If ($PSCmdlet.ParameterSetName -eq 'conditions') {
            #Use complex processing
            Invoke-Expression $if
        } #end complex
        else {
            #get property value as a string
            $value = $InputObject.$Property.ToString()
            Write-Verbose "Testing property value $value"
            if ($PropertyConditions.ContainsKey($value)) {
                Write-Verbose "Property match"
                $host.UI.RawUI.ForegroundColor = $PropertyConditions.item($value)
            }
            else {
                #use orginal color
                Write-Verbose "No matches found"
                $host.UI.RawUI.ForegroundColor = $saved
            }
        } #simple

        #write the object to the pipeline
        Write-Verbose "Write the object to the pipeline"
        $_
    } #Process

    End {
        Write-Verbose "Restoring original foreground color"
        #set color back
        $host.UI.RawUI.ForegroundColor = $saved
    } #end

} #close function

