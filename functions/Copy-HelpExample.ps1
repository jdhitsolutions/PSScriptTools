
Function Copy-HelpExample {
    [cmdletbinding()]
    [alias("che")]
    Param(
        [Parameter(
            Position = 0,
            Mandatory,
            HelpMessage = "Enter the name of the PowerShell command"
        )]
        [ValidateScript({
            If (Get-Command $_) {
                $True
            }
            else {
                Throw "Can't find a command called $_"
            }
        })]
        [string]$Name,

        [Parameter(
            HelpMessage = "Gets help that explains how the cmdlet works in the specified provider path. Enter a PowerShell provider path."
        )]
        [ValidateScript({Test-Path $_})]
        [string]$Path
    )
    DynamicParam {
        if ($IsWindows -OR ($PSEdition -eq "Desktop")) {

            #The dynamic parameter name
            $paramName = "UseGridView"

            #define a parameter attribute object
            $attributes = New-Object System.Management.Automation.ParameterAttribute
            $attributes.HelpMessage = "Select help examples using Out-Gridview."

            #define a collection for attributes
            $attributeCollection = New-Object -Type System.Collections.ObjectModel.Collection[System.Attribute]
            $attributeCollection.Add($attributes)

            #define an alias
            $alias = [System.Management.Automation.AliasAttribute]::new("ogv")
            $attributeCollection.Add($alias)

            #define the dynamic param
            $dynParam1 = New-Object -Type System.Management.Automation.RuntimeDefinedParameter($paramName, [Switch], $attributeCollection)

            #create array of dynamic parameters
            $paramDictionary = New-Object -Type System.Management.Automation.RuntimeDefinedParameterDictionary
            $paramDictionary.Add($paramName, $dynParam1)

            #use the array
            return $paramDictionary
        } #if
    } #dynamic param

    Begin {
        Write-Verbose "Starting $($myinvocation.mycommand)"

        #A regex pattern to strip off prompts, comments and empty lines from the code sample
        $rx = [System.Text.RegularExpressions.Regex]::new("(PS.*>)|(#.*)|(^\s$)", "Multiline")
        #adjust PSBoundParameters
        $PSBoundParameters.Add("Examples", $True)
        if ($PSBoundParameters.ContainsKey("UseGridView")) {
            #remove this parameter from PSBoundParameters because it doesn't belong to Get-Help
            [void]($PSBoundParameters.Remove("UseGridView"))
            #set a flag
            $ogv = $True
        }
    } #begin
    Process {
        Write-Verbose "Getting help examples for $Name"

        $help = Get-Help @PSBoundParameters

        if ($help.examples.example.count -gt 0) {
            $choices = $help.examples.example | Select-Object -Property Title,
            @{Name = "CodeSample"; Expression = {($rx.replace($_.code, "")).trim()}}

            #force the ISE to use Out-Gridview
            if ($ogv -OR ($host.name -match "PowerShell ISE")) {
                Write-Verbose "Launching Out-Gridview"
                $choices | Out-GridView -Title "Select one or more code samples to copy" -PassThru |
                ForEach-Object {$_.codeSample} | Set-Clipboard
            } #if gridview
            else {
                #Use console menu
                $hash = @{}
$head = @"

$([char]0x1b)[1;4mCode Samples$([char]0x1b)[0m

Each help example is numbered to the left. At the prompt below,
select the code samples you want to copy to the clipboard. Separate
multiple values with a comma.

Some example code includes the output.

"@

            $head

            for ($i= 0;$i -lt $choices.count;$i++) {
                "`r"
                "$([char]0x1b)[96m[$($i+1)]$([char]0x1b)[0m $($choices[$i].title.trim())"
                "`r"
                "    $($choices[$i].codesample)"
                #add the sample to the temporary hashtable
                $hash.add(($i+1).tostring(),$choices[$i].codesample)
            }

            #prompt the user for a choice
            $r = Read-Host "`n$([char]0x1b)[38;5;46mPlease select items to copy to the clipboard by number. Separate multiple entries with a comma. Press Enter alone to cancel$([char]0x1b)[0m"

            if ($r -match ",") {
                $items = $r.split(",")
            }
            elseif ($r -match "\d") {
                $items = $r
            }
            else {
                Write-Verbose "You must have cancelled."
            }
            #initialize a list to hold the choices
            $select = [System.Collections.Generic.List[string]]::new()

            if ($items) {
                foreach ($item in $items) {
                    Write-Verbose "getting item $item"
                    $select.add($hash.item($item))
                }
            }
            #copy all the selections to the clipboard
            $select | Set-Clipboard

            } #use console
    } #if help examples found
    else {
        Write-Warning "No help or examples found for $Name"
    }
    } #process
    End {
        Write-Verbose "Ending $($myinvocation.mycommand)"
    } #end
} #end function
