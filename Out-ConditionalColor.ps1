#requires -version 4.0

#TODO separate into parameter sets for simple or complex conditions
#todo: avoid coloring the header
Function Out-ConditionalColor {
<#
.Synopsis
Display colorized pipelined output.
.Description
This command is designed to take pipeline input and display it in a colorized format, based on a set of conditions. Unlike Write-Host which doesn't write to the pipeline, this command will write to the pipeline. You can get colorized data and save the output to a variable at the same time, although you'll need to use the common OutVariable parameter (see examples).

The default behavior is to use a hash table with a property name and color. The color must be one of the standard console colors used with Write-Host.

$c = @{Stopped='Red';Running='Green'}

You can then pipe an expression to this command, specifying a property name and the hash table. If the property matches the key name, the output for that object will be colored using the corresponding hash table value.

get-service -diplayname windows* | out-conditionalcolor $c status 

Or you can do more complex processing with an ordered hash table constructed using this format:

[ordered]@{ <comparison scriptblock> = <color>}

The comparison scriptblock can use $PSitem.

$h=[ordered]@{
{$psitem.ws -gt 200mb}='yellow'
{$psitem.vm -gt 500mb}='red'
{$psitem.cpu -gt 300}='cyan'
}

When doing a complex comparison you must use an [ordered] hashtable as each key will be processed in order using an If/ElseIf statement.

This command should be the last part of any pipelined expression. If you pipe to anything else, such as Sort-Object, you will lose your color formatting. Do any other sorting or filtering before piping to this command.

This command requires PowerShell 3.0 and later and works best in the PowerShell console. It won't do anything in the PowerShell ISE.
.Parameter Conditions
Use a simple hashtable for basic processing or an ordered hash table for complex.
.Parameter Property
When using a simple hash table, specify the property to compare using the -eq operator. If you don't specify a property you will be prompted.
.Example
PS C:\> get-service -displayname windows* | out-conditionalcolor -conditions @{Stopped='Red'} -property Status

Get all services where the displayname starts with windows and display stopped services in red.
.Example
PS C:\> get-service -displayname windows* | out-conditionalcolor @{Stopped='Red'} status -ov winstop

Repeat the previous example, but save the output to the variable winstop. When you look at $Winstop you'll see the services, but they won't be colored. This example uses the parameters positionally.
.Example
PS C:\> get-eventlog system -newest 50 | out-conditionalcolor @{error='red';warning='yellow'}
Enter a property name: entrytype

Get the newest 50 entries from the System event log. Display errors in red and warnings in yellow. If you don't specify a property you will be prompted.
.Example
PS C:\> $c =[ordered]@{{$psitem.length -ge 1mb}='red';{$psitem.length -ge 500KB}='yellow';{$psitem.length -ge 100KB}='cyan'}

The first command creates an ordered hashtable based on the Length property. 

PS C:\> dir c:\scripts\*.doc,c:\scripts\*.pdf,c:\scripts\*.xml | Select Name,LastWriteTime,Length | out-conditionalcolor $c

The second command uses it to et certain file types in the scripts folder and display the selected properties in color depending on the file size.
.Notes
Last Updated: October 23, 2015
Version     : 2.0

Learn more about PowerShell:
http://jdhitsolutions.com/blog/essential-powershell-resources/

  ****************************************************************
  * DO NOT USE IN A PRODUCTION ENVIRONMENT UNTIL YOU HAVE TESTED *
  * THOROUGHLY IN A LAB ENVIRONMENT. USE AT YOUR OWN RISK.  IF   *
  * YOU DO NOT UNDERSTAND WHAT THIS SCRIPT DOES OR HOW IT WORKS, *
  * DO NOT USE IT OUTSIDE OF A SECURE, TEST SETTING.             *
  ****************************************************************
Originally published at http://jdhitsolutions.com/blog/powershell/3462/friday-fun-out-conditionalcolor/

.Link
About_Hash_Tables
#>

[cmdletbinding()]
Param(
[Parameter(Position=0,Mandatory=$True,HelpMessage="Enter an ordered hashtable of conditional properties and colors.")]
[ValidateScript({ 
$_ -IS [System.Collections.Specialized.OrderedDictionary] -OR ($_ -IS [hashtable])})]
[psobject]$Conditions,
[Parameter(Position=1,HelpMessage="Enter a property name.")]
[string]$Property,
[Parameter(Position=2,Mandatory=$True,ValueFromPipeline=$True)]
[PSObject[]]$Inputobject

)

Begin {
    Write-Debug "Starting $($MyInvocation.MyCommand)"
    
    #save original color
    $saved = $Host.UI.RawUI.ForegroundColor
    
    Write-Debug "Original foreground color is $saved"

    #validate colors
    $allowed = [enum]::GetNames([system.consolecolor])
    
    $bad = $Conditions.Values | where {$allowed -notcontains $_}
    if ($bad) {
        Write-Warning "You are using one or more invalid colors: $($bad -join ',')"
        Break
    }    
   
    if ($Conditions -is [System.Collections.Specialized.OrderedDictionary]) {
        $Complex = $True
        #we'll need this later in the Process script block
        #if doing complex processing
        Write-Debug "Getting hash table enumerator and names"
        $compare = $conditions.GetEnumerator().name
        Write-Debug $($compare | out-string)
        #build an If/ElseIf construct on the fly
#the Here strings must be left justified
$If=@"
 if ($($compare[0])) {
  `$host.ui.RawUI.ForegroundColor = '$($conditions.item($($compare[0])))'
 }
"@
        #now add the remaining comparisons as ElseIf
        for ($i=1;$i -lt $conditions.count;$i++) {
         $If+="elseif ($($compare[$i])) { 
         `$host.ui.RawUI.ForegroundColor = '$($conditions.item($($compare[$i])))'
         }
         "
        } #for

#add the final else
$if+=@"
Else { 
`$host.ui.RawUI.ForegroundColor = `$saved 
}
"@

        Write-Debug "Complex comparison:"
        Write-Debug $If
    } #if complex parameter set
    Else {
        #validate a property was specified
        if (-NOT $Property) {
            [string]$property = Read-Host "Enter a property name"
            if (-Not $property) { 
                Write-Debug "Blank property so quitting"
                Break
            }
        }
        Write-Debug "Conditional property is $Property"
    } 

} #Begin

Process {

    If ($Complex) {
        #Use complex processing
        Invoke-Expression $if
  } #end complex
  else {
        #get property value as a string
        $value = $Inputobject.$Property.ToString()
        Write-Debug "Testing property value $value"
        if ($Conditions.containsKey($value)) {
         Write-Debug "Property match"
         $host.ui.RawUI.ForegroundColor= $Conditions.item($value)
        }
        else {
         #use orginal color
         Write-Debug "No matches found"
         $host.ui.RawUI.ForegroundColor= $saved
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

#create an optional alias
