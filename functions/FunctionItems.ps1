Function New-FunctionItem {

    [cmdletbinding(SupportsShouldProcess)]
    [OutputType("None", "System.Management.Automation.FunctionInfo")]
    [alias("nfi")]
    Param(
        [Parameter(Mandatory, HelpMessage = "What is the name of your function?")]
        [string]$Name,
        [Parameter(Mandatory, HelpMessage = "What is your function's scriptblock?", ValueFromPipeline)]
        [scriptblock]$Scriptblock,
        [string]$Description,
        [switch]$Passthru
    )
    Begin {
        Write-Verbose "[$((Get-Date).TimeofDay)] Starting $($myinvocation.mycommand)"
    } #begin
    Process {
        Write-Verbose "[$((Get-Date).TimeofDay)] Creating function $Name"
        $new = New-Item -Path function: -Name "global:$Name"-Value $ScriptBlock -Force
        if ($new -AND $Description) {
            $new.Description = $Description
        }
        If ($new -AND $Passthru) {
            $new
        }
    }
    End {
        Write-Verbose "[$((Get-Date).TimeofDay)] Ending $($myinvocation.mycommand)"

    } #end
}

Function Show-FunctionItem {

    [CmdletBinding()]
    [alias("sfi")]
    [OutputType("String")]
    Param(
        [Parameter(Mandatory, HelpMessage = "What is the name of your function?")]
        [string]$Name
    )

    Write-Verbose "Getting Function $Name"
    if (Test-Path Function:$Name) {
        Write-Verbose "Processing function $Name"
        $item = Get-Item Function:$Name
        #convert name to title case
        $cmdName = ConvertTo-TitleCase -text $name

        $out = @"
Function $cmdName {
$($item.ScriptBlock)
} #close $Name

"@

        $out
    } #if
    else {
        Write-Warning "Failed to find a function called $name"
    }
}