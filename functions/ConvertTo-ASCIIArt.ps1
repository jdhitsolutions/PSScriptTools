
<#
font list at https://artii.herokuapp.com/fonts_list
font names are case-sensitive

invoke-restmethod https://artii.herokuapp.com/fonts_list

#>

Function ConvertTo-ASCIIArt {
    [cmdletbinding()]
    [alias("cart")]
    [outputtype([System.String])]
    Param(
        [Parameter(Position = 0, Mandatory, HelpMessage = "Enter a short string of text to convert", ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [string]$Text,
        [Parameter(Position = 1, HelpMessage = "Specify a font from https://artii.herokuapp.com/fonts_list. Font names are case-sensitive.")]
        [ValidateNotNullOrEmpty()]
        [string]$Font = "big"
    )

    Begin {
        Write-Verbose "[$((Get-Date).TimeofDay) BEGIN] Starting $($myinvocation.mycommand)"
    } #begin

    Process {
        Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Processing $text with font $Font"
        $testEncode = [uri]::EscapeDataString($Text)
        $url = "http://artii.herokuapp.com/make?text=$testEncode&font=$Font"
        Try {
            Invoke-RestMethod -Uri $url -DisableKeepAlive -ErrorAction Stop
        }
        Catch {
            Throw $_
        }
    } #process
    End {
        Write-Verbose "[$((Get-Date).TimeofDay) END    ] Ending $($myinvocation.mycommand)"
    } #end
}

Register-ArgumentCompleter -CommandName ConvertTo-ASCIIArt -ParameterName Font -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)

    (Invoke-RestMethod https://artii.herokuapp.com/fonts_list).split() |
        Where-Object { $_ -like "$wordToComplete*" } |
        ForEach-Object {
            [System.Management.Automation.CompletionResult]::new($_.Trim(), $_.Trim(), 'ParameterValue', $_)
        }
}