
function Format-Percent {
    [cmdletbinding(DefaultParameterSetName = 'None')]
    [OutputType([Double], ParameterSetName = 'None')]
    [OutputType([String], ParameterSetName = 'String')]
    [alias('fp')]

    param(
        [Parameter(Position = 0, Mandatory, HelpMessage = 'What is the value?')]
        [ValidateNotNullOrEmpty()]
        [Alias('X', 'Numerator')]
        $Value,
        [Parameter(Position = 1, Mandatory, HelpMessage = 'What is the total value?')]
        [ValidateNotNullOrEmpty()]
        [Alias('Y', 'Denominator')]
        $Total,
        [ValidateNotNullOrEmpty()]
        [ValidateRange(0, 15)]
        [int]$Decimal = 2,
        [Parameter(ParameterSetName = 'String')]
        [Switch]$AsString
    )

    #tags are used for categorizing the command
    #cmdTags = format

    Write-Verbose "STARTING: $($MyInvocation.MyCommand)"
    Write-Verbose "RUNNING: PowerShell version $($PSVersionTable.PSVersion)"
    Write-Verbose "STATUS: Calculating percentage from $Value/$Total to $decimal places"
    $result = $Value / $Total

    if ($AsString) {
        Write-Verbose 'STATUS: Writing string result'
        #use the -F operator to build a percent string to X number of decimal places
        $pctString = "{0:p$Decimal}" -f $result
        #remove the space before the % symbol
        $pctString.Replace(' ', '')

    }
    else {
        Write-Verbose 'STATUS: Writing numeric result'
        #round the result to the specified number of decimal places
        [math]::Round( ($result * 100), $Decimal)
    }

    Write-Verbose "ENDING: $($MyInvocation.MyCommand)"

} #end function

