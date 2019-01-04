
Function Get-MyVariable {


    [cmdletbinding()]
    [OutputType([System.Management.Automation.PSVariable])]
    [Alias("gmv")]

    Param(
        [Parameter(Position = 0)]
        [ValidateSet("Global", "Local", "Script", "Private", 0, 1, 2, 3)]
        [ValidateNotNullOrEmpty()]
        [string]$Scope = "Global",
        [switch]$NoTypeInformation
    )
    
    if ($psise) {
        Write-Warning "This function is not designed for the PowerShell ISE."    
    }
    else {
        Write-Verbose "Getting system defined variables"
        #get all global variables from PowerShell with no profiles
        $psvariables = powershell -noprofile -COMMAND "& {GET-VARIABLE | select -expandproperty name}"
       
        Write-Verbose "Found $($psvariables.count) initial state variables"
        
        <#
          find all the variables where the name isn't in the variable we just created
          and also isn't a system variable generated after the shell has been running
          and also any from this function
        #>
        
        Write-Verbose "Getting current variables in $Scope scope"
        $variables = Get-Variable -Scope $Scope
        
        Write-Verbose "Found $($variables.count)"
        Write-Verbose "Filtering variables"
        
        #define variables to also exclude
        $skip = "LastExitCode|_|PSScriptRoot|skip|PSCmdlet|psvariables|variables|Scope|this"
        
        #filter out some automatic variables
        $filtered = $variables | Where-object {$psvariables -notcontains $_.name -AND $_.name -notmatch $skip} 
        
        if ($NoTypeInformation) {
            #write results with not object types
            $filtered
        }
        else {
            #add type information for each variable
            Write-Verbose "Adding value type"
            $filtered | Select-Object Name, Value, @{Name = "Type"; Expression = {$_.Value.GetType().Name}}
        }
        
        Write-Verbose "Finished getting my variables"
        
    }
} #end function




