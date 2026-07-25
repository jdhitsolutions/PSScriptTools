
function Convert-HashtableString {
    [cmdletbinding()]
    [OutputType([System.Collections.Hashtable])]

    param(
        [parameter(
            Mandatory,
            ValueFromPipeline,
            HelpMessage = 'Enter your hashtable string'
        )]
        [ValidateNotNullOrEmpty()]
        [string]$Text
    )

    begin {
        #tags are used for categorizing the command
        #cmdTags = hashtable,scripting
        Write-Verbose "[BEGIN  ] Starting: $($MyInvocation.MyCommand)"
        Write-Verbose "[BEGIN  ] Running under PowerShell version $($PSVersionTable.PSVersion)"
    } #begin

    process {
        $tokens = $null
        $err = $null
        $ast = [System.Management.Automation.Language.Parser]::ParseInput($Text, [ref]$tokens, [ref]$err)
        $data = $ast.find( { $args[0] -is [System.Management.Automation.Language.HashtableAst] }, $true)

        if ($err) {
            throw $err
        }
        else {
            $data.SafeGetValue()
        }
    } #process

    end {
        Write-Verbose "[END    ] Ending: $($MyInvocation.MyCommand)"
    } #end

}

function ConvertTo-Hashtable {
    [cmdletbinding()]
    [OutputType([System.Collections.Specialized.OrderedDictionary])]
    [OutputType([System.Collections.Hashtable])]

    param(
        [Parameter(
            Position = 0,
            Mandatory,
            HelpMessage = 'Please specify an object',
            ValueFromPipeline
        )]
        [ValidateNotNullOrEmpty()]
        [object]$InputObject,
        [switch]$NoEmpty,
        [string[]]$Exclude,
        [switch]$Alphabetical,
        [Parameter(HelpMessage = 'Create an ordered hashtable instead of a plain hashtable.')]
        [switch]$Ordered
    )

    #tags are used for categorizing the command
    #cmdTags = hashtable,scripting

    process {
        <#
            get type using the [Type] class because deserialized objects won't have
            a GetType() method which is what I would normally use.
        #>

        $TypeName = [System.Type]::GetTypeArray($InputObject).name
        Write-Verbose "Converting an object of type $TypeName"

        #get property names using Get-Member
        #29 Oct 2025 Modified to get property names using PSObject
        $names = $InputObject.PSObject.Properties.Name

        if ($Alphabetical) {
            Write-Verbose 'Sort property names alphabetically'
            $names = $names | Sort-Object
        }

        #define an empty hash table
        #29 Oct 2025, an alphabetical sorted hash table must be ordered
        if ($Ordered -or $Alphabetical) {
            Write-Verbose 'Creating an ordered hashtable'
            $hash = [ordered]@{ }
        }
        else {
            $hash = @{ }
        }

        #go through the list of names and add each property and value to the hash table
        $names | ForEach-Object {
            #only add properties that haven't been excluded
            if ($Exclude -notcontains $_) {
                #only add if -NoEmpty is not called and property has a value
                if ($NoEmpty -and -not ($InputObject.$_)) {
                    Write-Verbose "Skipping $_ as empty"
                }
                else {
                    Write-Verbose "Adding property $_"
                    $hash.Add($_, $InputObject.$_)
                }
            } #if exclude notcontains
            else {
                Write-Verbose "Excluding $_"
            }
        } #foreach
        Write-Verbose 'Writing the result to the pipeline'
        Write-Output $hash
    }#close process

}#end function