function Format-Value {
    [cmdletbinding(DefaultParameterSetName = 'Default')]
    [alias('fv')]
    param(
        [Parameter(Position = 1, Mandatory, ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        $InputObject,
        [Parameter(Position = 0, ParameterSetName = 'Default')]
        [ValidateSet('KB', 'MB', 'GB', 'TB', 'PB')]
        [string]$Unit,
        [ValidateRange(0, 15)]
        [Parameter(ParameterSetName = 'Default')]
        [Parameter(ParameterSetName = 'Auto')]
        [Parameter(ParameterSetName = 'Number')]
        [int]$Decimal,
        [Parameter(ParameterSetName = 'Auto')]
        [switch]$Autodetect,
        [Parameter(ParameterSetName = 'Currency')]
        [switch]$AsCurrency,
        [Parameter(ParameterSetName = 'Number')]
        [switch]$AsNumber
    )

    begin {
        #tags are used for categorizing the command
        #cmdTags = format
        Write-Verbose "STARTING: $($MyInvocation.MyCommand)"
        Write-Verbose "RUNNING: PowerShell version $($PSVersionTable.PSVersion)"
        Write-Verbose "STATUS: Using parameter set $($PSCmdlet.ParameterSetName)"
    } #begin

    process {
        Write-Verbose "STATUS: Formatting $InputObject"

        <#
        divide the incoming value by the specified unit
        There is no need to process other statements so I'm using the Break keyword
        although in reality the rest of the statements wouldn't be processed anyway
        #>
        switch ($PSCmdlet.ParameterSetName) {
            'Default' {
                Write-Verbose "..as $Unit"
                switch ($Unit) {
                    'KB' { $value = $InputObject / 1KB ; break }
                    'MB' { $value = $InputObject / 1MB ; break }
                    'GB' { $value = $InputObject / 1GB ; break }
                    'TB' { $value = $InputObject / 1TB ; break }
                    'PB' { $value = $InputObject / 1PB ; break }
                    default {
                        #just use the raw value
                        $value = $InputObject
                    }
                } #default
            }
            'Auto' {
                Write-Verbose 'STATUS: Using Autodetect'

                if ($InputObject -ge 1PB) {
                    Write-Verbose '..as PB'
                    $value = $InputObject / 1PB
                }
                elseif ($InputObject -ge 1TB) {
                    Write-Verbose '..as TB'
                    $value = $InputObject / 1TB
                }
                elseif ($InputObject -ge 1GB) {
                    Write-Verbose '..as GB'
                    $value = $InputObject / 1GB
                }
                elseif ($InputObject -ge 1MB) {
                    Write-Verbose '..as MB'
                    $value = $InputObject / 1MB
                }
                elseif ($InputObject -ge 1KB) {
                    Write-Verbose '..as KB'
                    $value = $InputObject / 1KB
                }
                else {
                    Write-Verbose '..as bytes'
                    $value = $InputObject
                }
                break
            } #Auto
            'Currency' {
                Write-Verbose '...as currency'
                '{0:c}' -f $InputObject
                #if using currency no other code in the Process block will be run
                break
            }#Currency
            'Number' {
                Write-Verbose '...as number'
                #if -Decimal not used explicitly set it to 0
                if (-not $Decimal) {
                    $Decimal = 0
                }
                #format as a number to the specified number of decimal points
                "{0:n$($decimal)}" -f $InputObject
                break
            }
        } #switch parameterset name

        if ($PSCmdlet.ParameterSetName -notmatch 'Currency|Number') {
            Write-Verbose "STATUS: Reformatting $value"
            if ($decimal) {
                Write-Verbose "..to $decimal decimal places"
                #round the number to the specified number of decimal places
                [math]::Round($value, $decimal)
            }
            else {
                #if not a currency and not using a decimal then treat the value as an integer
                #and write the result to the pipeline
                Write-Verbose '..as [int]'
                $value -as [int]
            }
        } #parameter set <> currency
    } #process

    end {
        Write-Verbose "ENDING: $($MyInvocation.MyCommand)"
    } #end
}

function Format-String {
    [cmdletbinding()]
    [OutputType([string])]
    [alias('fs')]
    param(
        [Parameter(Position = 0, Mandatory, ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [string]$Text,
        [switch]$Reverse,
        [ValidateSet('Upper', 'Lower', 'Proper', 'Toggle', 'Alternate')]
        [string]$Case,
        [hashtable]$Replace,
        [switch]$Randomize
    )

    begin {
        #tags are used for categorizing the command
        #cmdTags = format
        Write-Verbose "STARTING: $($MyInvocation.MyCommand)"
        Write-Verbose "RUNNING: PowerShell version $($PSVersionTable.PSVersion)"
        Write-Verbose "STATUS: Using parameter set $($PSCmdlet.ParameterSetName)"
    } #begin

    process {
        Write-Verbose "STATUS: Processing $Text"
        if ($Reverse) {
            Write-Verbose "STATUS: Reversing $($Text.length) characters"
            $rev = for ($i = $Text.length; $i -ge 0 ; $i--) { $Text[$i] }
            #join the reverse array back into a string
            $str = $rev -join ''
        }
        else {
            #copy the Text value to this internal variable
            $str = $Text
        }

        if ($Randomize) {
            Write-Verbose 'STATUS: Randomizing text'
            #get a random number of characters that is the same length as the original string
            #and join them back together
            $str = ($str.ToCharArray() | Get-Random -Count $str.length) -join ''
        } #Randomize

        if ($Replace) {
            foreach ($key in $Replace.keys) {
                Write-Verbose "STATUS: Replacing $key with $($replace.item($key))"
                $str = $str.replace($key, $replace.item($key))
            } #foreach
        } #replace
        switch ($case) {
            'Upper' {
                Write-Verbose 'STATUS: Setting to upper case'
                $str = $str.ToUpper()
            } #upper
            'Lower' {
                Write-Verbose 'STATUS: Setting to lower case'
                $str = $str.ToLower()
            } #lower
            'Proper' {
                Write-Verbose 'STATUS: Setting to proper case'
                $str = '{0}{1}' -f $str[0].ToString().ToUpper(), -join $str.Substring(1).ToLower()
            } #proper
            'Alternate' {
                Write-Verbose 'STATUS: Setting to alternate case'
                $alter = for ($i = 0 ; $i -lt $str.length ; $i++) {
                    #Odd numbers are uppercase
                    if ($i % 2) {
                        $str[$i].ToString().ToLower()
                    }
                    else {
                        $str[$i].ToString().ToUpper()
                    }
                } #for
                $str = $alter -join ''
            } #alternate
            'Toggle' {
                Write-Verbose 'STATUS: setting to toggle case'
                <#
            use a regular expression pattern for a case sensitive match
            Other characters like ! and numbers will fail the test
            but the ToUpper() method will have no effect.
        #>

                #code to use methods from [CHAR] which should better handle other cultures
                $toggle = for ($i = 0 ; $i -lt $str.length ; $i++) {
                    if ([char]::IsUpper($str[$i])) {
                        $str[$i].ToString().ToLower()
                    }
                    else {
                        $str[$i].ToString().ToUpper()
                    }
                } #for
                $str = $toggle -join ''
            } #toggle

            default {
                Write-Verbose 'STATUS: no further formatting'
            }
        }
        #write result to the pipeline
        $str

    } #process

    end {
        Write-Verbose "ENDING: $($MyInvocation.MyCommand)"
    } #end
}


#EOF
