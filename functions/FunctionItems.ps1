function New-FunctionItem {
    [cmdletbinding(SupportsShouldProcess)]
    [OutputType('None', 'System.Management.Automation.FunctionInfo')]
    [alias('nfi')]
    param(
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
    begin {
        #tags are used for categorizing the command
        #cmdTags = scripting
        Write-Verbose "[$((Get-Date).TimeOfDay)] Starting $($MyInvocation.MyCommand)"
        Write-Verbose "[$((Get-Date).TimeOfDay)] Running under PowerShell version $($PSVersionTable.PSVersion)"
    } #begin
    process {
        Write-Verbose "[$((Get-Date).TimeOfDay)] Creating function $Name"
        $new = New-Item -Path function: -Name "global:$Name"-Value $ScriptBlock -Force
        if ($new -and $Description) {
            $new.Description = $Description
        }
        if ($new -and $PassThru) {
            $new
        }
    }
    end {
        Write-Verbose "[$((Get-Date).TimeOfDay)] Ending $($MyInvocation.MyCommand)"
    } #end
}

function Show-FunctionItem {
    [CmdletBinding()]
    [alias('sfi')]
    [OutputType('String')]
    param(
        [Parameter(
            Position = 0,
            Mandatory,
            HelpMessage = 'What is the name of your function?'
        )]
        [ValidateNotNullOrEmpty()]
        #Add an argument completer to get the names of functions from the Function: PSDrive
        [ArgumentCompleter({ param($commandName, $parameterName, $WordToComplete, $commandAst, $fakeBoundParameter)
                Get-ChildItem -Path Function:\ | where { $_.Name -like "*$WordToComplete*" } |
                ForEach-Object {
                    [System.Management.Automation.CompletionResult]::new($_.Name, $_.Name, 'ParameterValue', $_.Source)
                }
            })]
        [string]$Name
    )

    #tags are used for categorizing the command
    #cmdTags = scripting


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
        Write-Warning "Failed to find a loaded *function* called $(ConvertTo-TitleCase $name). This command will not work with binary cmdlets."
    }
}

#EOF