function Convert-HashtableToCode {
    [cmdletbinding(DefaultParameterSetName = 'psd1')]
    [alias('chc')]
    [OutputType([System.String])]

    param(
        [Parameter(Position = 0, ValueFromPipeline, Mandatory)]
        [ValidateNotNullOrEmpty()]
        [ValidateScript({ ($_ -is [hashtable]) -or ($_ -is [ordered]) })]
        [object]$Hashtable,

        [Parameter(ParameterSetName = 'psd1')]
        [Alias('tab')]
        [int]$Indent = 1,

        [Parameter(ParameterSetName = 'inline', HelpMessage = 'Write the hashtable as an inline expression')]
        [switch]$Inline
    )

    begin {
        #tags are used for categorizing the command
        #cmdTags = hashtable,scripting
        Write-Verbose "Starting $($MyInvocation.MyCommand)"
        Write-Verbose "Running under PowerShell version $($PSVersionTable.PSVersion)"
        if ($Inline) {
            Write-Verbose 'Creating an inline expression'
        }
    }
    process {
        Write-Verbose "Processing a hashtable with $($hashtable.keys.count) keys"

        $hashtable.GetEnumerator() | ForEach-Object -Begin {

            [string]$out = '@{'
            if ($PSCmdlet.ParameterSetName -eq 'psd1') {
                $out += "`n"
            }

        } -Process {
            Write-Verbose "Testing value type $($_.value.GetType().name) for key $($_.key)"
            #determine if the value needs to be enclosed in quotes
            if ($_.value.GetType().name -match 'Int|double') {
                Write-Verbose '..is a numeric'
                $value = $_.value
            }
            elseif ($_.value -is [array]) {
                #assuming all the members of the array are of the same type
                Write-Verbose '..is an array'
                #test if an array of numbers otherwise treat as strings
                if ($_.value[0].GetType().name -match 'int|double') {
                    $value = "@($($_.value -join ','))"
                }
                elseif ($_.value[0].GetType().name -eq 'Hashtable') {
                    #10/2/2020 JDH need to process nested hashtables in an array (Issue #91)
                    if ($inline) {
                        $value = "@($(($_.value | Convert-HashtableToCode -Inline).trim() -join ','))"
                    }
                    else {
                        #format nested hashtables with @() Issue #91
                        $tables = foreach ($t in $_.value) {
                            $in = "`t" * $($indent + 1)
                            '{0}{1}' -f $in, (Convert-HashtableToCode -Indent $($indent + 2) -Hashtable $t).TrimEnd()
                        }
                        $joined = ($tables -join ",`n").TrimEnd()
                        $close = "`t" * $indent
                        $value = "@(`n$joined`n$close)".trimEnd()
                    }
                }
                else {
                    $value = "@($("'{0}'" -f ($_.value -join "','")))"
                }
            } #arrays
            elseif ($_.value -is [hashtable]) {
                Write-Verbose 'Creating nested entry'
                #10/2/2020 JDH convert hashtables using current values
                if ($inline) {
                    $nested = Convert-HashtableToCode $_.value -Inline
                }
                else {
                    $nested = Convert-HashtableToCode $_.value -Indent $($indent + 1)
                }
                $value = "$($nested)".trimEnd()
            }
            elseif ($_.value -is [scriptblock]) {
                Write-Verbose 'Parsing scriptblock'
                $value = "{$($_.value)}"
            }
            else {
                Write-Verbose '..defaulting as a string'
                $value = "'$($_.value)'"
            }

            if ($inline) {
                $out += "$($_.key) = $value;"
            }
            else {
                $tabCount = "`t" * $Indent
                $out += "$tabCount$($_.key) = $value `n"
            }
        } -End {
            if ($inline) {
                #strip off the last ;
                $out = $out.remove($out.Length - 1)
                $out += '}'
            }
            else {
                $tabCount = "`t" * ($Indent - 1)
                $out += "$tabCount}`n"
            }
            $out
        }

    } #process
    end {
        Write-Verbose "Ending $($MyInvocation.MyCommand)"
    }
} #end function
function Join-Hashtable {
    [cmdletbinding()]
    [OutputType([System.Collections.Hashtable])]
    param (
        [hashtable]$First,
        [hashtable]$Second,
        [switch]$Force
    )

    #tags are used for categorizing the command
    #cmdTags = hashtable,scripting
    #create clones of hash tables so originals are not modified
    $Primary = $First.Clone()
    $Secondary = $Second.Clone()

    #check for any duplicate keys
    $duplicates = $Primary.keys | Where-Object { $Secondary.ContainsKey($_) }
    if ($duplicates) {
        foreach ($item in $duplicates) {
            if ($force) {
                #force primary key, so remove secondary conflict
                $Secondary.Remove($item)
            }
            else {
                Write-Host "Duplicate key $item" -ForegroundColor Yellow
                Write-Host "A $($Primary.Item($item))" -ForegroundColor Yellow
                Write-Host "B $($Secondary.Item($item))" -ForegroundColor Yellow
                $r = Read-Host 'Which key do you want to KEEP [AB]?'
                if ($r -eq 'A') {
                    $Secondary.Remove($item)
                }
                elseif ($r -eq 'B') {
                    $Primary.Remove($item)
                }
                else {
                    Write-Warning 'Aborting operation'
                    return
                }
            } #else prompt
        }
    }

    #join the two hash tables
    $Primary + $Secondary

} #end Join-Hashtable

