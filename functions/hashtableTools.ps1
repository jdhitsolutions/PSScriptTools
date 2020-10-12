
Function Convert-HashtableString {
    [cmdletbinding()]
    [OutputType([System.Collections.Hashtable])]

    Param(
        [parameter(Mandatory, HelpMessage = "Enter your hashtable string", ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [string]$Text
    )

    Begin {
        Write-Verbose "[BEGIN  ] Starting: $($MyInvocation.Mycommand)"
    } #begin

    Process {

        $tokens = $null
        $err = $null
        $ast = [System.Management.Automation.Language.Parser]::ParseInput($Text, [ref]$tokens, [ref]$err)
        $data = $ast.find( { $args[0] -is [System.Management.Automation.Language.HashtableAst] }, $true)

        if ($err) {
            Throw $err
        }
        else {
            $data.SafeGetValue()
        }
    }

    End {
        Write-Verbose "[END    ] Ending: $($MyInvocation.Mycommand)"
    } #end

}

Function ConvertTo-Hashtable {

    [cmdletbinding()]
    [OutputType([System.Collections.Specialized.OrderedDictionary])]
    [OutputType([System.Collections.Hashtable])]

    Param(
        [Parameter(
            Position = 0,
            Mandatory,
            HelpMessage = "Please specify an object",
            ValueFromPipeline
        )]
        [ValidateNotNullorEmpty()]
        [object]$InputObject,
        [switch]$NoEmpty,
        [string[]]$Exclude,
        [switch]$Alphabetical,
        [Parameter(HelpMessage = "Create an ordered hashtable instead of a plain hashtable.")]
        [switch]$Ordered
    )

    Process {
        <#
            get type using the [Type] class because deserialized objects won't have
            a GetType() method which is what I would normally use.
        #>

        $TypeName = [system.type]::GetTypeArray($InputObject).name
        Write-Verbose "Converting an object of type $TypeName"

        #get property names using Get-Member
        $names = $InputObject | Get-Member -MemberType properties |
        Select-Object -ExpandProperty name

        if ($Alphabetical) {
            Write-Verbose "Sort property names alphabetically"
            $names = $names | Sort-Object
        }

        #define an empty hash table
        if ($Ordered) {
            Write-Verbose "Creating an ordered hashtable"
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
                if ($NoEmpty -AND -Not ($inputobject.$_)) {
                    Write-Verbose "Skipping $_ as empty"
                }
                else {
                    Write-Verbose "Adding property $_"
                    $hash.Add($_, $inputobject.$_)
                }
            } #if exclude notcontains
            else {
                Write-Verbose "Excluding $_"
            }
        } #foreach
        Write-Verbose "Writing the result to the pipeline"
        Write-Output $hash
    }#close process

}#end function

Function Convert-HashtableToCode {
    [cmdletbinding(DefaultParameterSetName = "psd1")]
    [alias("chc")]
    [OutputType([System.String])]

    Param(
        [Parameter(Position = 0, ValueFromPipeline, Mandatory)]
        [ValidateNotNullorEmpty()]
        [hashtable]$Hashtable,

        [Parameter(ParameterSetName = "psd1")]
        [Alias("tab")]
        [int]$Indent = 1,

        [Parameter(ParameterSetName = "inline", HelpMessage = "Write the hashtable as an inline expression")]
        [switch]$Inline
    )

    Begin {
        Write-Verbose "Starting $($myinvocation.mycommand)"
        if ($Inline) {
            Write-Verbose "Creating an inline expression"
        }
    }
    Process {
        Write-Verbose "Processing a hashtable with $($hashtable.keys.count) keys"

        $hashtable.GetEnumerator() | ForEach-Object -begin {

            [string]$out = "@{"
            if ($PSCmdlet.ParameterSetName -eq 'psd1') {
                $out += "`n"
            }

        }  -Process {
            Write-Verbose "Testing value type $($_.value.gettype().name) for key $($_.key)"
            #determine if the value needs to be enclosed in quotes
            if ($_.value.gettype().name -match "Int|double") {
                Write-Verbose "..is a numeric"
                $value = $_.value
            }
            elseif ($_.value -is [array]) {
                #assuming all the members of the array are of the same type
                Write-Verbose "..is an array"
                #test if an array of numbers otherwise treat as strings
                if ($_.value[0].Gettype().name -match "int|double") {
                    $value = "@($($_.value -join ','))"
                }
                elseif ($_.value[0].GetType().name -eq "Hashtable") {
                    #10/2/2020 JDH need to process nested hashtables in an array (Issue #91)
                    if ($inline) {
                        $value =  "@($(($_.value | Convert-HashtableToCode -inline).trim() -join ","))"
                    }
                    else {
                        #format nested hashtables with @() Issue #91
                        $tables = Foreach ($t in $_.value) {
                            $in = "`t"*$($indent+1)
                            "{0}{1}" -f $in,(Convert-HashTableToCode -Indent $($indent+2) -Hashtable $t).trimend()
                        }
                        $joined = ($tables -join ",`n").TrimEnd()
                        $close = "`t"*$indent
                        $value = "@(`n$joined`n$close)".trimEnd()
                    }
                }
                else {
                    $value = "@($("'{0}'" -f ($_.value -join "','")))"
                }
            } #arrays
            elseif ($_.value -is [hashtable]) {
                Write-Verbose "Creating nested entry"
                #10/2/2020 JDH convert hashtables using current values
                if ($inline) {
                    $nested = Convert-HashtableToCode $_.value -inline
                }
                else {
                    $nested = Convert-HashTableToCode $_.value -Indent $($indent + 1)
                }
                $value = "$($nested)".trimEnd()
            }
            elseif ($_.value -is [scriptblock]) {
                Write-Verbose "Parsing scriptblock"
                $value = "{$($_.value)}"
            }
            else {
                Write-Verbose "..defaulting as a string"
                $value = "'$($_.value)'"
            }

            if ($inline) {
                $out += "$($_.key) = $value;"
            }
            else {
                $tabcount = "`t" * $Indent
                $out += "$tabcount$($_.key) = $value `n"
            }
        }  -end {
            if ($inline) {
                #strip off the last ;
                $out = $out.remove($out.Length - 1)
                $out += "}"
            }
            else {
                $tabcount = "`t" * ($Indent - 1)
                $out += "$tabcount}`n"
            }
            $out
        }

    } #process
    End {
        Write-Verbose "Ending $($myinvocation.mycommand)"
    }
} #end function
Function Join-Hashtable {
    [cmdletbinding()]
    [OutputType([System.Collections.Hashtable])]
    Param (
        [hashtable]$First,
        [hashtable]$Second,
        [switch]$Force
    )

    #create clones of hashtables so originals are not modified
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
                $r = Read-Host "Which key do you want to KEEP [AB]?"
                if ($r -eq "A") {
                    $Secondary.Remove($item)
                }
                elseif ($r -eq "B") {
                    $Primary.Remove($item)
                }
                Else {
                    Write-Warning "Aborting operation"
                    Return
                }
            } #else prompt
        }
    }

    #join the two hash tables
    $Primary + $Secondary

} #end Join-Hashtable

