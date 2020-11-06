#requires -version 5.1
#requires -module PSscripttools

$global:traceEnabled = $True
Trace-Message -title "Getting Counter Markdown" -Width 500 -BackgroundColor "#0fb93a"

Trace-Message "Starting Get-Mycounter"

$data = Get-MyCounter

if ($data) {
    <#
        Get the graphic from the images directory in the module.
        Images in markdown work best when in the same folder as the markdown file
        or use relative paths. The resulting markdown may not preview properly in
        VS Code. You can test using Show-Markdown in PowerShell 7.x with the
        -UseBrowser parameter
    #>
    $graphic = Get-Item "$PSScriptroot\..\images\db.png"

    Trace-Message "Using graphic file from $($graphic.fullname)"
    $graphicPath = $graphic.Fullname -replace "\\", "/"
    Trace-Message "Formatted path to $GraphicPath"

    $pre = @"
![graphic](file://$graphicPath)

## Computername: $($data[0].Computername)
"@

    $post = "`nData collected _$($data[0].timestamp)_"
    Trace-Message "Retrieved counter data from $($data[0].computername)"
    Trace-Message "Generating markdown"
    $file = Invoke-InputBox -Prompt "Where to do you want to save the file?" -Title "File Save"
    if ($file) {
        Trace-Message "Saving markdown to $file"
        Try {
            $data | Select-Object Category, Counter, Value |
            ConvertTo-Markdown -Title "Performance Status" -PreContent $pre -AsTable -PostContent $post | Out-File -FilePath $file -Encoding utf8
            Trace-Message "File saved"
            Get-Item $file | Out-String | Trace-Message
        }
        Catch {
            Trace-Message "Converting failed."
            Trace-Message $_.Exception.message
        }
    } #if $file
    else {
        Trace-Message "No file specified"
    }
} #if $data

Trace-Message "$($myinvocation.mycommand) completed"
Trace-Message "Disabling tracing"
$global:traceEnabled = $False