function Convert-CommandToHashtable {
    [cmdletbinding()]
    [OutputType('[System.String]')]

    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        #"Enter a PowerShell expression with full parameter names"
        [string]$Text
    )

    #tags are used for categorizing the command
    #cmdTags = hashtable,scripting

    New-Variable astTokens -Force
    New-Variable astErr -Force

    #trim spaces
    $Text = $Text.trim()
    Write-Verbose "Parsing $text using the AST"

    $ast = [System.Management.Automation.Language.Parser]::ParseInput($Text, [ref]$astTokens, [ref]$astErr)
    Write-Information $ast -Tags ast
    Write-Information $astTokens -Tags tokens

    #resolve the command name
    $cmdType = Get-Command $astTokens[0].text
    if ($cmdType.CommandType -eq 'Alias') {
        $cmd = $cmdType.ResolvedCommandName
    }
    else {
        $cmd = $cmdType.Name
    }
    Write-Verbose "Resolved command to $cmd"

    #last item is end of input token
    $r = for ($i = 1; $i -lt $astTokens.count - 1 ; $i++) {
        if ($astTokens[$i].ParameterName) {
            $p = $astTokens[$i].ParameterName
            Write-Verbose "Processing parameter $p"
            $v = ''
            #check next token
            if ($astTokens[$i + 1].Kind -match 'Parameter|EndOfInput') {
                Write-Verbose 'Detected [Switch] parameter'
                #the parameter must be a switch
                $v = "`$True"
            }
            else {
                while ($astTokens[$i + 1].Kind -notmatch 'Parameter|EndOfInput') {
                    $i++
                    #test if value is a string and if it is quoted, if not include quotes
                    #if ($astTokens[$i].Kind -eq "Identifier" -AND $astTokens[$i].Text -NotMatch """\w+.*""" -AND $astTokens[$i].Text -NotMatch "'\w+.*'") {
                    if ($astTokens[$i].Text -match '\D' -and $astTokens[$i].Text -notmatch '"\w+.*"' -and $astTokens[$i].Text -notmatch "'\w+.*'") {
                        #ignore commas and variables
                        if ($astTokens[$i].Kind -match 'Comma|Variable') {
                            Write-Verbose 'Comma or Variable'
                            $value = $astTokens[$i].Text
                        }
                        elseif ($astTokens[$i].Kind -eq 'AtCurly') {
                            #30 Oct 2025 Detect and properly format a hashtable
                            #this won't handle nested hashtables
                            Write-Verbose 'Hashtable detected'
                            $hash = $astTokens[$i].Text
                            do {
                                $i++
                                $hash += $astTokens[$i].Text
                            } until ($astTokens[$i].Kind -eq 'RCurly')
                            Write-Verbose $hash
                            $value = $hash
                        }
                        else {
                            #Assume text and quote it
                            Write-Verbose 'Assuming text and quoting it'
                            $value = """$($astTokens[$i].Text)"""
                        }
                    }
                    else {
                        $value = $astTokens[$i].Text
                    }
                    Write-Verbose "Using value $value"
                    $v += $value
                } #while
            }
            #don't add a line return if this is going to be the last item
            if ($i + 1 -ge $astTokens.count - 1) {
                "  $p = $v"
            }
            else {
                "  $p = $v`n"
            }
        } #if ast parameter name

    } #for

    $hashText = @"