Function Convert-CommandToHashtable {
    [cmdletbinding()]
    [OutputType("[System.String]")]

    Param(
        [Parameter(Mandatory)]
        [ValidateNotNullorEmpty()]
        #"Enter a PowerShell expression with full parameter names"
        [string]$Text
    )

    Set-StrictMode -Version latest

    New-Variable astTokens -force
    New-Variable astErr -force

    #trim spaces
    $Text = $Text.trim()
    Write-Verbose "Converting $text"

    $ast = [System.Management.Automation.Language.Parser]::ParseInput($Text, [ref]$astTokens, [ref]$astErr)

    #resolve the command name
    $cmdType = Get-Command $asttokens[0].text
    if ($cmdType.CommandType -eq 'Alias') {
        $cmd = $cmdType.ResolvedCommandName
    }
    else {
        $cmd = $cmdType.Name
    }

    #last item is end of input token
    $r = for ($i = 1; $i -lt $astTokens.count - 1 ; $i++) {
        if ($astTokens[$i].ParameterName) {
            $p = $astTokens[$i].ParameterName
            $v = ""
            #check next token
            if ($astTokens[$i + 1].Kind -match 'Parameter|EndOfInput') {
                #the parameter must be a switch
                $v = "`$True"
            }
            else {
                While ($astTokens[$i + 1].Kind -notmatch 'Parameter|EndOfInput') {
                    $i++
                    #test if value is a string and if it is quoted, if not include quotes
                    #if ($astTokens[$i].Kind -eq "Identifier" -AND $astTokens[$i].Text -notmatch """\w+.*""" -AND $astTokens[$i].Text -notmatch "'\w+.*'") {
                    if ($astTokens[$i].Text -match "\D" -AND $astTokens[$i].Text -notmatch """\w+.*""" -AND $astTokens[$i].Text -notmatch "'\w+.*'") {
                        #ignore commas and variables
                        if ($astTokens[$i].Kind -match 'Comma|Variable') {
                            $value = $astTokens[$i].Text
                        }
                        else {
                            #Assume text and quote it
                            $value = """$($astTokens[$i].Text)"""
                        }
                    }
                    else {
                        $value = $astTokens[$i].Text
                    }
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

    $hashtext = @"
`$paramHash = @{
$r
}

$cmd @paramHash
"@

    $hashtext


}

Function Rename-Hashtable {

    [cmdletbinding(SupportsShouldProcess, DefaultParameterSetName = "Pipeline")]
    [alias("rht")]

    Param(
        [parameter(
            Position = 0,
            Mandatory,
            HelpMessage = "Enter the name of your hash table variable without the `$",
            ParameterSetName = "Name"
        )]
        [ValidateNotNullorEmpty()]
        [string]$Name,
        [parameter(
            Position = 0,
            Mandatory,
            ValueFromPipeline,
            ParameterSetName = "Pipeline"
        )]
        [ValidateNotNullorEmpty()]
        [object]$InputObject,
        [parameter(
            Position = 1,
            Mandatory,
            HelpMessage = "Enter the existing key name you want to rename")]
        [ValidateNotNullorEmpty()]
        [string]$Key,
        [parameter(position = 2, Mandatory, HelpMessage = "Enter the NEW key name"
        )]
        [ValidateNotNullorEmpty()]
        [string]$NewKey,
        [switch]$Passthru,
        [ValidateSet("Global", "Local", "Script", "Private", 0, 1, 2, 3)]
        [ValidateNotNullOrEmpty()]
        [string]$Scope = "Global"
    )

    Begin {
        Write-Verbose -Message "Starting $($MyInvocation.Mycommand)"
        Write-Verbose "using parameter set $($PSCmdlet.ParameterSetName)"
    }

    Process {
        Write-Verbose "PSBoundparameters"
        Write-Verbose $($PSBoundParameters | Out-String)
        #validate Key and NewKey are not the same
        if ($key -eq $NewKey) {
            Write-Warning "The values you specified for -Key and -NewKey appear to be the same. Names are NOT case-sensitive"
            #bail out
            Return
        }

        Try {
            #validate variable is a hash table
            if ($InputObject) {
                #create a completely random name to avoid any possible naming collisions
                $name = [system.io.path]::GetRandomFileName()
                Write-Verbose "Creating temporary hashtable ($name) from pipeline input"
                Set-Variable -Name $name -Scope $scope -value $InputObject -WhatIf:$False
                $passthru = $True
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
            if (-Not $var.value.Contains($key)) {
                Write-Warning "Failed to find the key $key in the hashtable."
                #bail out
                Return
            }
            if ( $var.Value -is [hashtable]) {
                #create a temporary copy

                Write-Verbose "Cloning a temporary hashtable"
                <#
                Use the clone method to create a separate copy.
                If you just assign the value to $temphash, the
                two hash tables are linked in memory so changes
                to $tempHash are also applied to the original
                object.
                #>
                $tempHash = $var.Value.Clone()

                if ($pscmdlet.ShouldProcess($NewKey, "Replace key $key")) {
                    Write-Verbose "Writing the new hashtable to variable named $hashname"
                    #create a key with the new name using the value from the old key
                    Write-Verbose "Adding new key $newKey to the temporary hashtable"
                    $tempHash.Add($NewKey, $tempHash.$Key)
                    #remove the old key
                    Write-Verbose "Removing $key"
                    $tempHash.Remove($Key)
                    #write the new value to the variable
                    Write-Verbose "Writing the new hashtable to variable named $Name"
                    Write-Verbose ($tempHash | Out-String)
                    Set-Variable -Name $Name -Value $tempHash -Scope $Scope -Force -PassThru:$Passthru |
                    Select-Object -ExpandProperty Value
                }
            }
            elseif ($var.value -is [System.Collections.Specialized.OrderedDictionary]) {
                Write-Verbose "Processing as an ordered dictionary"
                $varHash = $var.value
                #find the index number of the existing key
                $i = -1
                Do {
                    $i++

                } Until (($varHash.GetEnumerator().name)[$i] -eq $Key)

                #save the current value
                $val = $varhash.item($i)

                if ($pscmdlet.ShouldProcess($NewKey, "Replace key $key at $i")) {
                    #remove at the index number
                    $varhash.RemoveAt($i)
                    #insert the new value at the index number
                    $varhash.Insert($i, $NewKey, $val)
                    Write-Verbose "Writing the new hashtable to variable named $name"
                    Write-Verbose ($varHash | Out-String)
                    Set-Variable -Name $name -Value $varhash -Scope $Scope -Force -PassThru:$Passthru |
                    Select-Object -ExpandProperty Value
                }
            }
            else {
                Write-Warning "The variable $name does not appear to be a hash table or ordered dictionaryBet"
            }
        } #Try

        Catch {
            Write-Warning "Failed to find a variable with a name of $Name. $($_.exception.message)."
        }

        Write-Verbose "Rename complete."
    } #Process

    End {
        #clean up any temporary variables
        if ($InputObject) {
            Write-Verbose "Removing temporary variable $name"
            Remove-Variable -name $Name -Scope $scope -WhatIf:$False
        }
        Write-Verbose -Message "Ending $($MyInvocation.Mycommand)"
    } #end

} #end Rename-Hashtable
