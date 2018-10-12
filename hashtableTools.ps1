
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
        $data = $ast.find( {$args[0] -is [System.Management.Automation.Language.HashtableAst]}, $true)

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

Function ConvertTo-HashTable {
    
    [cmdletbinding()]
    [OutputType([System.Collections.Specialized.OrderedDictionary])]

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
        [switch]$Alphabetical
    )

    Process {
        #get type using the [Type] class because deserialized objects won't have
        #a GetType() method which is what we would normally use.

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
        $hash = [ordered]@{}

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

Function Convert-HashTableToCode {
    [cmdletbinding()]
    [OutputType([system.string])]
    
    Param(
        [Parameter(Position = 0, ValueFromPipeline, Mandatory)]
        [ValidateNotNullorEmpty()]
        [hashtable]$Hashtable,
        [Alias("tab")]
        [int]$Indent = 1
    )

    Begin {
        Write-Verbose "Starting $($myinvocation.mycommand)"

    }
    Process {
        Write-Verbose "Processing a hashtable with $($hashtable.keys.count) keys"
        
        $hashtable.GetEnumerator() | foreach-object -begin {
            
            $out = @"
@{

"@
        }  -Process {
            Write-Verbose "Testing type $($_.value.gettype().name) for $($_.key)"
            #determine if the value needs to be enclosed in quotes
            if ($_.value.gettype().name -match "Int|double") {
                write-Verbose "..is an numeric"
                $value = $_.value
            }
            elseif ($_.value -is [array]) {
                #assuming all the members of the array are of the same type
                write-Verbose "..is an array"
                #test if an array of numbers otherwise treat as strings
                if ($_.value[0].Gettype().name -match "int|double") {
                    $value = $_.value -join ','
                }
                else {
                    $value = "'{0}'" -f ($_.value -join "','")
                }
            }
            elseif ($_.value -is [hashtable]) {
                $nested = Convert-HashTableToCode $_.value -Indent $($indent + 1)
                $value = "$($nested)"
            }
            else {
                write-Verbose "..defaulting as a string"
                $value = "'$($_.value)'"
            }
            $tabcount = "`t" * $Indent
            $out += "$tabcount$($_.key) = $value `n"
        }  -end {
                
            $tabcount = "`t" * ($Indent - 1)
            $out += "$tabcount}`n"

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
    $duplicates = $Primary.keys | Where-Object {$Secondary.ContainsKey($_)}
    if ($duplicates) {
        foreach ($item in $duplicates) {
            if ($force) {
                #force primary key, so remove secondary conflict
                $Secondary.Remove($item)
            }
            else {
                Write-Host "Duplicate key $item" -ForegroundColor Yellow
                Write-Host "A $($Primary.Item($item))" -ForegroundColor Yellow
                Write-host "B $($Secondary.Item($item))" -ForegroundColor Yellow
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

Function Convert-CommandtoHashtable {
    [cmdletbinding()]
    [OutputType("Hashtable")]
    
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
    Write-verbose "Converting $text"

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