`$paramHash = @{
$r
}

$cmd @paramHash
"@

    $hashText


}

function Rename-Hashtable {
    [cmdletbinding(SupportsShouldProcess, DefaultParameterSetName = 'Pipeline')]
    [alias('rht')]

    param(
        [parameter(
            Position = 0,
            Mandatory,
            HelpMessage = "Enter the name of your hash table variable without the `$",
            ParameterSetName = 'Name'
        )]
        [ValidateNotNullOrEmpty()]
        [string]$Name,
        [parameter(
            Position = 0,
            Mandatory,
            ValueFromPipeline,
            ParameterSetName = 'Pipeline'
        )]
        [ValidateNotNullOrEmpty()]
        [object]$InputObject,
        [parameter(
            Position = 1,
            Mandatory,
            HelpMessage = 'Enter the existing key name you want to rename')]
        [ValidateNotNullOrEmpty()]
        [string]$Key,
        [parameter(position = 2, Mandatory, HelpMessage = 'Enter the NEW key name'
        )]
        [ValidateNotNullOrEmpty()]
        [string]$NewKey,
        [switch]$PassThru,
        [ValidateSet('Global', 'Local', 'Script', 'Private', 0, 1, 2, 3)]
        [ValidateNotNullOrEmpty()]
        [string]$Scope = 'Global'
    )

    begin {
        #tags are used for categorizing the command
        #cmdTags = hashtable,scripting
        Write-Verbose "Starting $($MyInvocation.MyCommand)"
        Write-Verbose "Running under PowerShell version $($PSVersionTable.PSVersion)"
        Write-Verbose "using parameter set $($PSCmdlet.ParameterSetName)"
    }

    process {
        Write-Verbose 'PSBoundParameters'
        Write-Verbose $($PSBoundParameters | Out-String)
        #validate Key and NewKey are not the same
        if ($key -eq $NewKey) {
            Write-Warning 'The values you specified for -Key and -NewKey appear to be the same. Names are NOT case-sensitive'
            #bail out
            return
        }

        try {
            #validate variable is a hash table
            if ($InputObject) {
                #create a completely random name to avoid any possible naming collisions
                $name = [system.io.path]::GetRandomFileName()
                Write-Verbose "Creating temporary hashtable ($name) from pipeline input"
                Set-Variable -Name $name -Scope $scope -Value $InputObject -WhatIf:$False
                $PassThru = $True
            }
            else {
                Write-Verbose "Using hashtable variable $name"
            }

            Write-Verbose (Get-Variable -Name $name -Scope $scope | Out-String)
            Write-Verbose "Validating $name as a hashtable in $Scope scope."
            #get the variable
            $var = Get-Variable -Name $name -Scope $Scope -ErrorAction Stop
            Write-Verbose "Detected a $($var.value.GetType().fullname)"

            Write-Verbose "Testing for key $key"
            if (-not $var.value.Contains($key)) {
                Write-Warning "Failed to find the key $key in the hashtable."
                #bail out
                return
            }
            if ( $var.Value -is [hashtable]) {
                #create a temporary copy

                Write-Verbose 'Cloning a temporary hashtable'
                <#
                Use the clone method to create a separate copy.
                If you just assign the value to $temphash, the
                two hash tables are linked in memory so changes
                to $tempHash are also applied to the original
                object.
                #>
                $tempHash = $var.Value.Clone()

                if ($PSCmdlet.ShouldProcess($NewKey, "Replace key $key")) {
                    Write-Verbose "Writing the new hashtable to variable named $hashName"
                    #create a key with the new name using the value from the old key
                    Write-Verbose "Adding new key $newKey to the temporary hashtable"
                    $tempHash.Add($NewKey, $tempHash.$Key)
                    #remove the old key
                    Write-Verbose "Removing $key"
                    $tempHash.Remove($Key)
                    #write the new value to the variable
                    Write-Verbose "Writing the new hashtable to variable named $Name"
                    Write-Verbose ($tempHash | Out-String)
                    Set-Variable -Name $Name -Value $tempHash -Scope $Scope -Force -PassThru:$PassThru |
                    Select-Object -ExpandProperty Value
                }
            }
            elseif ($var.value -is [System.Collections.Specialized.OrderedDictionary]) {
                Write-Verbose 'Processing as an ordered dictionary'
                $varHash = $var.value
                #find the index number of the existing key
                $i = -1
                do {
                    $i++

                } until (($varHash.GetEnumerator().name)[$i] -eq $Key)

                #save the current value
                $val = $varHash.item($i)

                if ($PSCmdlet.ShouldProcess($NewKey, "Replace key $key at $i")) {
                    #remove at the index number
                    $varHash.RemoveAt($i)
                    #insert the new value at the index number
                    $varHash.Insert($i, $NewKey, $val)
                    Write-Verbose "Writing the new hashtable to variable named $name"
                    Write-Verbose ($varHash | Out-String)
                    Set-Variable -Name $name -Value $varHash -Scope $Scope -Force -PassThru:$PassThru |
                    Select-Object -ExpandProperty Value
                }
            }
            else {
                Write-Warning "The variable $name does not appear to be a hash table or ordered dictionaryBet"
            }
        } #Try

        catch {
            Write-Warning "Failed to find a variable with a name of $Name. $($_.exception.message)."
        }

        Write-Verbose 'Rename complete.'
    } #Process

    end {
        #clean up any temporary variables
        if ($InputObject) {
            Write-Verbose "Removing temporary variable $name"
            Remove-Variable -Name $Name -Scope $scope -WhatIf:$False
        }
        Write-Verbose -Message "Ending $($MyInvocation.MyCommand)"
    } #end

} #end Rename-Hashtable

#EOF
