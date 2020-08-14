[cmdletbinding(SupportsShouldProcess)]
Param(
    [Parameter(HelpMessage = "The path to a json file with the processing data for the folder.")]
    [ValidateNotNullOrEmpty()]
    [ValidateScript({Test-Path $_})]
    [string]$DataPath = ".\adoc-data.json"
)

Write-Verbose "[$(Get-Date)] Importing ruby-related functions"
. C:\scripts\rubydocs.ps1

Write-Verbose "[$(Get-Date)] Importing adoc data from json"
$data = Get-Content $DataPath | ConvertFrom-Json

$adoc = Join-Path -path . -ChildPath "$($data.name).adoc"

Write-Verbose "[$(Get-Date)] Converting $adoc to pdf"
$params = @{
    Fullname      = $adoc
    Passthru      = $True
    Backend       = "pdf"
    DocType       = "book"
    FontDirectory = "c:\gemfonts"
    DocumentTheme = $data.theme
    Trace         = $True
}

if (Test-Path $data.CodeThemePath) {
    $params.Add("CodeThemePath")
}

$pdf = Export-ADoc @params

if (Test-Path $pdf) {
    Write-Verbose "[$(Get-Date)] Optimizing $pdf"
    Optimize-PDF -Fullname $pdf
}

Write-Verbose "[$(Get-Date)] Process complete."
