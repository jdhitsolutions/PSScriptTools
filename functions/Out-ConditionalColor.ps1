
Function Out-ConditionalColor {

    [cmdletbinding(DefaultParameterSetName = "property")]
    [alias("occ")]

    Param(
        [Parameter(Position = 0, Mandatory,
            HelpMessage = "Enter an hashtable of conditional properties and colors.",
            ParameterSetName = "property")]
        [ValidateScript( {
                #validate colors
                $allowed = [enum]::GetNames([system.consolecolor])
                $bad = $_.Values | Where-Object {$allowed -notcontains $_}
                if ($bad) {
                    $valid = $allowed -join ','
                    Throw "You are using one or more invalid colors: $($bad -join ','). Valid colors are $Valid"
                }    
                else {
                    $True
                }
            })]
        [hashtable]$PropertyConditions,

        [Parameter(Mandatory, HelpMessage = "Enter a property name.",
            ParameterSetName = "property")]
        [string]$Property,

        [Parameter(Position = 0, Mandatory,
            HelpMessage = "Enter an ordered hashtable of conditions and colors.",
            ParameterSetName = "conditions")]
        [System.Collections.Specialized.OrderedDictionary]$Conditions,

        [Parameter(Mandatory, ValueFromPipeline)]
        [PSObject[]]$InputObject

    )

    Begin {
        Write-Debug "Starting $($MyInvocation.MyCommand)"
        write-Debug "Using parameter set $($pscmdlet.ParameterSetName)"
        #save original color
        $saved = $Host.UI.RawUI.ForegroundColor
    
        Write-Debug "Original foreground color is $saved"  
   
        if ($PSCmdlet.ParameterSetName -eq 'conditions') {
            #we'll need this later in the Process script block
            #if doing complex processing
            Write-Debug "Getting hash table enumerator and names"
            $compare = $conditions.GetEnumerator().name
            Write-Debug $($compare | out-string)
            #build an If/ElseIf construct on the fly
            #the Here strings must be left justified
            $If = @"
 if ($($compare[0])) {
  `$host.ui.RawUI.ForegroundColor = '$($conditions.item($($compare[0])))'
 }
"@
            #now add the remaining comparisons as ElseIf
            for ($i = 1; $i -lt $conditions.count; $i++) {
                $If += "elseif ($($compare[$i])) { 
         `$host.ui.RawUI.ForegroundColor = '$($conditions.item($($compare[$i])))'
         }
         "
            } #for

            #add the final else
            $if += @"
Else { 
`$host.ui.RawUI.ForegroundColor = `$saved 
}
"@

            Write-Debug "Complex comparison:"
            Write-Debug $If
        } #if complex parameter set   

    } #Begin

    Process {

        If ($PSCmdlet.ParameterSetName -eq 'conditions') {
            #Use complex processing
            Invoke-Expression $if
        } #end complex
        else {
            #get property value as a string
            $value = $Inputobject.$Property.ToString()
            Write-Debug "Testing property value $value"
            if ($PropertyConditions.containsKey($value)) {
                Write-Debug "Property match"
                $host.ui.RawUI.ForegroundColor = $PropertyConditions.item($value)
            }
            else {
                #use orginal color
                Write-Debug "No matches found"
                $host.ui.RawUI.ForegroundColor = $saved
            }        
        } #simple

        #write the object to the pipeline
        Write-Debug "Write the object to the pipeline"
        $_
    } #Process

    End {
        Write-Debug "Restoring original foreground color"
        #set color back
        $host.ui.RawUI.ForegroundColor = $saved
    } #end

} #close function

