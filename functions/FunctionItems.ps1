Function New-FunctionItem {
    [cmdletbinding(SupportsShouldProcess)]
    [OutputType('None', 'System.Management.Automation.FunctionInfo')]
    [alias('nfi')]
    Param(
        [Parameter(
            Position = 0,
            Mandatory,
            HelpMessage = 'What is the name of your function?'
        )]
        [ValidateNotNullOrEmpty()]
        [string]$Name,
        [Parameter(
            Mandatory,
            HelpMessage = "What is your function's scriptblock?", ValueFromPipeline
        )]
        [ValidateNotNullOrEmpty()]
        [scriptblock]$Scriptblock,
        [string]$Description,
        [switch]$PassThru
    )
    Begin {
        Write-Verbose "[$((Get-Date).TimeOfDay)] Starting $($MyInvocation.MyCommand)"
    } #begin
    Process {
        Write-Verbose "[$((Get-Date).TimeOfDay)] Creating function $Name"
        $new = New-Item -Path function: -Name "global:$Name"-Value $ScriptBlock -Force
        if ($new -AND $Description) {
            $new.Description = $Description
        }
        If ($new -AND $PassThru) {
            $new
        }
    }
    End {
        Write-Verbose "[$((Get-Date).TimeOfDay)] Ending $($MyInvocation.MyCommand)"
    } #end
}

Function Show-FunctionItem {
    [CmdletBinding()]
    [alias('sfi')]
    [OutputType('String')]
    Param(
        [Parameter(
            Position = 0,
            Mandatory,
            HelpMessage = 'What is the name of your function?'
        )]
        [ValidateNotNullOrEmpty()]
        #Add an argument completer to get the names of functions from the Function: PSDrive
        [ArgumentCompleter({param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)
            Get-ChildItem -path Function:\ | where {$_.Name -like "*$wordToComplete*"} |
            ForEach-Object {
                [System.Management.Automation.CompletionResult]::new($_.Name, $_.Name, 'ParameterValue', $_.Source)
            }
        })]
        [string]$Name
    )

    Write-Verbose "Getting Function $Name"
    if (Test-Path Function:$Name) {
        Write-Verbose "Processing function $Name"
        $item = Get-Item Function:$Name
        #convert name to title case
        $cmdName = ConvertTo-TitleCase -Text $name

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
