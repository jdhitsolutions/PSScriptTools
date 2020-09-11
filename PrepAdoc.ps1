[cmdletbinding(SupportsShouldProcess)]
Param(
  [Parameter(Position = 0)]
  [ValidateNotNullOrEmpty()]
  [ValidateScript( {Test-Path $_})]
  [string]$Path = ".",
  [Parameter(HelpMessage = "The path to a json file with the processing data for the folder.")]
  [ValidateNotNullOrEmpty()]
  [ValidateScript( {Test-Path $_})]
  [string]$DataPath = ".\adoc-data.json"
)

$prog = @{
  Activity         = "Prepare ADOC files"
  Status           = "Initializing"
  CurrentOperation = ""
  PercentComplete  = 0
}

Write-Progress @prog

$ModulePath = Convert-Path $Path
$moduleName = Split-Path $modulePath -leaf
Write-Verbose "[$(Get-Date)] Working from $modulePath"

Write-Verbose "[$(Get-Date)] Importing ruby-related functions"
. C:\scripts\rubydocs.ps1

Write-Verbose "[$(Get-Date)] Importing adoc data from json"
<#
{
  "Name" : "PSScriptToolsManual",
  "Title": "PSScriptTools Manual",
  "CodeTheme": "githubcustom",
  "CodeThemePath": "c:\\scripts\\githubcustom.rb",
  "Theme": "pdf-theme.yml",
  "Files": [
    {
      "Name": "Intro.md",
      "Lines": ""
    },
    {
      "Name": "README.md",
      "Lines": "1;13..15;33..-1"
    },
    {
      "Name": "ModuleCommands.md",
      "Lines": ""
    }
  ]
}#>

$data = Get-Content $DataPath | ConvertFrom-Json

Write-Verbose "[$(Get-Date)] Get the module version"
$ver = (Test-ModuleManifest -Path .\$modulename.psd1).version.tostring()
#(Import-PowerShellDataFile $ModulePath\*.psd1).moduleversion
Write-Verbose "[$(Get-Date)] Found version $ver"

#define a here-string for the main document in Asciidoctor format
$Main = @"
= $($data.title) v$Ver
:allow-uri-read:
:autofit-option:
:data-uri:
:icons: font
:iconset: fa
:linkattrs:
:rouge-style: $($data.codeTheme)
:source-highlighter: rouge

"@

$files = $data.files
$prog.status = "Processing main files"
$i = 0
foreach ($file in $files) {
  $i++
  $prog.CurrentOperation = $file.name
  $prog.percentComplete = ($i/$files.count)*100
  Write-Progress @prog
  $item = Join-Path -Path $Modulepath -ChildPath $file.name
  Write-Verbose "[$(Get-Date)] Converting $item"
  Get-Item -path $item |
  ConvertTo-Adoc -Codetheme $data.codeTheme

  $adoc = $item -replace "md", "adoc"
  $c = Get-Content $adoc

  Write-Verbose "[$(Get-Date)] Adjustings links and xrefs"
  [regex]$lx = "xref:(?<link>\S+)\.adoc\[(?<display>((\w+[\s-]\w+))+)\]"
  $matches = $lx.matches($c)
  foreach ($item in $matches) {
    $link = $item.groups.where( {$_.name -eq 'link'}).value
    $display = $item.groups.where( {$_.name -eq 'display'}).value

    #split off the command name from the link to build the
    #correct cross-reference in the PDF
    $cmdName = $link.split("/")[-1]
    $xlink = "$cmdName-Help"
    $xref = "<<{0},{1}>>" -f $xlink, $display
    #use the method because the value has regex characters
    $c = $c.replace($item.value, $xref)
  }

  Write-Verbose "[$(Get-Date)] Updating $adoc"
  $c | Out-File -FilePath $adoc -Encoding utf8

  Write-Verbose "[$(Get-Date)] Adding to Main"
  #include line subsets if defined
  if ($file.lines) {
    $trim = "lines=$($file.lines)"
  }
  else {
    $trim = ""
  }
  $main += @"

include::$($adoc)[$trim]

"@
}

Write-Verbose "[$(Get-Date)] Creating adoc help files. You may need to press Enter to force the process to continue."

#create the adoc files and then edit them.
$prog.Status = "Converting markdown to adoc files"
$prog.CurrentOperation =
$i = 0
$helpMD = Get-ChildItem $ModulePath\docs\*-*.md

$helpmd | ForEach-Object {
  $i++
  $prog.CurrentOperation = $_.FullName
  $prog.percentComplete = ($i/$helpmd.count)*100
  Write-Progress @prog
  ConvertTo-Adoc -Fullname $_.fullname -passthru -theme $data.codeTheme | Edit-Adoc
}

$prog.status = "Building main document"
Write-Verbose "[$(Get-Date)] Add include links to the main document"
$adocs = Get-ChildItem $ModulePath\docs\*.adoc -OutVariable ov | Sort-Object -property Name

$i = 0
ForEach ($item in $adocs) {
  $i++
  $prog.CurrentOperation = $item.name
  $prog.percentComplete = ($i/$adocs.count)*100
  Write-Progress @prog
  Write-Verbose "[$(Get-Date)] Adding $($item.name)"
  $main += @"

include::docs\$($item.name)[]

"@
}

$out = Join-Path -path $ModulePath -child "$($data.name).adoc"
$prog.status = "Finalizing"
$prog.CurrentOperation = $out
Write-Progress @prog
Write-Verbose "[$(Get-Date)] Saving document to $out"
$main | Out-File -FilePath $out -Encoding utf8

Write-Progress -Activity $prog.Activity -Completed
Write-Host
$msg = "Edit and review the adoc files and then run makepdf.ps1. Also edit pdf-theme.yml with the updated version number for page headers."
Write-Host $msg -ForegroundColor Cyan

Write-Verbose "[$(Get-Date)] Finished."