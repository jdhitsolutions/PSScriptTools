
function Copy-HelpExample {
    [cmdletbinding()]
    [alias('che')]
    param(
        [Parameter(
            Position = 0,
            Mandatory,
            HelpMessage = 'Enter the name of the PowerShell command'
        )]
        [ValidateScript({
                if (Get-Command $_) {
                    $True
                }
                else {
                    throw "Can't find a command called $_"
                }
            })]
        [string]$Name,

        [Parameter(
            HelpMessage = 'Gets help that explains how the cmdlet works in the specified provider path. Enter a PowerShell provider path.'
        )]
        [ValidateScript({ Test-Path $_ })]
        [string]$Path
    )
    dynamicparam {
        if ($IsWindows -or ($PSEdition -eq 'Desktop')) {

            #The dynamic parameter name
            $paramName = 'UseGridView'

            #define a parameter attribute object
            $attributes = New-Object System.Management.Automation.ParameterAttribute
            $attributes.HelpMessage = 'Select help examples using Out-GridView.'

            #define a collection for attributes
            $attributeCollection = New-Object -Type System.Collections.ObjectModel.Collection[System.Attribute]
            $attributeCollection.Add($attributes)

            #define an alias
            $alias = [System.Management.Automation.AliasAttribute]::new('ogv')
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

    begin {
        Write-Verbose "Starting $($MyInvocation.MyCommand)"

        #A regex pattern to strip off prompts, comments and empty lines from the code sample
        $rx = [System.Text.RegularExpressions.Regex]::new('(PS.*>)|(#.*)|(^\s$)', 'Multiline')

        #8 July 2026 Added to parse code samples from PowerShell 7 help
        #[regex]$codeRx = '(?<=powershell\n).*(?=\n```)'
        $codeRx = [System.Text.RegularExpressions.Regex]::new('(?<=powershell\n).*(?=\n```)', 'Multiline')
        #adjust PSBoundParameters
        $PSBoundParameters.Add('Examples', $True)
        if ($PSBoundParameters.ContainsKey('UseGridView')) {
            #remove this parameter from PSBoundParameters because it doesn't belong to Get-Help
            [void]($PSBoundParameters.Remove('UseGridView'))
            #set a flag
            $ogv = $True
        }
    } #begin
    process {
        Write-Verbose "Getting help examples for $Name"

        $help = Get-Help @PSBoundParameters

        if ($help.examples.example.count -gt 0) {
            #8 July 2026 Help in PowerShell 7 is structured differently

            if ($help.examples.example.code -match "\w+") {
                $choices = $help.examples.example | Select-Object -Property Title,
                @{Name = 'CodeSample'; Expression = { ($rx.replace($_.code, '')).trim() } }
            }
            elseif ($help.examples.example.introduction -match "```powershell" ) {
                 $choices = $help.examples.example | Select-Object -Property Title,
                @{Name = 'CodeSample'; Expression = { ($codeRx.Match($_.introduction.text)).value.trim() } }
            }

            #force the ISE to use Out-GridView
            if ($ogv -or ($host.name -match 'PowerShell ISE')) {
                Write-Verbose 'Launching Out-GridView'
                $choices | Out-GridView -Title 'Select one or more code samples to copy' -PassThru |
                ForEach-Object { $_.CodeSample } | Set-Clipboard
            } #if GridView
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

                for ($i = 0; $i -lt $choices.count; $i++) {
                    <#
                        8 July 2026 Some help files put the code sample in the remarks or introduction.
                        this may be more of an issue in PowerShell 7
                    #>
                    if ($choices[$i].CodeSample) {
                        "`r"
                        "$([char]0x1b)[96m[$($i+1)]$([char]0x1b)[0m $($choices[$i].title.trim())"
                        "`r"
                        "    $($choices[$i].CodeSample)"
                        #add the sample to the temporary hashtable
                        $hash.add(($i + 1).ToString(), $choices[$i].CodeSample)
                    }
                }

                if ($hash.Keys.count -gt 0) {

                    #prompt the user for a choice
                    $r = Read-Host "`n$([char]0x1b)[38;5;46mPlease select items to copy to the clipboard by number. Separate multiple entries with a comma. Press Enter alone to cancel$([char]0x1b)[0m"

                    if ($r -match ',') {
                        $items = $r.split(',')
                    }
                    elseif ($r -match '\d') {
                        $items = $r
                    }
                    else {
                        Write-Verbose 'You must have cancelled.'
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
                }
                else {
                    Write-Warning "This command doesn't have code examples that you can copy with this command."
                }
            } #use console
        } #if help examples found
        else {
            Write-Warning "No help or examples found for $Name"
        }
    } #process
    end {
        Write-Verbose "Ending $($MyInvocation.MyCommand)"
    } #end
} #end function
